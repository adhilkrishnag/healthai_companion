import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Service for managing Hive local storage with encryption
class HiveService {
  static HiveService? _instance;
  static bool _initialized = false;

  late final Uint8List _encryptionKey;
  final FlutterSecureStorage _secureStorage;

  final Map<String, Box> _openBoxes = {};

  HiveService._({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Get singleton instance
  static HiveService get instance {
    _instance ??= HiveService._();
    return _instance!;
  }

  /// Initialize Hive with encryption
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();
      await _initializeEncryptionKey();
      _initialized = true;
      debugPrint('HiveService initialized successfully');
    } catch (e) {
      throw CacheException(
        message: 'Failed to initialize local storage: $e',
        originalError: e,
      );
    }
  }

  /// Initialize or retrieve encryption key
  Future<void> _initializeEncryptionKey() async {
    try {
      final existingKey = await _secureStorage.read(
        key: AppConstants.encryptionKeyName,
      );

      if (existingKey != null) {
        _encryptionKey = Uint8List.fromList(base64Decode(existingKey));
      } else {
        // Generate new encryption key
        _encryptionKey = Uint8List.fromList(Hive.generateSecureKey());
        await _secureStorage.write(
          key: AppConstants.encryptionKeyName,
          value: base64Encode(_encryptionKey),
        );
      }
    } catch (e) {
      // Fallback for web or when secure storage fails
      debugPrint('Secure storage not available, using default key');
      _encryptionKey = Uint8List.fromList(
        List.generate(32, (i) => i * 7 % 256),
      );
    }
  }

  /// Open an encrypted box
  Future<Box<T>> openBox<T>(String name) async {
    if (!_initialized) {
      throw const CacheException(message: 'HiveService not initialized');
    }

    if (_openBoxes.containsKey(name)) {
      return _openBoxes[name] as Box<T>;
    }

    try {
      final box = await Hive.openBox<T>(
        name,
        encryptionCipher: HiveAesCipher(_encryptionKey),
      );
      _openBoxes[name] = box;
      return box;
    } catch (e) {
      throw CacheException(
        message: 'Failed to open box "$name": $e',
        originalError: e,
      );
    }
  }

  /// Open a lazy box for large datasets
  Future<LazyBox<T>> openLazyBox<T>(String name) async {
    if (!_initialized) {
      throw const CacheException(message: 'HiveService not initialized');
    }

    try {
      return await Hive.openLazyBox<T>(
        name,
        encryptionCipher: HiveAesCipher(_encryptionKey),
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to open lazy box "$name": $e',
        originalError: e,
      );
    }
  }

  /// Get an already opened box
  Box<T>? getBox<T>(String name) {
    return _openBoxes[name] as Box<T>?;
  }

  /// Close a specific box
  Future<void> closeBox(String name) async {
    if (_openBoxes.containsKey(name)) {
      await _openBoxes[name]!.close();
      _openBoxes.remove(name);
    }
  }

  /// Close all boxes
  Future<void> closeAllBoxes() async {
    for (final box in _openBoxes.values) {
      await box.close();
    }
    _openBoxes.clear();
  }

  /// Clear all data (for logout/reset)
  Future<void> clearAllData() async {
    for (final box in _openBoxes.values) {
      await box.clear();
    }
  }

  /// Delete a box completely
  Future<void> deleteBox(String name) async {
    await closeBox(name);
    await Hive.deleteBoxFromDisk(name);
  }

  /// Check if initialized
  bool get isInitialized => _initialized;
}

/// Provider for HiveService
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService.instance;
});
