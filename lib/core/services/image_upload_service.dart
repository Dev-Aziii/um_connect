import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:um_connect/core/config/imagekit_config.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // --- MODIFIED METHOD ---
  /// Uploads the picked image to ImageKit.io with a specific filename and folder.
  Future<String?> uploadImage(
    XFile image, {
    required String fileName,
    String folderPath = '/',
  }) async {
    try {
      final uri = Uri.parse(ImageKitConfig.uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${ImageKitConfig.privateKey}:'))}';
      request.headers['Authorization'] = basicAuth;

      final file = await http.MultipartFile.fromPath('file', image.path);
      request.files.add(file);

      // Add other required fields for ImageKit
      request.fields['fileName'] = fileName; // Use the provided filename
      request.fields['folder'] = folderPath;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['url'];
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
