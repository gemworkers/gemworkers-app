import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/location.dart';

class LocationRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// Flat list of all locations, ordered by name.
  /// Pass [sellerId] to scope to one seller; omit to fetch all (owner view).
  Future<List<Location>> getLocationsFlat([String? sellerId]) async {
    final List<dynamic> response;
    if (sellerId != null) {
      response = await _supabase
          .from('locations')
          .select()
          .eq('seller_id', sellerId)
          .order('name');
    } else {
      response = await _supabase.from('locations').select().order('name');
    }
    return response.map<Location>((row) => Location.fromMap(row)).toList();
  }

  /// Root nodes of the tree, with children populated recursively.
  Future<List<Location>> getTree([String? sellerId]) async {
    final flat = await getLocationsFlat(sellerId);
    return _buildTree(flat, null);
  }

  List<Location> _buildTree(List<Location> all, String? parentId) {
    return all
        .where((l) => l.parentId == parentId)
        .map((l) => l.copyWith(children: _buildTree(all, l.id)))
        .toList();
  }

  /// IDs of the location itself and all its descendants.
  Future<List<String>> getDescendantIds(
      String locationId, [String? sellerId]) async {
    final flat = await getLocationsFlat(sellerId);
    final ids = <String>[];
    _collectDescendants(flat, locationId, ids);
    return ids;
  }

  void _collectDescendants(List<Location> all, String id, List<String> ids) {
    ids.add(id);
    for (final child in all.where((l) => l.parentId == id)) {
      _collectDescendants(all, child.id!, ids);
    }
  }

  /// Human-readable breadcrumb from root to the given location.
  Future<String> getBreadcrumb(String locationId, [String? sellerId]) async {
    final flat = await getLocationsFlat(sellerId);
    final path = <String>[];
    _buildBreadcrumb(flat, locationId, path);
    return path.reversed.join(' › ');
  }

  void _buildBreadcrumb(List<Location> all, String id, List<String> path) {
    try {
      final loc = all.firstWhere((l) => l.id == id);
      path.add(loc.name);
      if (loc.parentId != null) _buildBreadcrumb(all, loc.parentId!, path);
    } catch (_) {}
  }

  /// Map of locationId → item count (only locations that have ≥1 item).
  /// Omit [sellerId] to count across all sellers (owner view).
  Future<Map<String, int>> getItemCountsByLocation({String? sellerId}) async {
    final List<dynamic> rows;
    if (sellerId != null) {
      rows = await _supabase
          .from('inventory_items')
          .select('location_id')
          .eq('seller_id', sellerId);
    } else {
      rows = await _supabase.from('inventory_items').select('location_id');
    }
    final map = <String, int>{};
    for (final row in rows) {
      final id = row['location_id'] as String?;
      if (id != null) map[id] = (map[id] ?? 0) + 1;
    }
    return map;
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<Location> addLocation(Location location) async {
    final response = await _supabase
        .from('locations')
        .insert(location.toMap())
        .select()
        .single();
    return Location.fromMap(response);
  }

  Future<void> updateLocation(String id, Location location) async {
    await _supabase.from('locations').update(location.toMap()).eq('id', id);
  }

  Future<void> deleteLocation(String id) async {
    await _supabase.from('locations').delete().eq('id', id);
  }
}
