import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/user_profile_service.dart';
import '../models/supplier.dart';

class SupplierRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Returns suppliers filtered by [sellerId] when provided.
  /// Pass null to get all suppliers (owner view).
  Future<List<Supplier>> getSuppliers({String? sellerId}) async {
    final response = sellerId != null
        ? await supabase
            .from('suppliers')
            .select()
            .eq('seller_id', sellerId)
            .order('name')
        : await supabase.from('suppliers').select().order('name');
    return response.map<Supplier>((row) => Supplier.fromMap(row)).toList();
  }

  /// Inserts and returns the server-created row (with assigned id).
  /// seller_id is always injected from UserProfileService — not from the form.
  Future<Supplier> addSupplier(Supplier supplier) async {
    final map = supplier.toMap();
    map['seller_id'] = UserProfileService.instance.effectiveSellerId;
    final response = await supabase
        .from('suppliers')
        .insert(map)
        .select()
        .single();
    return Supplier.fromMap(response);
  }

  Future<void> updateSupplier(String id, Supplier supplier) async {
    // toMap() excludes seller_id — the DB value is never changed on update.
    await supabase
        .from('suppliers')
        .update(supplier.toMap())
        .eq('id', id);
  }

  Future<void> deleteSupplier(String id) async {
    await supabase.from('suppliers').delete().eq('id', id);
  }
}
