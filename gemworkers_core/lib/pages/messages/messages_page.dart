import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../core/utils/money.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/messages_repository.dart';
import '../../theme/app_theme.dart';
import '../inventory/inventory_detail_page.dart';
import 'attach_stone_dialog.dart';

const _maxBodyLength = 2000;
const _threadRefreshInterval = Duration(seconds: 20);

/// Split view from this page width; below it the list and the thread each
/// take the full width.
const _splitBreakpoint = 760.0;

String _formatMoney(double v) =>
    NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 2)
        .format(v);

/// Inbox time: 14:05 today, 3 Oct this year, 3 Oct 2025 otherwise.
String _formatListTime(DateTime d) {
  final local = d.toLocal();
  final now = DateTime.now();
  if (local.year == now.year &&
      local.month == now.month &&
      local.day == now.day) {
    return DateFormat('HH:mm').format(local);
  }
  return DateFormat(local.year == now.year ? 'd MMM' : 'd MMM y')
      .format(local);
}

/// Bubble time: 14:05 today, otherwise with the date.
String _formatBubbleTime(DateTime d) {
  final local = d.toLocal();
  final now = DateTime.now();
  final time = DateFormat('HH:mm').format(local);
  if (local.year == now.year &&
      local.month == now.month &&
      local.day == now.day) {
    return time;
  }
  final day = DateFormat(local.year == now.year ? 'd MMM' : 'd MMM y')
      .format(local);
  return '$day, $time';
}

String _errorText(Object e) =>
    e is PostgrestException ? e.message : e.toString();

// ── Page ──────────────────────────────────────────────────────────────────────

class MessagesPage extends StatefulWidget {
  /// Called after a thread is marked read so the sidebar badge can refresh.
  final VoidCallback? onUnreadChanged;

  const MessagesPage({super.key, this.onUnreadChanged});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _repository = MessagesRepository();
  final _replyController = TextEditingController();
  final _threadScroll = ScrollController();

  // Inbox
  List<Conversation> _conversations = [];
  bool _loading = true;
  String? _loadError;
  bool _unreadOnly = false;

  // Open thread
  String? _selectedId;
  List<Message> _messages = [];
  Map<String, MessageStoneCard> _cards = {};
  bool _threadLoading = false;
  String? _threadError;

  // Reply box
  bool _sending = false;
  String? _sendError;
  AttachableStone? _attached;

  bool _statusSaving = false;
  bool _polling = false;
  Timer? _timer;

  bool get _isOwner => UserProfileService.instance.isOwner;

