import 'dart:async' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiConfig {


  static const String baseUrl = 'https://736313714b87.ngrok-free.app';

  static const String apiVersion = ''; // لا يوجد versioning
  static const Duration timeout = Duration(seconds: 30);

  static const String register = '/register';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String updateProfile = '/update';
  static const String resetPassword = '/reset-password';


  static String getFullUrl(String endpoint) {
    final fullUrl = '$baseUrl$apiVersion$endpoint';
    print('🔗 Full URL: $fullUrl');
    return fullUrl;
  }
}


class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}


class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();


  http.Client get _httpClient {
    return http.Client();
  }


  Future<bool> testConnection() async {
    try {
      final url = Uri.parse(ApiConfig.baseUrl);
      print('🔍 Testing connection to: $url');

      final response = await _httpClient
          .get(url)
          .timeout(Duration(seconds: 10));

      print('✅ Connection test successful: ${response.statusCode}');
      return true;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
  String? _authToken;
  DateTime? _tokenExpiry;


  void setAuthToken(String token, {int expiresIn = 3600}) {
    _authToken = token;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
  }

  bool get isTokenExpired {
    return _tokenExpiry?.isBefore(DateTime.now()) ?? true;
  }


  void clearAuthToken() {
    _authToken = null;
    _tokenExpiry = null;
  }


  Future<Map<String, dynamic>> _makeRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    int retryCount = 1,
  }) async {
    try {
      if (_authToken != null && isTokenExpired) {
        throw ApiException('Session expired', statusCode: 401);
      }

      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));

      // Debug logging
      print('🌐 API Request: ${method.toUpperCase()} $url');
      if (body != null) {
        print('📦 Request Body: ${jsonEncode(body)}');
      }

      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'Ngrok-Skip-Browser-Warning': 'true',
        ...?headers,
      };

      print('📋 Request Headers: $requestHeaders');

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _httpClient
              .get(url, headers: requestHeaders)
              .timeout(ApiConfig.timeout);
          break;
        case 'POST':
          response = await _httpClient
              .post(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(ApiConfig.timeout);
          break;
        case 'PUT':
          response = await _httpClient
              .put(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(ApiConfig.timeout);
          break;
        case 'DELETE':
          response = await _httpClient
              .delete(url, headers: requestHeaders)
              .timeout(ApiConfig.timeout);
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      // Add response interceptor
      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      final responseData = _handleResponse(response);


      if (responseData.containsKey('token')) {
        setAuthToken(responseData['token']);
      }

      return responseData;
    } on http.ClientException catch (e) {
      print('❌ Client Exception: $e');
      throw NetworkException('No internet connection: $e');
    } on FormatException catch (e) {
      print('❌ Format Exception: $e');
      throw ApiException('Invalid response format: $e');
    } on http.TimeoutException catch (e) {
      print('⏰ Timeout Exception: $e');
      throw NetworkException('Request timeout: $e');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        clearAuthToken();

      }

      if (retryCount > 0 && e.statusCode != 401) {
        await Future.delayed(Duration(seconds: 1));
        return _makeRequest(endpoint,
          method: method,
          body: body,
          headers: headers,
          retryCount: retryCount - 1,
        );
      }
      rethrow;
    } catch (e) {
      print('❌ Unexpected Exception: $e');
      if (e is ApiException || e is NetworkException) {
        rethrow;
      }
      throw ApiException('Unexpected error: $e');
    }
  }


  Map<String, dynamic> _handleResponse(http.Response response) {
        print('📊 Response Status: ${response.statusCode}');
        print('📄 Response Headers: ${response.headers}');
        print('📝 Response Body: ${response.body}');

        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (response.body.isEmpty) {
            return {'success': true};
          }
          try {
            return jsonDecode(response.body);
          } catch (e) {
            print('❌ JSON Parse Error: $e');
            throw ApiException('Invalid JSON response', statusCode: response.statusCode);
          }
        } else {
          String errorMessage = 'Request failed';
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorMessage;
            print('⚠️ API Error: $errorMessage');
          } catch (e) {
            print('⚠️ Could not parse error response: $e');

            switch (response.statusCode) {
              case 400:
                errorMessage = 'Bad request';
                break;
              case 401:
                errorMessage = 'Unauthorized';
                break;
              case 403:
                errorMessage = 'Forbidden';
                break;
              case 404:
                errorMessage = 'Not found';
                break;
              case 500:
                errorMessage = 'Internal server error';
                break;
              default:
                errorMessage = 'Request failed with status: ${response.statusCode}';
            }
          }
          throw ApiException(errorMessage, statusCode: response.statusCode);
        }
      }


  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      throw ApiException('All fields are required');
    }

    if (username.length < 4) {
      throw ApiException('Username must be at least 4 characters');
    }

    if (!emailRegex.hasMatch(email)) {
      throw ApiException('Invalid email format');
    }

    if (password.length < 8) {
      throw ApiException('Password must be at least 8 characters');
    }

    final body = {
      'username': username.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      if (fullName != null) 'full_name': fullName.trim(),
      if (phoneNumber != null) 'phone_number': phoneNumber.trim(),
    };

    return await _makeRequest(
      ApiConfig.register,
      method: 'POST',
      body: body,
    );
  }


  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ApiException('Email and password are required');
    }

    final body = {
      'email': email.trim().toLowerCase(),
      'password': password,
    };

    final response = await _makeRequest(
      ApiConfig.login,
      method: 'POST',
      body: body,
    );


    if (response['token'] != null) {
      setAuthToken(response['token']);
    }

    return response;
  }


  Future<Map<String, dynamic>> getUserProfile() async {
    if (_authToken == null) {
      throw ApiException('Authentication required');
    }

    return await _makeRequest(ApiConfig.profile);
  }


  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? bio,
    String? avatar,
  }) async {
    if (_authToken == null) {
      throw ApiException('Authentication required');
    }

    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName.trim();
    if (phoneNumber != null) body['phone_number'] = phoneNumber.trim();
    if (bio != null) body['bio'] = bio.trim();
    if (avatar != null) body['avatar'] = avatar;

    return await _makeRequest(
      ApiConfig.updateProfile,
      method: 'PUT',
      body: body,
    );
  }


  Future<Map<String, dynamic>> resetPassword(String email) async {
    if (email.isEmpty) {
      throw ApiException('Email is required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw ApiException('Please enter a valid email address');
    }

    final body = {
      'email': email.trim().toLowerCase(),
    };

    return await _makeRequest(
      ApiConfig.resetPassword,
      method: 'POST',
      body: body,
    );
  }


  Future<void> refreshToken() async {
    if (_authToken == null) return;

    try {
      final response = await _makeRequest(
        '/auth/refresh',
        method: 'POST',
        body: {'token': _authToken},
      );

      if (response['token'] != null) {
        setAuthToken(response['token']);
      }
    } catch (e) {
      clearAuthToken();
      throw ApiException('Session refresh failed');
    }
  }


  Future<void> logout() async {
    clearAuthToken();

  }


  void dispose() {
    _httpClient.close();
    clearAuthToken();
  }
}

@Deprecated('Use ApiService().registerUser() instead')
Future<void> registerUser(String username, String email, String passwordHash) async {
  try {
    final result = await ApiService().registerUser(
      username: username,
      email: email,
      password: passwordHash,
    );
    print("✅ User registered successfully: ${result}");
  } catch (e) {
    print("❌ Failed to register: $e");
    rethrow;
  }
}