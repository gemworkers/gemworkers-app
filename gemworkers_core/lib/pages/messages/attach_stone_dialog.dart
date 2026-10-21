import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/message.dart';
import '../../repositories/messages_repository.dart';
import '../../theme/app_theme.dart';

/// Picks a listed + available stone to attach to the next reply.
/// Sellers see their own stones; the owner sees every seller's.
Future<AttachableStone?> showAttachStoneDialog(BuildContext context) {
  return showDialog<AttachableStone>(
    context: context,
    builder: (_) => const _AttachStoneDialog(),
  );
}

class _AttachStoneDialog extends StatefulWidget {
  const _AttachStoneDialog();

  @override
  State<_AttachStoneDialog> createState() => _AttachStoneDialogState();
}

class _AttachStoneDialogState extends State<_AttachStoneDialog> {
  final _repository = MessagesRepository();
  final _searchController = TextEditingController();

  List<AttachableStone> _stones = [];
  bool _loading = true;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final svc = UserProfileService.instance;
    try {
      final stones = await _repository.fetchAttachableStones(
        sellerId: svc.shouldFilterBySeller ? svc.sellerId : null,
      );
      if (mounted) {
        setState(() {
          _stones = stones;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        setState(() {
          _error = "Couldn't load your stones. Please try again.";
          _loading = false;
        });
      }
    }
  }

  List<AttachableStone> get _visible {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _stones;
    return _stones
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.sku.toLowerCase().contains(q))
        .toList();
  }

  static String _money(double v) =>
      NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 2)
          .format(v);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visible = _visible;

    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Text(_error!,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.error)),
      );
    } else if (visible.isEmpty) {
      body = Center(
        child: Text(
          _stones.isEmpty
              ? 'No listed, available stones to attach.'
              : 'No stones match "${_query.trim()}".',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      );
    } else {
      body = ListView.separated(
        itemCount: visible.length,
        separatorBuilder: (_, _) =>
            const Divider(color: AppColors.rowDivider, height: 1),
        itemBuilder: (_, i) {
          final stone = visible[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: _SmallThumb(stone.imageUrl),
            title: Text(
              stone.title.isNotEmpty ? stone.title : 'Untitled stone',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: stone.sku.isNotEmpty
                ? Text(stone.sku,
                    style:
                        textTheme.bodySmall?.copyWith(color: AppColors.muted))
                : null,
            trailing: stone.price != null
                ? Text(_money(stone.price!),
                    style: AppTheme.numeric(textTheme.bodyMedium))
                : null,
            onTap: () => Navigator.pop(context, stone),
          );
        },
      );
    }

    return AlertDialog(
      title: const Text('Attach a stone'),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      content: SizedBox(
        width: 520,
        height: 480,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search by title or SKU',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            Expanded(child: body),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _SmallThumb extends StatelessWidget {
  final String? url;
  const _SmallThumb(this.url);

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.raised,
      child: Center(
        child: Icon(Icons.diamond_outlined, size: 20, color: AppColors.muted),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 44,
        height: 44,
        child: url != null
            ? Image.network(url!,
                fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder)
            : placeholder,
      ),
    );
  }
}
