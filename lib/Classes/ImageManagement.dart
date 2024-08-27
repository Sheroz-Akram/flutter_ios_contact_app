import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageManagement {
  // Attributes to Store Information
  File? image;

  // Request Permissions
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

  // Store the Image Permanently
  Future<String> saveImagePermanently() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now()}.png';
    final filePath = '${directory.path}/$fileName';
    final savedImage = await image!.copy(filePath);
    return savedImage.path;
  }

  // Crop the Image
  Future<bool> cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
    );
    if (croppedFile != null) {
      image = File(croppedFile.path);
      return true;
    }
    return false;
  }

  // Select Picture from Gallery
  Future<bool> selectImage() async {
    await _requestPermissions();
    final ImagePicker picker = ImagePicker();
    final XFile? selectImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (selectImage != null) {
      image = File(selectImage.path);
      return true;
    }
    return false;
  }

  // Take Picture from Camera
  Future<bool> takePicture() async {
    await _requestPermissions();
    final ImagePicker picker = ImagePicker();
    final XFile? selectImage =
        await picker.pickImage(source: ImageSource.camera);
    if (selectImage != null) {
      image = File(selectImage.path);
      return true;
    }
    return false;
  }
}
