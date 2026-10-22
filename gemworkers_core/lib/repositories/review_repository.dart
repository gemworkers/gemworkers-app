import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/review.dart';

/// Owner-only review moderation (sql/reviews_setup.sql: reviews_owner RLS).
/// Buyers write reviews through submit_review on the store.
class ReviewRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Review>> getReviews() async {
    final response = await supabase
        .from('reviews')
        .select('*, inventory_items(title, sku), orders(order_number)')
        .order('created_at', ascending: false)
        .limit(500);
    return response.map<Review>((row) => Review.fromMap(row)).toList();
  }

  /// [status] is 'approved' or 'hidden'.
  Future<void> setStatus(String id, String status) async {
    await supabase.from('reviews').update({
      'status': status,
      'moderated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  /// Empty [reply] removes the reply.
  Future<void> setReply(String id, String reply) async {
    final text = reply.trim();
    await supabase.from('reviews').update({
      'owner_reply': text.isEmpty ? null : text,
      'replied_at': text.isEmpty ? null : DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<int> getPendingCount() async {
    final response =
        await supabase.from('reviews').select('id').eq('status', 'pending');
    return response.length;
  }
}
