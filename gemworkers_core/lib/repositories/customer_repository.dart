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
