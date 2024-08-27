import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:flutter_ios_contact_app/Pages/EditContact.dart';

class ViewContact extends StatefulWidget {
  const ViewContact({super.key, required this.contact});
  final Contact contact;
  @override
  State<StatefulWidget> createState() {
    return _ViewContact();
  }
}

class _ViewContact extends State<ViewContact> {
  // Contact to be Displayed
  late Contact contact;

  @override
  void initState() {
    super.initState();
    setState(() {
      contact = widget.contact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text("Edit"),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => EditPage(contact: contact)));
            }),
        middle: const Text("View Contact"),
        leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 100,
              child: Row(
                children: [
                  Icon(CupertinoIcons.back),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Back")
                ],
              ),
            )),
      ),
      child: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display Contact Picture at Center Else Name First Letter
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
                backgroundImage: contact.profilePicture != ""
                    ? FileImage(File(contact.profilePicture))
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
                child: contact.profilePicture == ""
                    ? const Icon(
                        CupertinoIcons.profile_circled,
                        color: CupertinoColors.systemGrey,
                        size: 100,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              contact.completeName(),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CupertinoButton(
                        color: CupertinoTheme.of(context).barBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        onPressed: () {
                          // Make a Phone Call
                        },
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.phone_fill,
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Phone",
                              style: TextStyle(
                                  color:
                                      CupertinoTheme.of(context).primaryColor),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CupertinoButton(
                        color: CupertinoTheme.of(context).barBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        onPressed: () {
                          // Make a Message
                        },
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.chat_bubble_fill,
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Message",
                              style: TextStyle(
                                  color:
                                      CupertinoTheme.of(context).primaryColor),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
            // Display Information of Contact
            Container(
              margin: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 20, right: 20),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: CupertinoTheme.of(context).barBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Phone Number"),
                      Text(
                        contact.phoneNumber,
                        style: TextStyle(
                            color: CupertinoTheme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    ],
                  )
                ],
              ),
            ),

            // Display Information of Contact
            contact.address.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: CupertinoTheme.of(context).barBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Address"),
                            Text(
                              contact.address,
                              style: TextStyle(
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
