import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aak/models/admin_data.dart';

class AdminRepository {
  static const String _dataKey = 'admin_data';
  static const String _imageBase64Key = 'admin_image_base64';
  static const String _imageFileName = 'admin_profile.jpg';

  Future<AdminData?> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_dataKey);
      if (jsonStr == null) return null;
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final data = AdminData.fromJson(json);
      debugPrint('[AdminRepository] Data loaded: ${data.fullName}');
      return data;
    } catch (e, stack) {
      debugPrint('[AdminRepository] Error loading data: $e');
      debugPrint('[AdminRepository] Stack trace: $stack');
      return null;
    }
  }

  Future<void> saveData(AdminData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(data.toJson());
      await prefs.setString(_dataKey, jsonStr);
      debugPrint('[AdminRepository] Data saved: ${data.fullName}');
    } catch (e, stack) {
      debugPrint('[AdminRepository] Error saving data: $e');
      debugPrint('[AdminRepository] Stack trace: $stack');
      rethrow;
    }
  }

  Future<String?> pickAndSaveImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        debugPrint('[AdminRepository] Image picker cancelled');
        return null;
      }

      final file = result.files.single;
      debugPrint('[AdminRepository] Image picked: ${file.name}');
      Uint8List? bytes = file.bytes;

      if (bytes == null && file.path != null) {
        final diskFile = File(file.path!);
        if (await diskFile.exists()) {
          bytes = await diskFile.readAsBytes();
        }
      }

      if (bytes == null || bytes.isEmpty) return null;

      if (kIsWeb) {
        final base64Str = base64Encode(bytes);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_imageBase64Key, base64Str);
        debugPrint('[AdminRepository] Image saved as base64 (${base64Str.length} chars)');
        return 'base64_image:$base64Str';
      }

      final dir = await getApplicationDocumentsDirectory();
      final imageFile = File('${dir.path}/$_imageFileName');
      await imageFile.writeAsBytes(bytes, flush: true);
      debugPrint('[AdminRepository] Image saved to: ${imageFile.path}');
      return imageFile.path;
    } catch (e, stack) {
      debugPrint('[AdminRepository] Error saving image: $e');
      debugPrint('[AdminRepository] Stack trace: $stack');
      return null;
    }
  }

  Future<void> clearImage() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_imageBase64Key);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final imageFile = File('${dir.path}/$_imageFileName');
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }
      debugPrint('[AdminRepository] Custom image cleared');
    } catch (e, stack) {
      debugPrint('[AdminRepository] Error clearing image: $e');
      debugPrint('[AdminRepository] Stack trace: $stack');
    }
  }

  Future<Uint8List?> loadCustomImageBytes() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final base64Str = prefs.getString(_imageBase64Key);
        if (base64Str == null) return null;
        return base64Decode(base64Str);
      }

      final dir = await getApplicationDocumentsDirectory();
      final imageFile = File('${dir.path}/$_imageFileName');
      if (!await imageFile.exists()) return null;
      return await imageFile.readAsBytes();
    } catch (e, stack) {
      debugPrint('[AdminRepository] Error loading image bytes: $e');
      debugPrint('[AdminRepository] Stack trace: $stack');
      return null;
    }
  }

  Future<bool> hasCustomImage() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_imageBase64Key);
    }
    final dir = await getApplicationDocumentsDirectory();
    final imageFile = File('${dir.path}/$_imageFileName');
    return imageFile.exists();
  }
}
