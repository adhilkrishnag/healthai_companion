import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling encryption operations
class EncryptionService {
  final FlutterSecureStorage _secureStorage;

  EncryptionService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Store sensitive data securely
  Future<void> storeSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      debugPrint('Failed to store secure value: $e');
      rethrow;
    }
  }

  /// Retrieve sensitive data
  Future<String?> readSecure(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      debugPrint('Failed to read secure value: $e');
      return null;
    }
  }

  /// Delete sensitive data
  Future<void> deleteSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      debugPrint('Failed to delete secure value: $e');
    }
  }

  /// Clear all secure storage
  Future<void> clearAllSecure() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('Failed to clear secure storage: $e');
    }
  }

  /// Store API key
  Future<void> storeApiKey(String key) async {
    await storeSecure('gemini_api_key', key);
  }

  /// Get API key
  Future<String?> getApiKey() async {
    return readSecure('gemini_api_key');
  }

  /// Encode data to base64
  String encodeToBase64(String data) {
    return base64Encode(utf8.encode(data));
  }

  /// Decode data from base64
  String decodeFromBase64(String encodedData) {
    return utf8.decode(base64Decode(encodedData));
  }

  /// Generate a random secure token
  Uint8List generateSecureToken(int length) {
    final random = Uint8List(length);
    for (int i = 0; i < length; i++) {
      random[i] = DateTime.now().microsecondsSinceEpoch % 256;
    }
    return random;
  }
}
