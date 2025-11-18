import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_controller.g.dart';

/// 认证控制器
@riverpod
class AuthController extends _$AuthController {
  late final AuthRepository _repository;

  @override
  FutureOr<User?> build() async {
    _repository = AuthRepository();

    // 检查是否已登录
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      try {
        // 获取当前用户信息
        return await _repository.getCurrentUser();
      } catch (e) {
        // 如果获取失败，返回 null
        return null;
      }
    }

    return null;
  }

  /// 手机号密码登录
  Future<void> login({
    required String phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final authResponse = await _repository.login(
        phone: phone,
        password: password,
      );
      return authResponse.user;
    });
  }

  /// 微信登录
  Future<void> wechatLogin({
    required String code,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final authResponse = await _repository.wechatLogin(code: code);
      return authResponse.user;
    });
  }

  /// 刷新 Token
  Future<void> refreshToken() async {
    try {
      await _repository.refreshToken();
    } catch (e) {
      // Token 刷新失败，清除登录状态
      state = const AsyncValue.data(null);
    }
  }

  /// 登出
  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }

  /// 绑定手机号
  Future<void> bindPhone({
    required String phone,
    required String code,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await _repository.bindPhone(
        phone: phone,
        code: code,
      );
    });
  }

  /// 更新用户资料
  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await _repository.updateProfile(data);
    });
  }

  /// 刷新用户信息
  Future<void> refreshUserInfo() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await _repository.getCurrentUser();
    });
  }
}

/// 是否已登录 Provider
@riverpod
Future<bool> isLoggedIn(IsLoggedInRef ref) async {
  final user = await ref.watch(authControllerProvider.future);
  return user != null;
}
