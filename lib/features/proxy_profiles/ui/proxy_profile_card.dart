import 'package:flutter/material.dart';
import '../domain/proxy_profile.dart';

class ProxyProfileCard extends StatelessWidget {
  const ProxyProfileCard({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onDelete,
    required this.onActivate,
  });

  final ProxyProfile profile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: profile.isActive ? Colors.green : Colors.grey,
        size: 12,
      ),
      title: Text(profile.name),
      subtitle: Text(
        '${profile.type.name.toUpperCase()} ${profile.host}:${profile.port}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: onActivate,
            tooltip: 'Activate',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      onTap: onEdit,
    );
  }
}
