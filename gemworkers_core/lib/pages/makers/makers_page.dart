import 'package:flutter/material.dart';

import '../../models/maker.dart';
import '../../repositories/maker_repository.dart';
import 'add_edit_maker_page.dart';

/// Owner only. The craftspeople credited on stones ("Cut by … in …") and
/// shown on the store's Makers page.
class MakersPage extends StatefulWidget {
  const MakersPage({super.key});

  @override
  State<MakersPage> createState() => _MakersPageState();
}

class _MakersPageState extends State<MakersPage> {
  final _repository = MakerRepository();

  List<Maker> _makers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final makers = await _repository.getMakers();
      if (mounted) setState(() { _makers = makers; _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _open([Maker? maker]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditMakerPage(maker: maker)),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Makers')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _makers.isEmpty
              ? const _EmptyState()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 80),
                    itemCount: _makers.length,
                    itemBuilder: (_, i) =>
                        _MakerCard(_makers[i], onTap: () => _open(_makers[i])),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _open(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.handyman_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('No makers yet',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Add the cutters, jewellers and collectors behind your stones. '
              'You can then credit them on a stone.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _MakerCard extends StatelessWidget {
  final Maker maker;
  final VoidCallback onTap;
  const _MakerCard(this.maker, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundImage:
              maker.photoUrl != null ? NetworkImage(maker.photoUrl!) : null,
          child: Text(
            maker.name.isNotEmpty ? maker.name[0].toUpperCase() : '?',
            style: TextStyle(
                color: scheme.onPrimaryContainer, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(maker.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          maker.place.isNotEmpty ? maker.place : 'No place',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
