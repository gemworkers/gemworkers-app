import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/location.dart';

class LocationRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// Flat list of all locations for a branch, ordered by name.
  Future<List<Location>> getLocationsFlat(String branchId) async {
    final response = await _supabase
        .from('locations')
        .select()
        .eq('branch_id', branchId)
        .order('name');
    return response.map<Location>((row) => Location.fromMap(row)).toList();
  }

  /// Root nodes of the tree for a branch, with children populated recursively.
  Future<List<Location>> getTree(String branchId) async {
    final flat = await getLocationsFlat(branchId);
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
      String locationId, String branchId) async {
    final flat = await getLocationsFlat(branchId);
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
  Future<String> getBreadcrumb(String locationId, String branchId) async {
    final flat = await getLocationsFlat(branchId);
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
