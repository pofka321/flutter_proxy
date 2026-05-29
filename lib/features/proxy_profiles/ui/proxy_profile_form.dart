import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/proxy_profile.dart';
import '../domain/proxy_type.dart';
import '../../settings/settings_channel.dart';

class ProxyProfileForm extends StatefulWidget {
  const ProxyProfileForm({super.key, this.initial});

  final ProxyProfile? initial;

  static Future<ProxyProfile?> show(
    BuildContext context, {
    ProxyProfile? initial,
  }) {
    return showModalBottomSheet<ProxyProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ProxyProfileForm(initial: initial),
    );
  }

  @override
  State<ProxyProfileForm> createState() => _ProxyProfileFormState();
}

class _ProxyProfileFormState extends State<ProxyProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  late ProxyType _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _hostController = TextEditingController(text: widget.initial?.host ?? '');
    _portController = TextEditingController(
      text: widget.initial?.port.toString() ?? '',
    );
    _type = widget.initial?.type ?? ProxyType.http;
    if (widget.initial == null) {
      SettingsChannel.getWifiSsid().then((ssid) {
        if (mounted) {
          setState(() {
            _nameController.text = ssid ?? '';
          });
        }
      }).catchError((_) {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final profile = ProxyProfile(
      id: widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: int.parse(_portController.text.trim()),
      type: _type,
      isActive: widget.initial?.isActive ?? false,
    );
    Navigator.pop(context, profile);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _hostController,
              decoration: const InputDecoration(labelText: 'Host'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _portController,
              decoration: const InputDecoration(labelText: 'Port'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                final port = int.tryParse(v ?? '');
                if (port == null || port < 1 || port > 65535) {
                  return 'Enter a valid port (1–65535)';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ProxyType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: ProxyType.values
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
