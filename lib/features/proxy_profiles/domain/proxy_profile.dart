import 'proxy_type.dart';

class ProxyProfile {
  const ProxyProfile({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.type,
    required this.isActive,
  });

  final String id;
  final String name;
  final String host;
  final int port;
  final ProxyType type;
  final bool isActive;

  ProxyProfile copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    ProxyType? type,
    bool? isActive,
  }) {
    return ProxyProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'host': host,
        'port': port,
        'type': type.name,
        'isActive': isActive,
      };

  factory ProxyProfile.fromJson(Map<String, dynamic> json) => ProxyProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        host: json['host'] as String,
        port: json['port'] as int,
        type: ProxyType.values.byName(json['type'] as String),
        isActive: json['isActive'] as bool,
      );
}
