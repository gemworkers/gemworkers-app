import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/review.dart';
import '../../repositories/review_repository.dart';
import '../../theme/app_theme.dart';

enum _ReviewsTab {
  pending('Waiting', 'pending', 'No reviews waiting for you.'),
  approved('Approved', 'approved', 'No approved reviews yet.'),
  hidden('Hidden', 'hidden', 'No hidden reviews.');

  final String label;
  final String status;
  final String emptyMessage;
  const _ReviewsTab(this.label, this.status, this.emptyMessage);
}

/// Owner only. Approve, hide and reply to buyer reviews. Only approved
/// reviews show on the store's Reviews page and maker profiles.
class ReviewsPage extends StatefulWidget {
  final VoidCallback? onPendingChanged;
  const ReviewsPage({super.key, this.onPendingChanged});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with SingleTickerProviderStateMixin {
  final _repository = ReviewRepository();
  late final TabController _tabController;

  List<Review> _reviews = [];
  bool _loading = true;
  String? _saving;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _ReviewsTab.values.length, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final reviews = await _repository.getReviews();
      if (mounted) setState(() { _reviews = reviews; _loading = false; _saving = null; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
    widget.onPendingChanged?.call();
  }

  void _error(Object e) {
    if (!mounted) return;
    setState(() => _saving = null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e is PostgrestException ? e.message : e.toString()),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  Future<void> _setStatus(Review r, String status) async {
    setState(() => _saving = r.id);
    try {
      await _repository.setStatus(r.id, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status == 'approved'
            ? 'Approved — the review is now on the store.'
            : 'Hidden — the review is not shown on the store.'),
      ));
      _load();
    } catch (e) {
      _error(e);
    }
  }

  Future<void> _reply(Review r) async {
    final controller = TextEditingController(text: r.ownerReply);
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reply as GemWorkers'),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 5,
            maxLength: 1000,
            decoration: const InputDecoration(
              hintText: 'Shown under the review on the store. Leave empty to remove.',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Save reply')),
        ],
      ),
    );
    controller.dispose();
    if (text == null || !mounted) return;
    setState(() => _saving = r.id);
    try {
      await _repository.setReply(r.id, text);
      _load();
    } catch (e) {
      _error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            for (final t in _ReviewsTab.values)
              Tab(
                text:
                    '${t.label}  ${_reviews.where((r) => r.status == t.status).length}',
              ),
          ],
        ),
      ),
      body: _loading && _reviews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                for (final t in _ReviewsTab.values) _buildList(t),
              ],
            ),
    );
  }

  Widget _buildList(_ReviewsTab tab) {
    final list = _reviews.where((r) => r.status == tab.status).toList();
    if (list.isEmpty) {
      return Center(
        child: Text(tab.emptyMessage,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.muted)),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _ReviewCard(
          review: list[i],
          saving: _saving == list[i].id,
          onApprove: _saving == null && list[i].status != 'approved'
              ? () => _setStatus(list[i], 'approved')
              : null,
          onHide: _saving == null && list[i].status != 'hidden'
              ? () => _setStatus(list[i], 'hidden')
              : null,
          onReply: _saving == null ? () => _reply(list[i]) : null,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  final bool saving;
  final VoidCallback? onApprove;
  final VoidCallback? onHide;
  final VoidCallback? onReply;

  const _ReviewCard({
    required this.review,
    required this.saving,
    required this.onApprove,
    required this.onHide,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final r = review;
    final who = [
      r.reviewerName.isNotEmpty ? r.reviewerName : 'Customer',
      if (r.reviewerCountry.isNotEmpty) r.reviewerCountry,
    ].join(', ');
    final date = DateFormat('d MMM y, HH:mm').format(r.createdAt.toLocal());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '★' * r.rating + '☆' * (5 - r.rating),
                style: const TextStyle(
                    fontSize: 18, color: Color(0xFFB8860B), letterSpacing: 2),
              ),
              const Spacer(),
              Text(date,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 6),
          Text(who, style: textTheme.titleSmall),
          Text(
            [
              if (r.stoneTitle.isNotEmpty) r.stoneTitle,
              if (r.stoneSku.isNotEmpty) r.stoneSku,
              if (r.orderNumber.isNotEmpty) r.orderNumber,
            ].join(' · '),
            style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          if (r.body.isNotEmpty) ...[
            const SizedBox(height: 10),
            SelectableText(r.body, style: textTheme.bodyMedium),
          ],
          if (r.photoUrl != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(r.photoUrl!,
                  height: 160, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink()),
            ),
          ],
          if (r.ownerReply.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.raised,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Your reply: ${r.ownerReply}',
                  style: textTheme.bodySmall),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (r.status != 'approved')
                FilledButton(
                  onPressed: onApprove,
                  child: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Approve'),
                ),
              if (r.status != 'hidden')
                OutlinedButton(onPressed: onHide, child: const Text('Hide')),
              TextButton(
                onPressed: onReply,
                child: Text(r.ownerReply.isEmpty ? 'Reply' : 'Edit reply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
