import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Contact.dart';
import 'package:flutter_ios_contact_app/Classes/ContactDatabase.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String profilePicturePath = "";

  // Store the Image Permanently
  Future<String> _saveImagePermanently(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now()}.png';
    final filePath = '${directory.path}/$fileName';
    final savedImage = await imageFile.copy(filePath);
    return savedImage.path;
  }

  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    if (croppedFile != null) {
      final savedPath = await _saveImagePermanently(imageFile);
      setState(() {
        profilePicturePath = savedPath;
      });
      print(profilePicturePath);
    }
  }

  Future<void> _requestPermissions() async {
    // Check the current status of each permission
    final statusGallery = await Permission.photos.status;
    final statusCamera = await Permission.camera.status;
    final statusStorage = await Permission.storage.status;

    // Request permissions only if they are not granted
    if (!statusGallery.isGranted) {
      await Permission.photos.request();
    }

    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }

    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _selectImage() async {
    await _requestPermissions();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _cropImage(File(image.path));
    }
  }

  Future<void> _takePicture() async {
    await _requestPermissions();
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
        profilePicture: profilePicturePath,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address);

    // Insert our Contact into database
    var contactDatabase = ContactDatabase();
    await contactDatabase.insertContact(contact);

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
                backgroundImage: profilePicturePath != ""
                    ? FileImage(File(profilePicturePath))
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
                child: profilePicturePath == ""
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
