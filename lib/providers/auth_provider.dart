import 'package:flutter/material.dart';
import '../models/user.dart';
import '../mock_data/mock_users.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isAdminSession = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdminSession => _isAdminSession;

  void loginAsUser() {
    _currentUser = mockCurrentUser;
    _isAdminSession = false;
    notifyListeners();
  }

  void loginAsOwner() {
    _currentUser = mockOwnerUser;
    _isAdminSession = false;
    notifyListeners();
  }

  void loginAsAdmin() {
    _currentUser = mockAdminUser;
    _isAdminSession = true;
    notifyListeners();
  }

  void updateProfile({String? name, String? phone, String? email, String? location}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      phone: phone,
      email: email,
      location: location,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isAdminSession = false;
    notifyListeners();
  }
}
