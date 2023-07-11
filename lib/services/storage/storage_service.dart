import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StorageService extends GetxController {
  final storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  var photoUrl = ''.obs;

  Future<void> imageFromGallery(File? _image) async {
    //  take a photo from gallery

    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      _image = File(image.path);
      photoUrl.value = await uploadImage(_image);
    }
  }

// it sends photo to storage and returns photo url
  Future uploadImage(File imageFile) async {
    String path = '${DateTime.now().millisecondsSinceEpoch}';

    TaskSnapshot uploadTask =
        await storage.ref().child('photos').child(path).putFile(imageFile);
    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();
    return uploadedImageUrl;
  }
}
