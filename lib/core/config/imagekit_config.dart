import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageKitConfig {
  // Read the private key from the .env file
  static final String privateKey =
      dotenv.env['IMAGEKIT_PRIVATE_KEY'] ?? 'YOUR_DEFAULT_KEY';

  // Read the URL endpoint from the .env file
  static final String urlEndpoint =
      dotenv.env['IMAGEKIT_URL_ENDPOINT'] ?? 'YOUR_DEFAULT_ENDPOINT';

  // The API endpoint for uploading files (this one is not a secret)
  static const String uploadUrl =
      'https://upload.imagekit.io/api/v1/files/upload';
}
