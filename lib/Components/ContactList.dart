import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:flutter_ios_contact_app/Classes/ContactDatabase.dart';

// Dummy list of contacts
final List<Contact> contacts = [];

class ContactListWidget extends StatelessWidget {
  final List<Contact> contacts;

  const ContactListWidget(
      {super.key, required this.contacts, required this.deleteContact});

  final Function deleteContact;

  @override
  Widget build(BuildContext context) {
    // Group contacts by their initial letter
    final Map<String, List<Contact>> groupedContacts = {};
    contacts.sort((a, b) => a
        .completeName()
        .compareTo(b.completeName())); // Sort contacts alphabetically

    for (var contact in contacts) {
      final firstLetter = contact.completeName()[0].toUpperCase();
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
            child: GestureDetector(
              onLongPress: () {
                _showContextMenu(context, contact);
              },
              child: CupertinoListTile(
                leading: CircleAvatar(
                  radius: 50,
                  backgroundColor: CupertinoColors.systemGrey,
                  child: contact.profilePicture.isNotEmpty
                      ? ClipOval(
                          child: Image.file(
                            File(contact.profilePicture),
                            fit: BoxFit.cover,
                            width:
                                100, // Width of the image should match the diameter of the CircleAvatar
                            height:
                                100, // Height of the image should match the diameter of the CircleAvatar
                            errorBuilder: (context, error, stackTrace) {
                              // Handle the error (e.g., show a default image or an error icon)
                              return const Icon(
                                CupertinoIcons.person,
                                color: CupertinoColors.white,
                              );
                            },
                          ),
                        )
                      : Text(
                          contact.completeName()[0],
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                title: Text(
                  contact.completeName(),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.phone),
                        onPressed: () {
                          // Perform a phone Call
                          contact.makePhoneCall();
                        }),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.info),
                      onPressed: () {
                        // Show contact details or perform another action
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Action when tapping the contact (e.g., call the contact)
                },
              ),
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

  void _showContextMenu(BuildContext context, Contact contact) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(contact.completeName()),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.pencil_ellipsis_rectangle,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Edit')
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              // Handle edit action
            },
          ),
          CupertinoActionSheetAction(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.share,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Share')
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              // Handle edit action
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.destructiveRed,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Delete')
              ],
            ),
            onPressed: () async {
              await deleteContact(contact);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
