import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/commission.dart';
import '../models/conversation.dart';
import '../models/message.dart';

/// Staff side of the message portal. Reads conversations / messages directly —
/// RLS scopes sellers to their own (seller_id = current_seller_id()) and lets
/// the owner see everything. All writes except the owner's status changes go
/// through the SECURITY DEFINER functions in sql/messaging_setup.sql.
/// The buyers table is never queried: the buyer is buyer_first_name only.
class MessagesRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Conversations, newest activity first, with the stone, the latest message
  /// and the latest buyer message (for unread). [includeSellerName] embeds
  /// sellers(name) — owner only.
  Future<List<Conversation>> fetchConversations({
    bool includeSellerName = false,
  }) async {
    final response = await supabase
        .from('conversations')
        .select('*, '
            'inventory_items(title, sku, image_urls, selling_price, status, is_listed), '
            '${includeSellerName ? 'sellers(name), ' : ''}'
            'last_message:messages(body, sender_role, created_at), '
            'last_buyer_message:messages(created_at)')
        .eq('last_buyer_message.sender_role', 'buyer')
        .order('created_at', referencedTable: 'last_message', ascending: false)
        .limit(1, referencedTable: 'last_message')
        .order('created_at',
            referencedTable: 'last_buyer_message', ascending: false)
        .limit(1, referencedTable: 'last_buyer_message')
        .order('last_message_at', ascending: false)
        .limit(500);

    return response
        .map<Conversation>((row) => Conversation.fromMap(row))
        .toList();
  }

  /// All messages in a conversation, oldest first.
  Future<List<Message>> fetchMessages(String conversationId) async {
    final response = await supabase
        .from('messages')
        .select('id, conversation_id, sender_role, body, '
            'linked_inventory_item_id, created_at')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    return response.map<Message>((row) => Message.fromMap(row)).toList();
  }

  /// Card data for linked stones, keyed by id. Ids outside the caller's own
  /// conversations are silently dropped by the function.
  Future<Map<String, MessageStoneCard>> fetchStoneCards(
      Iterable<String> ids) async {
    final unique = ids.toSet().toList();
    if (unique.isEmpty) return {};
    final result = await supabase
        .rpc('message_stone_cards', params: {'p_ids': unique});
    final rows = (result as List?) ?? const [];
    return {
      for (final row in rows.whereType<Map<String, dynamic>>())
        row['id'].toString(): MessageStoneCard.fromMap(row),
    };
  }

  /// Sends a staff reply. Throws PostgrestException with a friendly message
  /// (safe to show as-is) when a rule refuses it.
  Future<void> sendStaffMessage(
    String conversationId,
    String body, {
    String? linkedItemId,
  }) async {
    await supabase.rpc('send_staff_message', params: {
      'p_conversation_id': conversationId,
      'p_body':            body,
      'p_linked_item_id':  linkedItemId,
    });
  }

  /// Moves the caller's own read marker (seller or owner) to now.
  Future<void> markRead(String conversationId) async {
    await supabase.rpc('mark_conversation_read',
        params: {'p_conversation_id': conversationId});
  }

  /// Conversations with unread buyer messages for the caller.
  Future<int> getUnreadCount() async {
    final result = await supabase.rpc('staff_unread_count');
    if (result is Map) {
      return parseNumeric(result['conversations'])?.toInt() ?? 0;
    }
    return 0;
  }

  /// Owner only (RLS): 'open' | 'closed' | 'blocked'.
  Future<void> setStatus(String conversationId, String status) async {
    await supabase
        .from('conversations')
        .update({'status': status})
        .eq('id', conversationId);
  }

  /// Listed + available stones staff may attach. Pass [sellerId] to scope to
  /// one seller (RLS already does for sellers).
  Future<List<AttachableStone>> fetchAttachableStones(
      {String? sellerId}) async {
    var query = supabase
        .from('inventory_items')
        .select('id, title, sku, image_urls, selling_price')
        .eq('is_listed', true)
        .eq('status', 'available');
    if (sellerId != null) query = query.eq('seller_id', sellerId);
    final response = await query.order('listed_at', ascending: false);
    return response
        .map<AttachableStone>((row) => AttachableStone.fromMap(row))
        .toList();
  }
}
