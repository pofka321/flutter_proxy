import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/proxy_profile.dart';

class ProxyProfileRepository {
  static const _key = 'proxy_profiles';

  Future<List<ProxyProfile>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ProxyProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<ProxyProfile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profiles.map((p) => p.toJson()).toList()));
  }

  Future<void> add(ProxyProfile profile) async {
    final profiles = await loadAll();
    profiles.add(profile);
    await saveAll(profiles);
  }

  Future<void> update(ProxyProfile profile) async {
    final profiles = await loadAll();
    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) profiles[index] = profile;
    await saveAll(profiles);
  }

  Future<void> delete(String id) async {
    final profiles = await loadAll();
    profiles.removeWhere((p) => p.id == id);
    await saveAll(profiles);
  }

  Future<void> setActive(String id) async {
    final profiles = await loadAll();
    final updated = profiles
        .map((p) => p.copyWith(isActive: p.id == id))
        .toList();
    await saveAll(updated);
  }
}
