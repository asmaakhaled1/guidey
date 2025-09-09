import 'package:guidey/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GlobalState {
  static final GlobalState _instance = GlobalState._internal();
  
  String _track = '';
  String? _authToken;
  Map<String, dynamic>? _userProfile;
  bool _isAuthenticated = false;

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();

  String get track => _track;
  set track(String value) {
    _track = value;
  }

  void clearTrack() {
    _track = '';
  }


  String? get authToken => _authToken;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userProfile => _userProfile;

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    _isAuthenticated = true;

    ApiService().setAuthToken(token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    _isAuthenticated = false;
    _userProfile = null;

    ApiService().clearAuthToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> setUserProfile(Map<String, dynamic> profile) async {
    _userProfile = profile;

    final prefs = await SharedPreferences.getInstance();
    

    final profileJson = jsonEncode(profile);
    await prefs.setString('user_profile', profileJson);
    
    print('💾 User profile saved: $profile');
  }


  String? get username => _userProfile?['username'];
  String? get email => _userProfile?['email'];
  String? get fullName => _userProfile?['full_name'];

  // Logout
  Future<void> logout() async {
    try {
      await ApiService().logout();
    } catch (e) {

      print('Logout error: $e');
    } finally {
      await clearAuthToken();
    }
  }

  Future<bool> checkAuthStatus() async {

    if (_authToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
      _userProfile = await _getUserProfileFromPrefs();
    }

    if (_authToken == null) {
      _isAuthenticated = false;
      return false;
    }


    if (_userProfile?['is_local'] == true) {
      _isAuthenticated = true;
      return true;
    }

    try {
      final profile = await ApiService().getUserProfile();
      _userProfile = profile;
      _isAuthenticated = true;
      return true;
    } catch (e) {
      // Token expired or invalid
      await clearAuthToken();
      return false;
    }
  }


  Future<Map<String, dynamic>?> _getUserProfileFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileString = prefs.getString('user_profile');
      if (profileString != null) {
        // Parse JSON string
        final profile = jsonDecode(profileString) as Map<String, dynamic>;
        print('📖 User profile loaded from prefs: $profile');
        return profile;
      }
    } catch (e) {
      print('Error parsing user profile from prefs: $e');
    }
    return null;
  }
}