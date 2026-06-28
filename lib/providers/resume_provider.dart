import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/data/repositories/resume_repository.dart';
import 'package:aak/data/services/resume_service.dart';

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  return ResumeRepository();
});

final resumeServiceProvider = Provider<ResumeService>((ref) {
  return ResumeService();
});

final resumeDataProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(resumeRepositoryProvider);
  return repo.getResumeData();
});
