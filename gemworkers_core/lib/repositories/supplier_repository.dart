import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/supplier.dart';

class SupplierRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Supplier>> getSuppliers() async {
    final response = await supabase
        .from('suppliers')
        .select()
        .order('name');
    return response
        .map<Supplier>((row) => Supplier.fromMap(row))
        .toList();
  }

  /// Inserts and returns the server-created row (with assigned id).
  Future<Supplier> addSupplier(Supplier supplier) async {
    final response = await supabase
        .from('suppliers')
        .insert(supplier.toMap())
        .select()
        .single();
    return Supplier.fromMap(response);
  }

  Future<void> updateSupplier(String id, Supplier supplier) async {
    await supabase
        .from('suppliers')
        .update(supplier.toMap())
        .eq('id', id);
  }

  Future<void> deleteSupplier(String id) async {
    await supabase.from('suppliers').delete().eq('id', id);
  }
}
