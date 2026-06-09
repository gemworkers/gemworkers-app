import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/branch.dart';

class BranchRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Branch>> getBranches() async {
    final response =
        await _supabase.from('branches').select().order('name');
    return response.map<Branch>((row) => Branch.fromMap(row)).toList();
  }

  Future<Branch> getBranch(String id) async {
    final response = await _supabase
        .from('branches')
        .select()
        .eq('id', id)
        .single();
    return Branch.fromMap(response);
  }

  Future<Branch> addBranch(Branch branch) async {
    final response = await _supabase
        .from('branches')
        .insert(branch.toMap())
        .select()
        .single();
    return Branch.fromMap(response);
  }

  Future<void> updateBranch(String id, Branch branch) async {
    await _supabase.from('branches').update(branch.toMap()).eq('id', id);
  }

  Future<void> deleteBranch(String id) async {
    await _supabase.from('branches').delete().eq('id', id);
  }

  /// Count of inventory items belonging to this branch.
  Future<int> getInventoryCount(String branchId) async {
    final response = await _supabase
        .from('inventory_items')
        .select('id')
        .eq('branch_id', branchId);
    return (response as List).length;
  }

  /// Count of paid orders belonging to this branch.
  Future<int> getSalesCount(String branchId) async {
    final response = await _supabase
        .from('orders')
        .select('id')
        .eq('branch_id', branchId)
        .eq('status', 'paid');
    return (response as List).length;
  }
}
