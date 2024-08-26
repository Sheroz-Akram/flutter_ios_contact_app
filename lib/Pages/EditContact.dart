import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:flutter_ios_contact_app/Classes/ContactDatabase.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage({super.key});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _profilePicture;

  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    if (croppedFile != null) {
      setState(() {
        _profilePicture = File(croppedFile.path);
      });
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _cropImage(File(image.path));
    }
  }

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _cropImage(File(image.path));
    }
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
              _takePicture();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Select from Gallery'),
            onPressed: () {
              Navigator.pop(context);
              _selectImage();
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

  void _handleDone() async {
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

    // Create New Contact
    Contact contact = Contact(
        profilePicture: "",
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address);

    // Insert our Contact into database
    var contactDatabase = ContactDatabase();
    int id = await contactDatabase.insertContact(contact);

    print("Contact Inserted to Database: $id");

    // Move to Previous Page
    Navigator.pop(context);
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
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageOptions,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
                child: _profilePicture == null
                    ? const Icon(
                        CupertinoIcons.camera,
                        color: CupertinoColors.systemGrey,
                        size: 50,
                      )
                    : null,
              ),
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
                    prefix: const Text('First Name:'),
                    placeholder: "John",
                    controller: _firstNameController,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Text('Last Name:'),
                    placeholder: "Doe",
                    controller: _lastNameController,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Text('Phone Number:'),
                    placeholder: "(123) 456-7890",
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                  ),
                  CupertinoTextFormFieldRow(
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
    );
  }
}