  @override
  void initState() {
    super.initState();
    _replyController.addListener(() => setState(() {}));
    _loadConversations();
    _timer = Timer.periodic(_threadRefreshInterval, (_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _replyController.dispose();
    _threadScroll.dispose();
    super.dispose();
  }

  /// Within ~120 px of the newest message (or nothing laid out yet).
  bool get _isNearBottom {
    if (!_threadScroll.hasClients) return true;
    final pos = _threadScroll.position;
    return pos.maxScrollExtent - pos.pixels <= 120;
  }

  /// Scrolls the thread to the newest message after the next layout. Runs a
  /// second pass in case the first frame's extent was still growing.
  void _scrollToBottom({bool animate = false}) {
    void go() {
      if (!mounted || !_threadScroll.hasClients) return;
      final target = _threadScroll.position.maxScrollExtent;
      if (animate) {
        _threadScroll.animateTo(target,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut);
      } else {
        _threadScroll.jumpTo(target);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      go();
      WidgetsBinding.instance.addPostFrameCallback((_) => go());
    });
  }

  Conversation? get _selected {
    final id = _selectedId;
    if (id == null) return null;
    for (final c in _conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Future<void> _loadConversations({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _loadError = null;
      });
    }
    try {
      final list =
          await _repository.fetchConversations(includeSellerName: _isOwner);
      final svc = UserProfileService.instance;
      final scoped = svc.shouldFilterBySeller
          ? list.where((c) => c.sellerId == svc.sellerId).toList()
          : list;
      if (mounted) {
        setState(() {
          _conversations = scoped;
          _loading = false;
          _loadError = null;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        setState(() {
          _loading = false;
          if (!silent) _loadError = "Couldn't load messages. Pull to retry.";
        });
      }
    }
  }

  /// Loads the open thread's messages + stone cards. Returns true when new
  /// buyer messages arrived since the previous load.
  ///
  /// Scrolls to the bottom on a full (non-silent) load, when [scrollToEnd],
  /// or when new messages arrive while already near the bottom.
  Future<bool> _loadThread(
    String id, {
    bool silent = false,
    bool scrollToEnd = false,
  }) async {
    if (!silent) {
      setState(() {
        _threadLoading = true;
        _threadError = null;
      });
    }
    try {
      final messages = await _repository.fetchMessages(id);
      final cardIds = <String>{
        for (final m in messages)
          if (m.linkedInventoryItemId != null) m.linkedInventoryItemId!,
      }..removeAll(_cards.keys);
      var cards = _cards;
      if (cardIds.isNotEmpty) {
        cards = {..._cards, ...await _repository.fetchStoneCards(cardIds)};
      }
      if (!mounted || _selectedId != id) return false;

      final previousIds = _messages.map((m) => m.id).toSet();
      final newBuyer = silent &&
          messages.any((m) => m.isFromBuyer && !previousIds.contains(m.id));
      final hasNew = messages.any((m) => !previousIds.contains(m.id));
      final wasNearBottom = _isNearBottom;
      setState(() {
        _messages = messages;
        _cards = cards;
        _threadLoading = false;
        _threadError = null;
      });
      if (!silent || scrollToEnd) {
        _scrollToBottom();
      } else if (hasNew && wasNearBottom) {
        _scrollToBottom(animate: true);
      }
      return newBuyer;
    } catch (e) {
      debugPrint(e.toString());
      if (mounted && _selectedId == id && !silent) {
        setState(() {
          _threadLoading = false;
          _threadError = "Couldn't load this conversation.";
        });
      }
      return false;
    }
  }

  Future<void> _markRead(String id) async {
    try {
      await _repository.markRead(id);
    } catch (e) {
      debugPrint(e.toString());
    }
    widget.onUnreadChanged?.call();
    await _loadConversations(silent: true);
  }

  /// Every 20 s: refresh the inbox and the open thread.
  Future<void> _poll() async {
    if (_polling || !mounted) return;
    _polling = true;
    try {
      final id = _selectedId;
      if (id != null) {
        final newBuyer = await _loadThread(id, silent: true);
        if (newBuyer && _selectedId == id) {
          await _markRead(id);
          return;
        }
      }
      await _loadConversations(silent: true);
    } finally {
      _polling = false;
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _open(Conversation c) async {
    if (_selectedId == c.id) return;
    setState(() {
      _selectedId = c.id;
      _messages = [];
      _sendError = null;
      _attached = null;
      _replyController.clear();
    });
    await _loadThread(c.id);
    if (mounted && _selectedId == c.id) await _markRead(c.id);
  }

  void _closeThread() => setState(() => _selectedId = null);

  Future<void> _send() async {
    final conv = _selected;
    final body = _replyController.text.trim();
    if (conv == null || body.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _sendError = null;
    });
    try {
      await _repository.sendStaffMessage(conv.id, body,
          linkedItemId: _attached?.id);
      if (!mounted) return;
      setState(() {
        _sending = false;
        _attached = null;
        _replyController.clear();
      });
      await _loadThread(conv.id, silent: true, scrollToEnd: true);
      await _loadConversations(silent: true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _sending = false;
          _sendError = _errorText(e);
        });
      }
    }
  }

  Future<void> _attach() async {
    final stone = await showAttachStoneDialog(context);
    if (stone != null && mounted) setState(() => _attached = stone);
  }

  Future<void> _setStatus(Conversation conv, String status) async {
    if (status == 'blocked') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Block this conversation?'),
          content: Text(
            '${conv.buyerLabel} won\'t be able to send further messages in '
            'this conversation. They\'ll see it as closed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Block'),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }

    setState(() => _statusSaving = true);
    try {
      await _repository.setStatus(conv.id, status);
      await _loadConversations(silent: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(switch (status) {
            'closed' => 'Conversation closed.',
            'blocked' => 'Conversation blocked.',
            _ => 'Conversation reopened.',
          }),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_errorText(e)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _statusSaving = false);
    }
  }

  Future<void> _openListing(String itemId) async {
    try {
      final item = await InventoryRepository().getItem(itemId);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InventoryDetailPage(item: item)),
      );
      if (mounted) _loadConversations(silent: true);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("This listing can't be opened."),
        ));
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final split = constraints.maxWidth >= _splitBreakpoint;
        final selected = _selected;

