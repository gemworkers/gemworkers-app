import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/customer.dart';

class CustomerRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Customer>> getCustomers() async {
    final response = await supabase
        .from('customers')
        .select()
        .order('name');
    return response.map<Customer>((row) => Customer.fromMap(row)).toList();
  }

  /// Manual customers plus website buyers (all_customers view), for the
  /// Customers page. Manual rows come from `customers` itself so they keep
  /// phone/type/notes/tier for the detail page. If the view isn't there yet
  /// (sql/all_customers_view.sql not applied) the list is manual-only.
  Future<List<Customer>> getAllCustomers() async {
    final results = await Future.wait([
      getCustomers(),
      _getWebsiteCustomers(),
    ]);
    return [...results[0], ...results[1]];
  }

  Future<List<Customer>> _getWebsiteCustomers() async {
    try {
      final response = await supabase
          .from('all_customers')
          .select()
          .eq('source', 'website');
      return response.map<Customer>((row) => Customer.fromMap(row)).toList();
    } catch (e) {
      debugPrint('all_customers unavailable, showing manual only: $e');
      return [];
    }
  }

  Future<Customer> addCustomer(Customer customer) async {
    final response = await supabase
        .from('customers')
        .insert(customer.toMap())
        .select()
        .single();
    return Customer.fromMap(response);
  }

  Future<void> updateCustomer(String id, Customer customer) async {
    await supabase.from('customers').update(customer.toMap()).eq('id', id);
  }

  Future<void> deleteCustomer(String id) async {
    await supabase.from('customers').delete().eq('id', id);
  }

  Future<int> getCustomerCount() async {
    final response = await supabase.from('customers').select('id');
    return (response as List).length;
  }
}
