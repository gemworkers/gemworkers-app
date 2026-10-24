import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/consignor.dart';

/// Owner-only owners list (consignors RLS) and a stone's owner terms
/// (inventory_items.consignor_*; the DB refuses anyone but the owner).
class ConsignorRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Consignor>> getAll() async {
    final rows = await supabase.from('consignors').select().order('name');
    return rows.map<Consignor>((r) => Consignor.fromMap(r)).toList();
  }

  Future<void> save(Consignor c) async {
    if (c.id == null) {
      await supabase.from('consignors').insert(c.toMap());
    } else {
      await supabase.from('consignors').update(c.toMap()).eq('id', c.id!);
    }
  }

  /// Sets whose stone this is. [consignorId] null = GemWorkers' own stone.
  /// The listed price is saved in the same update, so lowering both the owner's
  /// price and the price never trips the "below the owner's price" check.
  Future<void> setItemConsignment(
    String itemId, {
    required String? consignorId,
    required double? consignorPrice,
    required double? profitShare,
    required double? sellingPrice,
  }) async {
    await supabase.from('inventory_items').update({
      'consignor_id': consignorId,
      'consignor_price': consignorId == null ? null : consignorPrice,
      'profit_share': consignorId == null ? null : profitShare,
      'selling_price': ?sellingPrice,
    }).eq('id', itemId);
  }

  /// Postage actually paid for an order (consignment: extra postage beyond the
  /// buyer's shipping is deducted from the profit before the split).
  Future<void> setPostagePaid(String orderId, double? postage) async {
    await supabase.from('orders').update({'postage_paid': postage}).eq('id', orderId);
  }
}
