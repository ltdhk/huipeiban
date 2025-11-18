import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

/// 本地存储服务
/// 敏感数据使用 FlutterSecureStorage
/// 普通数据使用 SharedPreferences
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  late final FlutterSecureStorage _secureStorage;
  late final SharedPreferences _preferences;
  final Logger _logger = Logger();

  bool _initialized = false;

  StorageService._internal() {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  /// 初始化
  Future<void> init() async {
    if (_initialized) return;

    try {
      _preferences = await SharedPreferences.getInstance();
      _initialized = true;
      _logger.i('StorageService 初始化完成');
    } catch (e) {
      _logger.e('StorageService 初始化失败: $e');
      rethrow;
    }
  }

  // ==================== Token 相关 (安全存储) ====================

  /// 保存访问 Token
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(
        key: AppConstants.keyAccessToken,
        value: token,
      );
      _logger.d('Access Token 已保存');
    } catch (e) {
      _logger.e('保存 Access Token 失败: $e');
      rethrow;
    }
  }

  /// 获取访问 Token
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: AppConstants.keyAccessToken);
    } catch (e) {
      _logger.e('读取 Access Token 失败: $e');
      return null;
    }
  }

  /// 保存刷新 Token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: AppConstants.keyRefreshToken,
        value: token,
      );
      _logger.d('Refresh Token 已保存');
    } catch (e) {
      _logger.e('保存 Refresh Token 失败: $e');
      rethrow;
    }
  }

  /// 获取刷新 Token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: AppConstants.keyRefreshToken);
    } catch (e) {
      _logger.e('读取 Refresh Token 失败: $e');
      return null;
    }
  }

  /// 清除所有 Token
  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: AppConstants.keyAccessToken);
      await _secureStorage.delete(key: AppConstants.keyRefreshToken);
      await _preferences.remove(AppConstants.keyUserId);
      _logger.i('所有 Token 已清除');
    } catch (e) {
      _logger.e('清除 Token 失败: $e');
      rethrow;
    }
  }

  // ==================== 用户信息 (普通存储) ====================

  /// 保存用户 ID
  Future<void> saveUserId(int userId) async {
    try {
      await _preferences.setInt(AppConstants.keyUserId, userId);
      _logger.d('User ID 已保存: $userId');
    } catch (e) {
      _logger.e('保存 User ID 失败: $e');
      rethrow;
    }
  }

  /// 获取用户 ID
  int? getUserId() {
    try {
      return _preferences.getInt(AppConstants.keyUserId);
    } catch (e) {
      _logger.e('读取 User ID 失败: $e');
      return null;
    }
  }

  /// 保存用户信息 (JSON 字符串)
  Future<void> saveUserInfo(String userInfoJson) async {
    try {
      await _preferences.setString(AppConstants.keyUserInfo, userInfoJson);
      _logger.d('用户信息已保存');
    } catch (e) {
      _logger.e('保存用户信息失败: $e');
      rethrow;
    }
  }

  /// 获取用户信息
  String? getUserInfo() {
    try {
      return _preferences.getString(AppConstants.keyUserInfo);
    } catch (e) {
      _logger.e('读取用户信息失败: $e');
      return null;
    }
  }

  // ==================== 应用设置 ====================

  /// 是否首次启动
  bool isFirstLaunch() {
    return _preferences.getBool(AppConstants.keyIsFirstLaunch) ?? true;
  }

  /// 设置已完成首次启动
  Future<void> setFirstLaunchCompleted() async {
    await _preferences.setBool(AppConstants.keyIsFirstLaunch, false);
  }

  // ==================== 通用存储方法 ====================

  /// 保存字符串
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  /// 获取字符串
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// 保存整数
  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  /// 获取整数
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// 保存布尔值
  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  /// 获取布尔值
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// 保存双精度浮点数
  Future<void> setDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  /// 获取双精度浮点数
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// 保存字符串列表
  Future<void> setStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }

  /// 获取字符串列表
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// 移除指定键
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  /// 清除所有数据
  Future<void> clear() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
    _logger.w('所有本地数据已清除');
  }

  /// 检查键是否存在
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}
