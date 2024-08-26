import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Components/ContactList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // Move to Settings Bage
            },
            child: const Text("Settings")),
        middle: const Text("Contacts List"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            // Move to Add Contact Page
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            // Contact Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Contacts",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                  )),
            ),
            // Search Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: CupertinoSearchTextField(
                onChanged: (value) {},
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            // Contact List
            Expanded(
              child: ContactListWidget(contacts: contacts),
            ),
          ],
        ),
      ),
    );
  }
}
