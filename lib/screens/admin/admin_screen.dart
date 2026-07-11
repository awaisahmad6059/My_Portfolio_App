import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aak/core/constants/app_strings.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';
import 'package:aak/models/admin_data.dart';
import 'package:aak/providers/admin_provider.dart';
import 'package:aak/providers/github_provider.dart';
import 'package:aak/data/repositories/github_cache_repository.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _aboutMeController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _githubUsernameController;
  late TextEditingController _githubTokenController;
  late TextEditingController _githubUrlController;
  late TextEditingController _linkedinUrlController;
  late TextEditingController _facebookUrlController;
  late TextEditingController _instagramUrlController;
  late TextEditingController _threadsUrlController;
  late TextEditingController _snapchatUrlController;
  late TextEditingController _whatsappChannelUrlController;
  late TextEditingController _whatsappNumberController;

  bool _isSaving = false;
  bool _isSyncingGitHub = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _jobTitleController = TextEditingController();
    _aboutMeController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _githubUsernameController = TextEditingController();
    _githubTokenController = TextEditingController();
    _githubUrlController = TextEditingController();
    _linkedinUrlController = TextEditingController();
    _facebookUrlController = TextEditingController();
    _instagramUrlController = TextEditingController();
    _threadsUrlController = TextEditingController();
    _snapchatUrlController = TextEditingController();
    _whatsappChannelUrlController = TextEditingController();
    _whatsappNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _aboutMeController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _githubUsernameController.dispose();
    _githubTokenController.dispose();
    _githubUrlController.dispose();
    _linkedinUrlController.dispose();
    _facebookUrlController.dispose();
    _instagramUrlController.dispose();
    _threadsUrlController.dispose();
    _snapchatUrlController.dispose();
    _whatsappChannelUrlController.dispose();
    _whatsappNumberController.dispose();
    super.dispose();
  }

  void _populateFields(AdminData data) {
    _fullNameController.text = data.fullName;
    _jobTitleController.text = data.jobTitle;
    _aboutMeController.text = data.aboutMe;
    _bioController.text = data.bio;
    _locationController.text = data.location;
    _emailController.text = data.email;
    _phoneController.text = data.phone;
    _githubUsernameController.text = data.githubUsername;
    _githubTokenController.text = data.githubToken;
    _githubUrlController.text = data.githubUrl;
    _linkedinUrlController.text = data.linkedinUrl;
    _facebookUrlController.text = data.facebookUrl;
    _instagramUrlController.text = data.instagramUrl;
    _threadsUrlController.text = data.threadsUrl;
    _snapchatUrlController.text = data.snapchatUrl;
    _whatsappChannelUrlController.text = data.whatsappChannelUrl;
    _whatsappNumberController.text = data.whatsappNumber;
  }

  Future<void> _syncGitHubRepos() async {
    setState(() => _isSyncingGitHub = true);
    try {
      final repo = ref.read(githubRepositoryProvider);
      final cache = GithubCacheRepository();
      await cache.clear();
      final repos = await repo.getRepositories();
      final user = await repo.getUser();
      await cache.saveRepos(repos);
      await cache.saveUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Synced ${repos.length} repos successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncingGitHub = false);
    }
  }

  Future<void> _pickImage() async {
    final repo = ref.read(adminRepositoryProvider);
    final path = await repo.pickAndSaveImage();
    if (path != null && mounted) {
      ref.invalidate(adminImageProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.adminImagePicked)),
      );
    }
  }

  Future<void> _restoreImage() async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.clearImage();
    if (mounted) {
      ref.invalidate(adminImageProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.adminImageRestored)),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final adminData = AdminData(
      fullName: _fullNameController.text.trim(),
      jobTitle: _jobTitleController.text.trim(),
      aboutMe: _aboutMeController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      githubUsername: _githubUsernameController.text.trim(),
      githubToken: _githubTokenController.text.trim(),
      githubUrl: _githubUrlController.text.trim(),
      linkedinUrl: _linkedinUrlController.text.trim(),
      facebookUrl: _facebookUrlController.text.trim(),
      instagramUrl: _instagramUrlController.text.trim(),
      threadsUrl: _threadsUrlController.text.trim(),
      snapchatUrl: _snapchatUrlController.text.trim(),
      whatsappChannelUrl: _whatsappChannelUrlController.text.trim(),
      whatsappNumber: _whatsappNumberController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      emailAddress: _emailController.text.trim(),
    );

    try {
      final repo = ref.read(adminRepositoryProvider);
      await repo.saveData(adminData);

      // Update cached GitHub credentials immediately so downstream providers
      // pick up the new value without waiting for adminDataProvider to reload.
      ref.read(githubUsernameProvider.notifier).state =
          adminData.githubUsername;
      ref.read(githubTokenProvider.notifier).state =
          adminData.githubToken;

      // Invalidate adminDataProvider so it reloads from SharedPreferences.
      ref.invalidate(adminDataProvider);

      // Force-refresh all GitHub providers so home stats and project repos
      // update immediately with the new credentials.
      ref.invalidate(githubServiceProvider);
      ref.invalidate(githubRepositoryProvider);
      ref.invalidate(githubUserProvider);
      ref.invalidate(githubReposProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.adminSaved)),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminAsync = ref.watch(adminDataProvider);
    final imageAsync = ref.watch(adminImageProvider);

    return adminAsync.when(
      data: (admin) {
        _populateFields(admin);
        return _buildForm(imageAsync.valueOrNull);
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildForm(Uint8List? customImage) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        title: const Text(AppStrings.adminPanel),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    AppStrings.adminSave,
                    style: TextStyle(color: AppColors.white),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(AppStrings.adminProfileSection),
              _buildTextField(_fullNameController, AppStrings.adminFullName),
              _buildTextField(_jobTitleController, AppStrings.adminJobTitle),
              _buildTextField(
                _aboutMeController,
                AppStrings.adminAboutMe,
                maxLines: 3,
              ),
              _buildTextField(
                _bioController,
                AppStrings.adminBio,
                maxLines: 3,
              ),
              _buildTextField(_locationController, AppStrings.adminLocation),
              const SizedBox(height: AppDimens.paddingMd),
              _SectionHeader(AppStrings.adminContactSection),
              _buildTextField(_emailController, AppStrings.adminEmail,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(_phoneController, AppStrings.adminPhone,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: AppDimens.paddingMd),
              _SectionHeader(AppStrings.adminImageSection),
              const SizedBox(height: AppDimens.paddingSm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                child: customImage != null
                    ? Image.memory(
                        customImage,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/aak.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: AppDimens.paddingSm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image, size: 18),
                      label: const Text(AppStrings.adminPickImage),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingSm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _restoreImage,
                      icon: const Icon(Icons.restore, size: 18),
                      label: const Text(AppStrings.adminRestoreImage),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white70,
                        side: const BorderSide(color: AppColors.white70),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingMd),
              _SectionHeader(AppStrings.adminSocialSection),
              _buildTextField(_githubUrlController, AppStrings.adminGithubUrl),
              _buildTextField(
                  _linkedinUrlController, AppStrings.adminLinkedinUrl),
              _buildTextField(
                  _facebookUrlController, AppStrings.adminFacebookUrl),
              _buildTextField(
                  _instagramUrlController, AppStrings.adminInstagramUrl),
              _buildTextField(
                  _threadsUrlController, AppStrings.adminThreadsUrl),
              _buildTextField(
                  _snapchatUrlController, AppStrings.adminSnapchatUrl),
              _buildTextField(_whatsappChannelUrlController,
                  AppStrings.adminWhatsappChannelUrl),
              _buildTextField(
                  _whatsappNumberController, AppStrings.adminWhatsappNumber),
              const SizedBox(height: AppDimens.paddingMd),
              _SectionHeader(AppStrings.adminGithubSection),
              _buildTextField(
                  _githubUsernameController, AppStrings.adminGithubUsername),
              const SizedBox(height: AppDimens.paddingSm),
              _buildTextField(
                  _githubTokenController, 'GitHub Token (optional)',
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword),
              const SizedBox(height: AppDimens.paddingSm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSyncingGitHub ? null : _syncGitHubRepos,
                  icon: _isSyncingGitHub
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync, size: 18),
                  label: Text(
                      _isSyncingGitHub ? 'Syncing...' : 'Sync GitHub Repos Now'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.white70),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.paddingLg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : const Text(AppStrings.adminSave),
                ),
              ),
              const SizedBox(height: AppDimens.paddingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingSm),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingSm),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: AppDimens.fontLg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
