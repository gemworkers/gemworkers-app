import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/location.dart';

class LocationRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// Flat list of all locations for a branch, ordered by name.
  Future<List<Location>> getLocationsFlat(String sellerId) async {
    final response = await _supabase
        .from('locations')
        .select()
        .eq('seller_id', sellerId)
        .order('name');
    return response.map<Location>((row) => Location.fromMap(row)).toList();
  }

  /// Root nodes of the tree for a branch, with children populated recursively.
  Future<List<Location>> getTree(String sellerId) async {
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
  /// Used for "filter by location including sub-locations".
  Future<List<String>> getDescendantIds(
      String locationId, String sellerId) async {
    final flat = await getLocationsFlat(sellerId);
    final ids = <String>[];
    _collectDescendants(flat, locationId, ids);
    return ids;
  }

  void _collectDescendants(
      List<Location> all, String id, List<String> ids) {
    ids.add(id);
    for (final child in all.where((l) => l.parentId == id)) {
      _collectDescendants(all, child.id!, ids);
    }
  }

  /// Human-readable breadcrumb from root to the given location.
  /// Returns e.g. "Shop › Storage › Shelf A".
  Future<String> getBreadcrumb(String locationId, String sellerId) async {
    final flat = await getLocationsFlat(sellerId);
    final path = <String>[];
    _buildBreadcrumb(flat, locationId, path);
    return path.reversed.join(' › ');
  }

  void _buildBreadcrumb(
      List<Location> all, String id, List<String> path) {
    try {
      final loc = all.firstWhere((l) => l.id == id);
      path.add(loc.name);
      if (loc.parentId != null) _buildBreadcrumb(all, loc.parentId!, path);
    } catch (_) {
      // Location not found — stop traversal.
    }
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
