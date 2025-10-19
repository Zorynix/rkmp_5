import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prac5/services/profile_service.dart';
import 'package:prac5/services/image_service.dart';
import 'package:prac5/services/theme_service.dart';

class ProfileScreen extends StatefulWidget {
  final ThemeService? themeService;

  const ProfileScreen({super.key, this.themeService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final ImageService _imageService = ImageService();
  final TextEditingController _nicknameController = TextEditingController();

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _profileService.getProfile();
    setState(() {
      _profile = profile;
      _nicknameController.text = profile.nickname;
      _isLoading = false;
    });
  }

  Future<void> _saveNickname() async {
    if (_nicknameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Никнейм не может быть пустым')),
      );
      return;
    }

    await _profileService.updateNickname(_nicknameController.text.trim());
    setState(() {
      _profile?.nickname = _nicknameController.text.trim();
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Никнейм обновлен')),
      );
    }
  }

  Future<void> _changeAvatar() async {
    final newAvatarUrl = await _imageService.getNextAvatar();

    if (newAvatarUrl == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет доступных аватарок. Требуется интернет для загрузки новых.')),
        );
      }
      return;
    }
    await _profileService.updateAvatar(newAvatarUrl);

    setState(() {
      _profile = UserProfile(
        id: _profile!.id,
        nickname: _profile!.nickname,
        avatarUrl: newAvatarUrl,
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Аватар обновлен')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: _isEditing
                  ? IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: _saveNickname,
                      tooltip: 'Сохранить',
                    )
                  : IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => setState(() => _isEditing = true),
                      tooltip: 'Редактировать',
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _profile!.avatarUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 80),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _changeAvatar,
                      tooltip: 'Изменить аватар',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_isEditing)
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Никнейм',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                onSubmitted: (_) => _saveNickname(),
              )
            else
              Text(
                _profile!.nickname,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            Text(
              'ID: ${_profile!.id}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            if (widget.themeService != null)
              Card(
                child: ListTile(
                  leading: Icon(
                    widget.themeService!.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  title: const Text('Темная тема'),
                  subtitle: Text(
                    widget.themeService!.isDarkMode
                        ? 'Включена'
                        : 'Выключена',
                  ),
                  trailing: Switch(
                    value: widget.themeService!.isDarkMode,
                    onChanged: (value) {
                      widget.themeService!.toggleTheme();
                      setState(() {});
                    },
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'О приложении',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.info_outline,
                      'Изображения кэшируются автоматически',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.cloud_download,
                      'Работает с интернетом и без него',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.image,
                      'Случайные изображения от Picsum Photos',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
