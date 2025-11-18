import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

part 'auth_api_provider.g.dart';

/// 认证 API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class AuthApiProvider {
  factory AuthApiProvider(Dio dio, {String baseUrl}) = _AuthApiProvider;

  /// 微信登录
  @POST(ApiConstants.wechatLogin)
  Future<ApiResponse<AuthResponse>> wechatLogin(
    @Body() Map<String, dynamic> data,
  );

  /// 手机号密码登录 (测试用)
  @POST(ApiConstants.login)
  Future<ApiResponse<AuthResponse>> login(
    @Body() Map<String, dynamic> data,
  );

  /// 刷新 Token
  @POST(ApiConstants.refreshToken)
  Future<ApiResponse<AuthResponse>> refreshToken();

  /// 获取当前用户信息
  @GET(ApiConstants.currentUser)
  Future<ApiResponse<User>> getCurrentUser();

  /// 绑定手机号
  @POST(ApiConstants.bindPhone)
  Future<ApiResponse<User>> bindPhone(
    @Body() Map<String, dynamic> data,
  );

  /// 登出
  @POST(ApiConstants.logout)
  Future<HttpResponse<void>> logout();

  /// 更新用户资料
  @PUT(ApiConstants.userProfile)
  Future<ApiResponse<User>> updateProfile(
    @Body() Map<String, dynamic> data,
  );

  /// 获取用户资料
  @GET(ApiConstants.userProfile)
  Future<ApiResponse<User>> getProfile();
}
