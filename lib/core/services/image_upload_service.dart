import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:um_connect/core/config/imagekit_config.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  // 1. Pick an image from the user's gallery
  Future<XFile?> pickImage() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // 2. Upload the picked image to ImageKit.io
  Future<String?> uploadImage(XFile image) async {
    try {
      final uri = Uri.parse(ImageKitConfig.uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      // Add authentication headers
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${ImageKitConfig.privateKey}:'))}';
      request.headers['Authorization'] = basicAuth;

      // Add image file to the request
      final file = await http.MultipartFile.fromPath('file', image.path);
      request.files.add(file);

      // Add other required fields for ImageKit
      request.fields['fileName'] = image.name;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['url']; // Return the URL of the uploaded image
      } else {
        final errorBody = await response.stream.bytesToString();
        print(
          'ImageKit upload failed with status ${response.statusCode}: $errorBody',
        );
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
