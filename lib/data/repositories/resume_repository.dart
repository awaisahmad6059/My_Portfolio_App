import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeRepository {
  static const String _resumeKey = 'resume_stored_data';

  Future<String?> getResumeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_resumeKey);
      debugPrint('[ResumeRepository] getResumeData: ${data != null ? "${data.substring(0, data.length.clamp(0, 40))}..." : "null"}');
      return data;
    } catch (e, stack) {
      debugPrint('[ResumeRepository] Error reading resume data: $e');
      debugPrint('[ResumeRepository] Stack trace: $stack');
      return null;
    }
  }

  Future<void> saveResumeData(String data) async {
    try {
      debugPrint('[ResumeRepository] Saving resume data (${data.length} chars)');
      final prefs = await SharedPreferences.getInstance();
      final saved = await prefs.setString(_resumeKey, data);
      debugPrint('[ResumeRepository] Save ${saved ? 'succeeded' : 'FAILED'}');
    } catch (e, stack) {
      debugPrint('[ResumeRepository] Error saving resume data: $e');
      debugPrint('[ResumeRepository] Stack trace: $stack');
      rethrow;
    }
  }

  Future<void> clearResumeData() async {
    try {
      debugPrint('[ResumeRepository] Clearing resume data');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_resumeKey);
      debugPrint('[ResumeRepository] Resume data cleared');
    } catch (e, stack) {
      debugPrint('[ResumeRepository] Error clearing resume data: $e');
      debugPrint('[ResumeRepository] Stack trace: $stack');
    }
  }
}
