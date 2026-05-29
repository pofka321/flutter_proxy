import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_proxy/features/proxy_profiles/data/proxy_profile_repository.dart';
import 'package:flutter_proxy/features/proxy_profiles/domain/proxy_profile.dart';
import 'package:flutter_proxy/features/proxy_profiles/domain/proxy_type.dart';

ProxyProfile _make(String id, {bool isActive = false}) => ProxyProfile(
      id: id,
      name: 'Profile $id',
      host: '10.0.0.$id',
      port: 8080,
      type: ProxyType.http,
      isActive: isActive,
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProxyProfileRepository', () {
    test('loadAll returns empty list when nothing saved', () async {
      final repo = ProxyProfileRepository();
      expect(await repo.loadAll(), isEmpty);
    });

    test('add persists a profile', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1'));
      final profiles = await repo.loadAll();
      expect(profiles.length, 1);
      expect(profiles.first.id, '1');
    });

    test('add multiple profiles preserves order', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1'));
      await repo.add(_make('2'));
      await repo.add(_make('3'));
      final ids = (await repo.loadAll()).map((p) => p.id).toList();
      expect(ids, ['1', '2', '3']);
    });

    test('update replaces profile by id', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1'));
      final updated = _make('1').copyWith(name: 'Updated');
      await repo.update(updated);
      final profiles = await repo.loadAll();
      expect(profiles.first.name, 'Updated');
    });

    test('update on unknown id does not add', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1'));
      await repo.update(_make('99'));
      expect((await repo.loadAll()).length, 1);
    });

    test('delete removes profile by id', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1'));
      await repo.add(_make('2'));
      await repo.delete('1');
      final ids = (await repo.loadAll()).map((p) => p.id).toList();
      expect(ids, ['2']);
    });

    test('delete on unknown id does nothing', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1'));
      await repo.delete('99');
      expect((await repo.loadAll()).length, 1);
    });

    test('setActive marks only matching profile as active', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1', isActive: true));
      await repo.add(_make('2'));
      await repo.add(_make('3'));
      await repo.setActive('2');
      final profiles = await repo.loadAll();
      expect(profiles.firstWhere((p) => p.id == '1').isActive, false);
      expect(profiles.firstWhere((p) => p.id == '2').isActive, true);
      expect(profiles.firstWhere((p) => p.id == '3').isActive, false);
    });

    test('setActive deactivates previously active profile', () async {
      final repo = ProxyProfileRepository();
      await repo.add(_make('1', isActive: true));
      await repo.add(_make('2'));
      await repo.setActive('2');
      expect((await repo.loadAll()).firstWhere((p) => p.id == '1').isActive, false);
    });
  });
}
