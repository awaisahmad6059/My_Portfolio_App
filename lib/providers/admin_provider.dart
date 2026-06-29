import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/data/repositories/admin_repository.dart';
import 'package:aak/models/admin_data.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

final adminDataProvider = FutureProvider<AdminData>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  final data = await repo.loadData();
  return data ?? AdminData.defaults();
});

final adminImageProvider = FutureProvider<Uint8List?>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.loadCustomImageBytes();
});
