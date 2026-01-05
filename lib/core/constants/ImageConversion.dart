import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;
    return File(image.path);
  }
}

class CloudinaryService {
  static const String cloudName = "dvus6u6im";
  static const String uploadPreset = "profile_images";

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(res.body);
        return data['secure_url']; // 🔥 MUST RETURN THIS
      } else {
        print("❌ Cloudinary failed: ${res.body}");
        return null;
      }
    } catch (e) {
      print("🔥 Cloudinary error: $e");
      return null;
    }
  }
}
