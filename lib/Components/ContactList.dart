import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';

// Dummy list of contacts
final List<Contact> contacts = [
  Contact(name: 'Alice Johnson', phoneNumber: '+1 555 123 456'),
  Contact(name: 'Bob Smith', phoneNumber: '+1 555 987 654'),
  Contact(name: 'Charlie Davis', phoneNumber: '+1 555 765 432'),
  Contact(name: 'Eva Brown', phoneNumber: '+1 555 678 901'),
  Contact(name: 'Frank Green', phoneNumber: '+1 555 234 567'),
  Contact(name: 'Grace Adams', phoneNumber: '+1 555 345 678'),
  Contact(name: 'Henry Scott', phoneNumber: '+1 555 456 789'),
  Contact(name: 'Ivy Clark', phoneNumber: '+1 555 567 890'),
  Contact(name: 'Jack Turner', phoneNumber: '+1 555 678 901'),
  Contact(name: 'Katherine Martinez', phoneNumber: '+1 555 789 012'),
  Contact(name: 'Liam Walker', phoneNumber: '+1 555 890 123'),
  Contact(name: 'Paul Harris', phoneNumber: '+1 555 234 567'),
  Contact(name: 'Quinn Robinson', phoneNumber: '+1 555 345 678'),
  Contact(name: 'Rachel Young', phoneNumber: '+1 555 456 789'),
  Contact(name: 'Ulysses Green', phoneNumber: '+1 555 789 012'),
  Contact(name: 'Victoria Adams', phoneNumber: '+1 555 890 123'),
  Contact(name: 'William Scott', phoneNumber: '+1 555 901 234'),
  Contact(name: 'Xena Brown', phoneNumber: '+1 555 012 345'),
  Contact(name: 'Yara Nelson', phoneNumber: '+1 555 123 456'),
  Contact(name: 'Zachary Carter', phoneNumber: '+1 555 234 567'),
  Contact(name: 'Amy King', phoneNumber: '+1 555 345 678'),
  Contact(name: 'Brian Lee', phoneNumber: '+1 555 456 789'),
  Contact(name: 'Cynthia Martinez', phoneNumber: '+1 555 567 890'),
  Contact(name: 'Daniel Robinson', phoneNumber: '+1 555 678 901'),
  Contact(name: 'Elaine Walker', phoneNumber: '+1 555 789 012'),
  Contact(name: 'Georgia Lewis', phoneNumber: '+1 555 901 234'),
  Contact(name: 'Henry Young', phoneNumber: '+1 555 012 345'),
  Contact(name: 'Isabella Brown', phoneNumber: '+1 555 123 456'),
  Contact(name: 'James Smith', phoneNumber: '+1 555 234 567'),
  Contact(name: 'Katherine Johnson', phoneNumber: '+1 555 345 678'),
  Contact(name: 'Liam Carter', phoneNumber: '+1 555 456 789'),
  Contact(name: 'Monica Davis', phoneNumber: '+1 555 567 890'),
  Contact(name: 'Nicholas Brown', phoneNumber: '+1 555 678 901'),
  Contact(name: 'Olivia Green', phoneNumber: '+1 555 789 012'),
  Contact(name: 'Steven Martinez', phoneNumber: '+1 555 123 456'),
  Contact(name: 'Tara Lewis', phoneNumber: '+1 555 234 567'),
  Contact(name: 'Ursula Walker', phoneNumber: '+1 555 345 678'),
  Contact(name: 'Victor Robinson', phoneNumber: '+1 555 456 789'),
  Contact(name: 'Wendy Harris', phoneNumber: '+1 555 567 890'),
  Contact(name: 'Xander Young', phoneNumber: '+1 555 678 901'),
  Contact(name: 'Yvonne King', phoneNumber: '+1 555 789 012'),
  Contact(name: 'Zane Lewis', phoneNumber: '+1 555 890 123'),
];

class ContactListWidget extends StatelessWidget {
  final List<Contact> contacts;

  const ContactListWidget({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    // Group contacts by their initial letter
    final Map<String, List<Contact>> groupedContacts = {};
    contacts.sort(
        (a, b) => a.name.compareTo(b.name)); // Sort contacts alphabetically

    for (var contact in contacts) {
      final firstLetter = contact.name[0].toUpperCase();
      if (groupedContacts[firstLetter] == null) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Create list of widgets with headers and contact tiles
    final List<Widget> contactWidgets = [];
    groupedContacts.forEach((letter, contacts) {
      contactWidgets.add(
        Container(
          color: CupertinoTheme.of(context).barBackgroundColor,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      contactWidgets.addAll(
        contacts.map((contact) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.systemGrey,
                  width: 1.0,
                ),
              ),
            ),
            child: CupertinoListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: CupertinoColors.systemGrey,
                child: Text(
                  contact.name[0],
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                contact.phoneNumber,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.info),
                onPressed: () {
                  // Show contact details or perform another action
                },
              ),
              onTap: () {
                // Action when tapping the contact (e.g., call the contact)
              },
            ),
          );
        }).toList(),
      );
    });

    return ListView(
      padding: EdgeInsets.zero, // Remove any default padding
      children: contactWidgets,
    );
  }
}
