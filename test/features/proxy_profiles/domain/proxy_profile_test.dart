import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_proxy/features/proxy_profiles/domain/proxy_profile.dart';
import 'package:flutter_proxy/features/proxy_profiles/domain/proxy_type.dart';

ProxyProfile _fixture({
  String id = '1',
  String name = 'Office',
  String host = '192.168.1.1',
  int port = 8080,
  ProxyType type = ProxyType.http,
  bool isActive = false,
}) =>
    ProxyProfile(
      id: id,
      name: name,
      host: host,
      port: port,
      type: type,
      isActive: isActive,
    );

void main() {
  group('ProxyProfile serialization', () {
    test('toJson round-trips via fromJson', () {
      final profile = _fixture(isActive: true, type: ProxyType.socks5);
      final restored = ProxyProfile.fromJson(profile.toJson());

      expect(restored.id, profile.id);
      expect(restored.name, profile.name);
      expect(restored.host, profile.host);
      expect(restored.port, profile.port);
      expect(restored.type, profile.type);
      expect(restored.isActive, profile.isActive);
    });

    test('toJson stores type as string name', () {
      final json = _fixture(type: ProxyType.https).toJson();
      expect(json['type'], 'https');
    });

    test('fromJson parses all ProxyType values', () {
      for (final type in ProxyType.values) {
        final json = _fixture(type: type).toJson();
        expect(ProxyProfile.fromJson(json).type, type);
      }
    });
  });

  group('ProxyProfile.copyWith', () {
    test('copies with updated fields', () {
      final original = _fixture(name: 'Original', port: 8080);
      final copy = original.copyWith(name: 'Updated', port: 3128);

      expect(copy.name, 'Updated');
      expect(copy.port, 3128);
      expect(copy.id, original.id);
      expect(copy.host, original.host);
    });

    test('returns identical values when no fields overridden', () {
      final original = _fixture();
      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.port, original.port);
      expect(copy.type, original.type);
      expect(copy.isActive, original.isActive);
    });
  });
}
