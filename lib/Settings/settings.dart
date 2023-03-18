import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: true,
      ),
      body: Column(children: [
        const Text(
          'General',
        ),
        Card(
          child: Column(children: [
            TextButton(
                onPressed: () {
                  Hive.deleteBoxFromDisk('woods');
                  Hive.deleteBoxFromDisk('stone');
                },
                child: const Text('Delete game statistics'))
          ]),
        ),
      ]),
    );
  }
}