        if (!split) {
          return selected != null
              ? _buildThread(selected, showBack: true)
              : _buildInbox(wide: false);
        }

        final listWidth = constraints.maxWidth >= 1200 ? 400.0 : 340.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: listWidth, child: _buildInbox(wide: true)),
            const VerticalDivider(width: 1),
            Expanded(
              child: selected != null
                  ? _buildThread(selected, showBack: false)
                  : const _NoThreadSelected(),
            ),
          ],
        );
      }),
    );
  }

  // ── Inbox ─────────────────────────────────────────────────────────────────

  Widget _buildInbox({required bool wide}) {
    final textTheme = Theme.of(context).textTheme;
    final unreadCount =
        _conversations.where((c) => c.isUnreadFor(isOwner: _isOwner)).length;
    // Keep the open thread in the Unread list after it has been read.
    final visible = _unreadOnly
        ? _conversations
            .where((c) =>
                c.isUnreadFor(isOwner: _isOwner) || c.id == _selectedId)
            .toList()
        : _conversations;

    final Widget list;
    if (_loading && _conversations.isEmpty) {
      list = const Center(child: CircularProgressIndicator());
    } else if (_loadError != null && _conversations.isEmpty) {
      list = _CenteredMessage(_loadError!, scrollable: true);
    } else if (visible.isEmpty) {
      list = _CenteredMessage(
        _unreadOnly
            ? "No unread messages — you're all caught up."
            : 'No messages yet. Buyers\' questions about your stones will '
                'appear here.',
        scrollable: true,
      );
    } else {
      list = ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: visible.length,
        separatorBuilder: (_, _) => const Divider(
            color: AppColors.rowDivider, height: 1, indent: 16, endIndent: 16),
        itemBuilder: (_, i) {
          final c = visible[i];
          return _ConversationTile(
            conversation: c,
            unread: c.isUnreadFor(isOwner: _isOwner),
            selected: c.id == _selectedId,
            showSeller: _isOwner,
            onTap: () => _open(c),
          );
        },
      );
    }

    return ColoredBox(
      color: wide ? AppColors.surface : AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(wide ? 24 : 16, wide ? 28 : 20,
                wide ? 24 : 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: textTheme.headlineLarge
                      ?.copyWith(fontSize: wide ? 36 : 30, height: 1.1),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text('All  ${_conversations.length}'),
                      selected: !_unreadOnly,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _unreadOnly = false),
                    ),
                    ChoiceChip(
                      label: Text('Unread  $unreadCount'),
                      selected: _unreadOnly,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _unreadOnly = true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadConversations(silent: true),
              child: list,
            ),
          ),
        ],
      ),
    );
  }

  // ── Thread ────────────────────────────────────────────────────────────────

  Widget _buildThread(Conversation conv, {required bool showBack}) {
    final Widget body;
    if (_threadLoading && _messages.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_threadError != null && _messages.isEmpty) {
      body = _CenteredMessage(_threadError!);
    } else if (_messages.isEmpty) {
      body = const _CenteredMessage('No messages in this conversation yet.');
    } else {
      // Oldest at the top, newest just above the reply box.
      body = ListView.builder(
        controller: _threadScroll,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        itemCount: _messages.length,
        itemBuilder: (_, i) {
          final m = _messages[i];
          if (m.isOfferCard) return _OfferCard(message: m);
          final linkedId = m.linkedInventoryItemId;
          return _MessageBubble(
            message: m,
            senderLabel: _senderLabel(conv, m),
            card: linkedId != null ? _cards[linkedId] : null,
            onOpenCard: linkedId != null ? () => _openListing(linkedId) : null,
          );
        },
      );
    }

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ThreadHeader(
            conversation: conv,
            showBack: showBack,
            showSeller: _isOwner,
            onBack: _closeThread,
            onOpenStone: conv.inventoryItemId != null
                ? () => _openListing(conv.inventoryItemId!)
                : null,
            statusMenu: _isOwner ? _buildStatusMenu(conv) : null,
          ),
          Expanded(child: body),
          const Divider(),
          conv.isOpen ? _buildComposer() : _ClosedNotice(conv),
        ],
      ),
    );
  }

  /// Buyer → first name; the viewer's own role → "You"; otherwise "Owner" or
  /// the seller's shop name.
  String _senderLabel(Conversation conv, Message m) {
    if (m.isFromBuyer) return conv.buyerLabel;
    if (m.senderRole == (_isOwner ? 'owner' : 'seller')) return 'You';
    if (m.senderRole == 'owner') return 'Owner';
    return conv.sellerName.isNotEmpty ? conv.sellerName : 'Seller';
  }

  Widget _buildStatusMenu(Conversation conv) {
    if (_statusSaving) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return PopupMenuButton<String>(
      tooltip: 'Conversation options',
      icon: const Icon(Icons.more_vert),
      onSelected: (s) => _setStatus(conv, s),
      itemBuilder: (_) => [
        if (conv.status != 'open')
          const PopupMenuItem(
            value: 'open',
            child: _MenuRow(Icons.lock_open_outlined, 'Reopen'),
          ),
        if (conv.status != 'closed')
          const PopupMenuItem(
            value: 'closed',
            child: _MenuRow(Icons.lock_outline, 'Close'),
          ),
        if (conv.status != 'blocked')
          const PopupMenuItem(
            value: 'blocked',
            child: _MenuRow(Icons.block, 'Block', color: AppColors.error),
          ),
      ],
    );
  }

  Widget _buildComposer() {
    final textTheme = Theme.of(context).textTheme;
    final canSend = _replyController.text.trim().isNotEmpty && !_sending;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_sendError != null) ...[
            Text(
              _sendError!,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
          ],
          if (_attached != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: InputChip(
                avatar: const Icon(Icons.diamond_outlined, size: 18),
                label: Text(
                  [
                    _attached!.title.isNotEmpty
                        ? _attached!.title
                        : 'Untitled stone',
                    if (_attached!.sku.isNotEmpty) _attached!.sku,
                  ].join(' · '),
                  overflow: TextOverflow.ellipsis,
                ),
                tooltip: 'Attached stone',
                deleteButtonTooltipMessage: 'Remove',
                onDeleted:
                    _sending ? null : () => setState(() => _attached = null),
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: _replyController,
            enabled: !_sending,
            minLines: 2,
            maxLines: 6,
            maxLength: _maxBodyLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Write a reply…'),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _sending ? null : _attach,
                icon: const Icon(Icons.diamond_outlined, size: 18),
                label: Text(_attached == null
                    ? 'Attach a stone'
                    : 'Change stone'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: canSend ? _send : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(110, 44),
                ),
                child: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _NoThreadSelected extends StatelessWidget {
  const _NoThreadSelected();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.forum_outlined, size: 40, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(
              'Select a conversation to read and reply.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String message;

  /// Wrap in a scroll view so RefreshIndicator works on an empty list.
  final bool scrollable;
  const _CenteredMessage(this.message, {this.scrollable = false});

  @override
  Widget build(BuildContext context) {
    final text = Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 64),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.muted),
      ),
    );
    if (!scrollable) return Center(child: text);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [text],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _MenuRow(this.icon, this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final bool unread;
  final bool selected;
  final bool showSeller;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.unread,
    required this.selected,
    required this.showSeller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final c = conversation;
    final stoneLine = [
      c.stoneTitle.isNotEmpty ? c.stoneTitle : 'Unknown stone',
      if (c.stoneSku.isNotEmpty) c.stoneSku,
    ].join(' · ');
    final preview = c.lastMessagePreview.isEmpty
        ? ''
        : (c.lastMessageRole != null &&
                    c.lastMessageRole != 'buyer' &&
                    c.lastMessageRole != 'system'
                ? 'Reply: '
                : '') +
            c.lastMessagePreview.replaceAll(RegExp(r'\s+'), ' ');

    return Material(
      color: selected ? AppColors.raised : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.raised.withValues(alpha: 0.6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoneThumb(c.stoneImageUrl, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            c.buyerLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatListTime(c.lastMessageAt),
                          style: AppTheme.numeric(
                            textTheme.bodySmall,
                            color: unread ? AppColors.ink : AppColors.muted,
                          ).copyWith(
                              fontWeight:
                                  unread ? FontWeight.w600 : FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stoneLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                    if (preview.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              preview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: unread
                                    ? AppColors.ink
                                    : AppColors.textSecondary,
                                fontWeight: unread
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (unread)
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 6),
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                    if ((showSeller && c.sellerName.isNotEmpty) ||
                        !c.isOpen) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (showSeller && c.sellerName.isNotEmpty)
                            _Tag(c.sellerName, icon: Icons.store_outlined),
                          if (!c.isOpen)
                            _Tag(
                              c.status == 'blocked' ? 'Blocked' : 'Closed',
                              color: c.status == 'blocked'
                                  ? AppColors.error
                                  : AppColors.muted,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  const _Tag(this.label, {this.icon, this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: const ShapeDecoration(
        color: AppColors.raised,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadHeader extends StatelessWidget {
  final Conversation conversation;
  final bool showBack;
  final bool showSeller;
  final VoidCallback onBack;
  final VoidCallback? onOpenStone;
  final Widget? statusMenu;

  const _ThreadHeader({
    required this.conversation,
    required this.showBack,
    required this.showSeller,
    required this.onBack,
    required this.onOpenStone,
    required this.statusMenu,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final c = conversation;
    final statusLabel = c.stoneStatusLabel;
    final statusColor = switch (statusLabel) {
      'Listed' => AppColors.success,
      'Reserved' => AppColors.accent,
      _ => AppColors.muted,
    };

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(showBack ? 4 : 16, 12, 8, 12),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              tooltip: 'Back to inbox',
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
          Expanded(
            child: InkWell(
              onTap: onOpenStone,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _StoneThumb(c.stoneImageUrl, size: 60),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.stoneTitle.isNotEmpty
                                ? c.stoneTitle
                                : 'Unknown stone',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (c.stoneSku.isNotEmpty) c.stoneSku,
                              'with ${c.buyerLabel}',
                              if (showSeller && c.sellerName.isNotEmpty)
                                c.sellerName,
                            ].join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall
                                ?.copyWith(color: AppColors.muted),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (c.stonePrice != null)
                                Text(
                                  _formatMoney(c.stonePrice!),
                                  style: AppTheme.numeric(textTheme.bodyMedium,
                                      color: AppColors.ink),
                                ),
                              if (statusLabel.isNotEmpty)
                                _Tag(statusLabel, color: statusColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (onOpenStone != null)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.chevron_right,
                            color: AppColors.muted),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (statusMenu != null) ...[
            const SizedBox(width: 4),
            statusMenu!,
          ],
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final String senderLabel;
  final MessageStoneCard? card;
  final VoidCallback? onOpenCard;

  const _MessageBubble({
    required this.message,
    required this.senderLabel,
    required this.card,
    required this.onOpenCard,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fromBuyer = message.isFromBuyer;
    const radius = Radius.circular(16);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: fromBuyer ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment:
                fromBuyer ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: senderLabel,
                      style: const TextStyle(
                          color: AppColors.ink, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: '  ${_formatBubbleTime(message.createdAt)}'),
                  ]),
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: fromBuyer ? AppColors.surface : AppColors.raised,
                  border: Border.all(
                      color: fromBuyer ? AppColors.border : AppColors.raised),
                  borderRadius: BorderRadius.only(
                    topLeft: fromBuyer ? const Radius.circular(4) : radius,
                    topRight: fromBuyer ? radius : const Radius.circular(4),
                    bottomLeft: radius,
                    bottomRight: radius,
                  ),
                ),
                child: SelectableText(
                  message.body,
                  style: textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ),
              if (message.linkedInventoryItemId != null) ...[
                const SizedBox(height: 6),
                _LinkedStoneCard(card: card, onTap: onOpenCard),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Offer event written by the offer trigger: centred card with the event and
/// amount. Unknown kinds (added later, e.g. counter-offers) show the row's
/// own body text.
class _OfferCard extends StatelessWidget {
  final Message message;

  const _OfferCard({required this.message});

  static const _titles = {
    'offer_made':      'Offer received',
    'offer_accepted':  'Offer accepted',
    'offer_declined':  'Offer declined',
    'offer_expired':   'Offer expired',
    'offer_withdrawn': 'Buyer withdrew the offer',
    'offer_countered':  'Counter-offer sent',
    'counter_accepted': 'Buyer accepted the counter-offer',
    'counter_declined': 'Buyer declined the counter-offer',
    'counter_expired':  'Counter-offer expired',
    // Returns (sql/returns_cards_sweep.sql): the body line is shown below.
    'return_requested': 'Return requested',
    'return_approved':  'Return approved',
    'return_rejected':  'Return declined',
    'return_received':  'Return received',
    'return_refunded':  'Refunded',
    'return_withdrawn': 'Buyer cancelled the return',
    'return_reminder':  'Return reminder sent',
    'return_expired':   'Return closed (not sent back)',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title = _titles[message.kind];
    final amount = message.offerAmount;
    final accepted = const {'offer_accepted', 'counter_accepted', 'return_refunded'}
        .contains(message.kind);
    final closed = const {
      'offer_declined', 'offer_expired', 'offer_withdrawn',
      'counter_declined', 'counter_expired',
    }.contains(message.kind);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accepted
                  ? AppColors.success.withValues(alpha: 0.08)
                  : AppColors.raised,
              border: Border.all(
                  color: accepted
                      ? AppColors.success.withValues(alpha: 0.3)
                      : AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  (title ?? message.body).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: accepted ? AppColors.success : AppColors.accent,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                if (title != null && amount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    formatEur(amount),
                    style: textTheme.titleLarge?.copyWith(
                      color: closed ? AppColors.muted : AppColors.ink,
                      decoration: closed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
                if (title != null && message.kind.startsWith('return_')) ...[
                  const SizedBox(height: 4),
                  Text(
                    message.body,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatBubbleTime(message.createdAt),
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkedStoneCard extends StatelessWidget {
  final MessageStoneCard? card;
  final VoidCallback? onTap;
  const _LinkedStoneCard({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final c = card;
    final statusLabel = switch (c?.status) {
      'available' => 'Available',
      'reserved' => 'Reserved',
      _ => 'No longer available',
    };
    final statusColor = switch (c?.status) {
      'available' => AppColors.success,
      'reserved' => AppColors.accent,
      _ => AppColors.muted,
    };

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 280,
            child: Row(
              children: [
                _StoneThumb(c?.imageUrl, size: 48),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c == null
                            ? 'Attached stone'
                            : (c.title.isNotEmpty ? c.title : 'Untitled stone'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (c?.price != null) ...[
                            Text(
                              _formatMoney(c!.price!),
                              style: AppTheme.numeric(textTheme.bodySmall,
                                  color: AppColors.ink),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              statusLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClosedNotice extends StatelessWidget {
  final Conversation conversation;
  const _ClosedNotice(this.conversation);

  @override
  Widget build(BuildContext context) {
    final blocked = conversation.status == 'blocked';
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          Icon(blocked ? Icons.block : Icons.lock_outline,
              size: 20, color: blocked ? AppColors.error : AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              blocked
                  ? 'This conversation is blocked. No new messages can be sent.'
                  : 'This conversation is closed. No new messages can be sent.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoneThumb extends StatelessWidget {
  final String? url;
  final double size;
  const _StoneThumb(this.url, {required this.size});

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AppColors.raised,
      child: Center(
        child: Icon(Icons.diamond_outlined,
            size: size * 0.4, color: AppColors.muted),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(size >= 56 ? 12 : 8),
      child: SizedBox(
        width: size,
        height: size,
        child: url != null
            ? Image.network(url!,
                fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder)
            : placeholder,
      ),
    );
  }
}
