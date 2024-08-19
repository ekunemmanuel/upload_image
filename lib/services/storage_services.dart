import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService with ChangeNotifier {
  // firebase storage instance
  final storage = FirebaseStorage.instance;

  List<String> _imageUrls = [];

  // loading state
  bool _isLoading = false;

  // uploading state
  bool _isUploading = false;

  // error state
  String _error = '';

  // getters
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String get error => _error;

// Upload image to Firebase Storage
  Future<void> uploadImage() async {
    _isUploading = true;
    notifyListeners();
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        _error = 'No image selected';
        return;
      }

      final file = File(image.path);
      final String fileName = '${DateTime.now()}.png';
      final String filePath = 'images/$fileName';

      final Reference ref = storage.ref(filePath);
      await ref.putFile(file);

      String url = await ref.getDownloadURL();
      _imageUrls.add(url);

      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  // get image url from firebase storage
  Future<void> fetchImages() async {
    _isLoading = true;
    notifyListeners();
    try {
      final ListResult result = await storage.ref().listAll();
      final List<String> urls = await Future.wait(
          result.items.map((Reference ref) => ref.getDownloadURL()));

      _imageUrls = urls;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // delete image from firebase storage
  Future<void> deleteImage(String imageUrl) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Reference ref = storage.refFromURL(imageUrl);
      await ref.delete();
      _imageUrls.remove(imageUrl);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
