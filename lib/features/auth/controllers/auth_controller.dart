import 'package:flutter/material.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;
  String? _token;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _currentUser != null;

  /// Đăng nhập bằng email và password
  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Gọi API login từ ApiClient
      // Ví dụ:
      // final response = await ApiClient.post(
      //   '/auth/login',
      //   data: {
      //     'email': email,
      //     'password': password,
      //   },
      // );
      // final loginResponse = LoginResponse.fromJson(response);

      // Tạm thời giả lập thành công (for demo)
      await Future.delayed(const Duration(seconds: 2));

      _token = 'demo_token_123';
      _currentUser = UserModel(
        id: '1',
        email: email,
        name: email.split('@')[0],
        createdAt: DateTime.now(),
      );

      // TODO: Lưu token vào FlutterSecureStorage
      // await SecureStorage.saveToken(_token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Đơi mật khẩu
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Gọi API register từ ApiClient
      // Ví dụ:
      // final response = await ApiClient.post(
      //   '/auth/register',
      //   data: {
      //     'email': email,
      //     'password': password,
      //     'name': name,
      //   },
      // );

      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Đăng xuất
  Future<bool> logout() async {
    try {
      // TODO: Xóa token từ FlutterSecureStorage
      // await SecureStorage.deleteToken();

      _token = null;
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Xóa thông báo lỗi
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
