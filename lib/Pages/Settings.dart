import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_contact_app/Classes/Preferences.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<Preferences>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Settings'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(CupertinoIcons.back),
                SizedBox(width: 5),
                Text("Back"),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CupertinoFormSection(
                header: const Text('Appearance'),
                children: [
                  CupertinoFormRow(
                    prefix: const Row(
                      children: [
                        Icon(CupertinoIcons.moon_stars_fill),
                        SizedBox(width: 10),
                        Text('Dark Mode'),
                      ],
                    ),
                    child: CupertinoSwitch(
                      value: preferences.isDarkMode,
                      onChanged: (value) {
                        preferences.toggleDarkMode();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
