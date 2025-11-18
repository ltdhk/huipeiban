import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';
import '../providers/auth_api_provider.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/storage_service.dart';

/// 认证仓库
class AuthRepository {
  final AuthApiProvider _apiProvider;
  final StorageService _storage = StorageService();
  final Logger _logger = Logger();

  AuthRepository() : _apiProvider = AuthApiProvider(DioClient().dio);

  /// 手机号密码登录
  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiProvider.login({
        'phone': phone,
        'password': password,
      });

      if (response.success && response.data != null) {
        final authResponse = response.data!;

        // 保存 Token
        await _saveTokens(authResponse);

        // 保存用户信息
        if (authResponse.user != null) {
          await _storage.saveUserId(authResponse.user!.id);
        }

        _logger.i('登录成功: ${authResponse.user?.nickname ?? authResponse.user?.phone}');
        return authResponse;
      } else {
        throw Exception(response.message ?? '登录失败');
      }
    } on DioException catch (e) {
      _logger.e('登录失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 微信登录
  Future<AuthResponse> wechatLogin({
    required String code,
  }) async {
    try {
      final response = await _apiProvider.wechatLogin({
        'code': code,
      });

      if (response.success && response.data != null) {
        final authResponse = response.data!;
        await _saveTokens(authResponse);

        if (authResponse.user != null) {
          await _storage.saveUserId(authResponse.user!.id);
        }

        _logger.i('微信登录成功');
        return authResponse;
      } else {
        throw Exception(response.message ?? '微信登录失败');
      }
    } on DioException catch (e) {
      _logger.e('微信登录失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 刷新 Token
  Future<AuthResponse> refreshToken() async {
    try {
      final response = await _apiProvider.refreshToken();

      if (response.success && response.data != null) {
        final authResponse = response.data!;
        await _saveTokens(authResponse);
        _logger.i('Token 刷新成功');
        return authResponse;
      } else {
        throw Exception('Token 刷新失败');
      }
    } on DioException catch (e) {
      _logger.e('Token 刷新失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 获取当前用户信息
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiProvider.getCurrentUser();

      if (response.success && response.data != null) {
        _logger.i('获取用户信息成功');
        return response.data!;
      } else {
        throw Exception(response.message ?? '获取用户信息失败');
      }
    } on DioException catch (e) {
      _logger.e('获取用户信息失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 绑定手机号
  Future<User> bindPhone({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _apiProvider.bindPhone({
        'phone': phone,
        'code': code,
      });

      if (response.success && response.data != null) {
        _logger.i('绑定手机号成功');
        return response.data!;
      } else {
        throw Exception(response.message ?? '绑定手机号失败');
      }
    } on DioException catch (e) {
      _logger.e('绑定手机号失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      await _apiProvider.logout();
      await _storage.clearTokens();
      _logger.i('登出成功');
    } on DioException catch (e) {
      _logger.e('登出失败: ${e.message}');
      // 即使 API 调用失败，也清除本地 Token
      await _storage.clearTokens();
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// 更新用户资料
  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiProvider.updateProfile(data);

      if (response.success && response.data != null) {
        _logger.i('更新资料成功');
        return response.data!;
      } else {
        throw Exception(response.message ?? '更新资料失败');
      }
    } on DioException catch (e) {
      _logger.e('更新资料失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 获取用户资料
  Future<User> getProfile() async {
    try {
      final response = await _apiProvider.getProfile();

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? '获取资料失败');
      }
    } on DioException catch (e) {
      _logger.e('获取资料失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 保存 Tokens
  Future<void> _saveTokens(AuthResponse authResponse) async {
    await _storage.saveAccessToken(authResponse.accessToken);
    await _storage.saveRefreshToken(authResponse.refreshToken);
  }
}
