import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String fullName;
  final String email;

  UserModel({required this.fullName, required this.email});
}

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final ValueNotifier<UserModel?> currentUserNotifier =
      ValueNotifier<UserModel?>(null);

  final Map<String, Map<String, String>> _registeredUsers = {};
  bool _initialized = false;

  bool get isLoggedIn => currentUserNotifier.value != null;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final sp = await SharedPreferences.getInstance();

      // Load registered accounts
      final String? usersJson = sp.getString('registered_users');
      if (usersJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(usersJson);
        decoded.forEach((key, value) {
          if (value is Map) {
            _registeredUsers[key] = Map<String, String>.from(value);
          }
        });
      }

      // Restore active user session
      final String? savedName = sp.getString('current_user_name');
      final String? savedEmail = sp.getString('current_user_email');
      final bool isLoggedIn = sp.getBool('is_logged_in') ?? false;

      if (isLoggedIn && savedName != null && savedEmail != null) {
        currentUserNotifier.value = UserModel(
          fullName: savedName,
          email: savedEmail,
        );
      }
    } catch (_) {}
  }

  Future<void> _saveStateToPrefs() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('registered_users', jsonEncode(_registeredUsers));

      final user = currentUserNotifier.value;
      if (user != null) {
        await sp.setBool('is_logged_in', true);
        await sp.setString('current_user_name', user.fullName);
        await sp.setString('current_user_email', user.email);
      } else {
        await sp.setBool('is_logged_in', false);
        await sp.remove('current_user_name');
        await sp.remove('current_user_email');
      }
    } catch (_) {}
  }

  String? register({
    required String fullName,
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    if (_registeredUsers.containsKey(cleanEmail)) {
      return 'Email ini sudah terdaftar. Silakan masuk.';
    }

    _registeredUsers[cleanEmail] = {
      'fullName': fullName.trim(),
      'password': password,
    };

    currentUserNotifier.value = UserModel(
      fullName: fullName.trim(),
      email: cleanEmail,
    );

    _saveStateToPrefs();
    return null;
  }

  String? login({
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    if (!_registeredUsers.containsKey(cleanEmail)) {
      if (cleanEmail == 'user@gmail.com' && password == '123456') {
        currentUserNotifier.value = UserModel(
          fullName: 'Penggemar Film',
          email: 'user@gmail.com',
        );
        _saveStateToPrefs();
        return null;
      }
      return 'Email belum terdaftar. Silakan buat akun terlebih dahulu.';
    }

    final userData = _registeredUsers[cleanEmail]!;
    if (userData['password'] != password) {
      return 'Kata sandi salah. Silakan coba lagi.';
    }

    currentUserNotifier.value = UserModel(
      fullName: userData['fullName'] ?? 'Pengguna CinePedia',
      email: cleanEmail,
    );

    _saveStateToPrefs();
    return null;
  }

  void logout() {
    currentUserNotifier.value = null;
    _saveStateToPrefs();
  }
}
