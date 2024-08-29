import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:flutter_ios_contact_app/Classes/ContactDatabase.dart';
import 'package:flutter_ios_contact_app/Components/ContactList.dart';
import 'package:flutter_ios_contact_app/Pages/EditContact.dart';
import 'package:flutter_ios_contact_app/Pages/NewContact.dart';
import 'package:flutter_ios_contact_app/Pages/Settings.dart';
import 'package:flutter_ios_contact_app/Pages/ViewContact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  // Attributes
  List<Contact> contactList = [];
  String searchQuery = "";

  // Load Contact from Memeory
  void loadContacts() async {
    print("Contacts Loaded");
    ContactDatabase contactDataBase = ContactDatabase();
    List<Contact> contacts;
    if (searchQuery == "") {
      contacts = await contactDataBase.getContacts();
    } else {
      contacts = await contactDataBase.getContacts(searchQuery: searchQuery);
    }
    setState(() {
      contactList = contacts;
    });
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              // Move to Settings Page
              var result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
              print("After the Object Popped");
              if (result != null) {
                loadContacts();
              }
            },
            child: const Text("Settings")),
        middle: const Text("Contacts List"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () async {
            // Move to Add Contact Page
            await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const NewContactPage()));
            loadContacts();
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
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  loadContacts();
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            // Contact List
            Expanded(
              child: ContactListWidget(
                contacts: contactList,
                deleteContact: (Contact contact) async {
                  // Delete the Contact
                  ContactDatabase contactDatabase = ContactDatabase();
                  print(contact.toMap());
                  await contactDatabase.deleteContact(contact.id!);
                  setState(() {
                    int index = contactList.indexOf(contact);
                    contactList.removeAt(index);
                  });
                },
                editContact: (Contact contact) async {
                  // Move to Edit Contact Page
                  await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => EditPage(contact: contact)));
                  loadContacts();
                },
                viewContact: (Contact contact) async {
                  // Show contact details or perform another action
                  await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ViewContact(contact: contact)));
                  loadContacts();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
