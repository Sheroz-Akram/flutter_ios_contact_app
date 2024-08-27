import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:flutter_ios_contact_app/Classes/ContactDatabase.dart';
import 'package:flutter_ios_contact_app/Classes/ImageManagement.dart';
import 'package:image_picker/image_picker.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  // Text Field Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Attributes
  late Contact contact;
  ImageManagement imageManager = ImageManagement(); // Help to Manage Images
  var contactDatabase = ContactDatabase();

  /// Help to Manage Contacts Database

  // Add Image to Contact
  void addImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      await imageManager.selectImage();
    } else if (source == ImageSource.camera) {
      await imageManager.takePicture();
    } else {
      return;
    }
    await imageManager.cropImage();
    String imagePath = await imageManager.saveImagePermanently();
    setState(() {
      contact.profilePicture = imagePath;
    });
  }

  // Show Alert to the User
  void _showAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Handle Contact Done
  void _handleDone() {
    // Get All the Input Information
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phoneNumber = _phoneNumberController.text;
    String address = _addressController.text;

    // Validation
    if (firstName.isEmpty) {
      _showAlert("No First Name", "Please enter first name of contact");
      return;
    }
    if (phoneNumber.isEmpty) {
      _showAlert(
          "No Phone Number", "Please enter phone number to save contact");
      return;
    }

    // Store the Contact Information
    contact.firstName = firstName;
    contact.lastName = lastName;
    contact.phoneNumber = phoneNumber;
    contact.address = address;

    // Update Data on Database
    contactDatabase.insertContact(contact);

    // Move to Previous Page
    Navigator.pop(context);
  }

  void _showImageOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Choose Profile Picture'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Take Photo'),
            onPressed: () {
              Navigator.pop(context);
              addImage(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Select from Gallery'),
            onPressed: () {
              Navigator.pop(context);
              addImage(ImageSource.gallery);
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

  @override
  void initState() {
    super.initState();
    setState(() {
      // Initialize Contact with no data
      contact = Contact(
          firstName: "",
          lastName: "",
          phoneNumber: "",
          address: "",
          profilePicture: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('New Contact'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _handleDone,
          child: const Text('Done'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
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
              CupertinoButton(
                  onPressed: _showImageOptions, child: const Text("Add Photo")),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoTextFormFieldRow(
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      prefix: const Text('First Name:'),
                      placeholder: "John",
                      controller: _firstNameController,
                    ),
                    const Divider(
                      color: CupertinoColors.systemGrey,
                      thickness: 1,
                      height: 20,
                    ),
                    CupertinoTextFormFieldRow(
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      prefix: const Text('Last Name:'),
                      placeholder: "Doe",
                      controller: _lastNameController,
                    ),
                    const Divider(
                      color: CupertinoColors.systemGrey,
                      thickness: 1,
                      height: 20,
                    ),
                    CupertinoTextFormFieldRow(
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      prefix: const Text('Phone Number:'),
                      placeholder: "(123) 456-7890",
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    const Divider(
                      color: CupertinoColors.systemGrey,
                      thickness: 1,
                      height: 20,
                    ),
                    CupertinoTextFormFieldRow(
                      style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      placeholder: "123 Main St, Springfield, IL 62704",
                      prefix: const Text('Address:'),
                      controller: _addressController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
