import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  static const int _imagePoolSize = 20;
  static const int _avatarPoolSize = 10;
  static const String _keyUsedImages = 'used_images';
  static const String _keyAvailableImages = 'available_images';
  static const String _keyUsedAvatars = 'used_avatars';
  static const String _keyAvailableAvatars = 'available_avatars';

  List<String> _availableImages = [];
  Set<String> _usedImages = {};
  List<String> _availableAvatars = [];
  Set<String> _usedAvatars = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    final usedImagesJson = prefs.getString(_keyUsedImages);
    final availableImagesJson = prefs.getString(_keyAvailableImages);

    if (usedImagesJson != null) {
      _usedImages = Set<String>.from(jsonDecode(usedImagesJson));
    }

    if (availableImagesJson != null) {
      _availableImages = List<String>.from(jsonDecode(availableImagesJson));
    }

    final usedAvatarsJson = prefs.getString(_keyUsedAvatars);
    final availableAvatarsJson = prefs.getString(_keyAvailableAvatars);

    if (usedAvatarsJson != null) {
      _usedAvatars = Set<String>.from(jsonDecode(usedAvatarsJson));
    }

    if (availableAvatarsJson != null) {
      _availableAvatars = List<String>.from(jsonDecode(availableAvatarsJson));
    }

    if (_availableImages.isEmpty) {
      await _generateImagePool();
    }

    if (_availableAvatars.isEmpty) {
      await _generateAvatarPool();
    }

    _isInitialized = true;
  }


  Future<void> _generateImagePool() async {
    _availableImages.clear();

    for (int i = 0; i < _imagePoolSize; i++) {
      final seed = DateTime.now().millisecondsSinceEpoch + i;
      final url = 'https://picsum.photos/seed/book$seed/400/600';
      _availableImages.add(url);
    }

    await _saveState();
  }


  Future<void> _generateAvatarPool() async {
    _availableAvatars.clear();

    for (int i = 0; i < _avatarPoolSize; i++) {
      final seed = DateTime.now().millisecondsSinceEpoch + i + 10000;
      final url = 'https://picsum.photos/seed/avatar$seed/400/400';
      _availableAvatars.add(url);
    }

    await _saveState();
  }

  Future<void> preloadImagePool() async {
    await initialize();

    for (final url in _availableImages) {
      try {
        await _cacheManager.downloadFile(url);
        print('Предзагружено изображение книжки: $url');
      } catch (e) {
        print('Ошибка предзагрузки $url: $e');
      }
    }

    for (final url in _availableAvatars) {
      try {
        await _cacheManager.downloadFile(url);
        print('Предзагружена аватарка: $url');
      } catch (e) {
        print('Ошибка предзагрузки аватарки $url: $e');
      }
    }
  }

  Future<String?> getNextBookImage() async {
    await initialize();

    if (_availableImages.isEmpty) {
      await _generateImagePool();
      _preloadImages(_availableImages).catchError((e) => print('Не удалось предзагрузить новые изображения: $e'));
    }

    if (_availableImages.isEmpty) {
      return null;
    }

    final imageUrl = _availableImages.removeAt(0);
    _usedImages.add(imageUrl);
    await _saveState();

    return imageUrl;
  }

  Future<String?> getNextAvatar() async {
    await initialize();

    if (_availableAvatars.isEmpty) {
      await _generateAvatarPool();
      _preloadImages(_availableAvatars).catchError((e) => print('Не удалось предзагрузить новые аватарки: $e'));
    }

    if (_availableAvatars.isEmpty) {
      return null;
    }

    final avatarUrl = _availableAvatars.removeAt(0);
    _usedAvatars.add(avatarUrl);
    await _saveState();

    return avatarUrl;
  }

  Future<void> _preloadImages(List<String> urls) async {
    for (final url in urls) {
      try {
        await _cacheManager.downloadFile(url);
      } catch (e) {
        print('Ошибка предзагрузки $url: $e');
      }
    }
  }

  Future<void> releaseImage(String imageUrl) async {
    await initialize();

    if (_usedImages.contains(imageUrl)) {
      _usedImages.remove(imageUrl);
      _availableImages.add(imageUrl);
      await _saveState();
    }

  }

  Future<void> releaseAvatar(String avatarUrl) async {
    await initialize();

    if (_usedAvatars.contains(avatarUrl)) {
      _usedAvatars.remove(avatarUrl);
      _availableAvatars.add(avatarUrl);
      await _saveState();
    }

  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsedImages, jsonEncode(_usedImages.toList()));
    await prefs.setString(_keyAvailableImages, jsonEncode(_availableImages));
    await prefs.setString(_keyUsedAvatars, jsonEncode(_usedAvatars.toList()));
    await prefs.setString(_keyAvailableAvatars, jsonEncode(_availableAvatars));
  }

  String getRandomBookImageUrl(String bookId) {
    final seed = bookId.hashCode.abs();
    return 'https://picsum.photos/seed/$seed/400/600';
  }

  String getRandomProfileImageUrl(String userId) {
    final seed = userId.hashCode.abs();
    return 'https://picsum.photos/seed/user$seed/400/400';
  }

  Future<void> removeFromCache(String url) async {
    try {
      await _cacheManager.removeFile(url);
    } catch (e) {
      print('Ошибка при удалении изображения из кэша: $e');
    }
  }

  Future<void> preloadImage(String url) async {
    try {
      await _cacheManager.downloadFile(url);
    } catch (e) {
      print('Ошибка при предзагрузке изображения: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
    } catch (e) {
      print('Ошибка при очистке кэша: $e');
    }
  }

  Future<int> getAvailableImagesCount() async {
    await initialize();
    return _availableImages.length;
  }

  Future<int> getAvailableAvatarsCount() async {
    await initialize();
    return _availableAvatars.length;
  }
}
