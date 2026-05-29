import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../settings/settings_channel.dart';
import '../data/proxy_profile_repository.dart';
import '../domain/proxy_profile.dart';
import 'proxy_profile_card.dart';
import 'proxy_profile_form.dart';

class ProxyProfilesScreen extends StatefulWidget {
  const ProxyProfilesScreen({super.key});

  @override
  State<ProxyProfilesScreen> createState() => _ProxyProfilesScreenState();
}

class _ProxyProfilesScreenState extends State<ProxyProfilesScreen> {
  final _repository = ProxyProfileRepository();
  List<ProxyProfile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profiles = await _repository.loadAll();
    setState(() => _profiles = profiles);
  }

  Future<void> _add() async {
    final result = await ProxyProfileForm.show(context);
    if (result != null) {
      await _repository.add(result);
      await _load();
    }
  }

  Future<void> _edit(ProxyProfile profile) async {
    final result = await ProxyProfileForm.show(context, initial: profile);
    if (result != null) {
      await _repository.update(result);
      await _load();
    }
  }

  Future<void> _delete(String id) async {
    await _repository.delete(id);
    await _load();
  }

  Future<void> _activate(String id) async {
    await _repository.setActive(id);
    await _load();
  }

  Future<void> _openSettings() async {
    try {
      await SettingsChannel.openWifiSettings();
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Unknown error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Proxy Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open WiFi Settings',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _profiles.isEmpty
          ? const Center(
              child: Text('No profiles yet. Tap + to add one.'),
            )
          : ListView.builder(
              itemCount: _profiles.length,
              itemBuilder: (_, index) {
                final profile = _profiles[index];
                return ProxyProfileCard(
                  profile: profile,
                  onEdit: () => _edit(profile),
                  onDelete: () => _delete(profile.id),
                  onActivate: () => _activate(profile.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Add profile',
        child: const Icon(Icons.add),
      ),
    );
  }
}
