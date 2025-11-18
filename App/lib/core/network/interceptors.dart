import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';

/// 认证拦截器 - 自动添加 Token
class AuthInterceptor extends Interceptor {
  final Logger _logger = Logger();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 从本地存储获取 Token
    final token = await StorageService().getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      _logger.d('添加 Authorization Header: Bearer ${token.substring(0, 20)}...');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 如果是 401 未授权，尝试刷新 Token
    if (err.response?.statusCode == 401) {
      _logger.w('收到 401 响应，尝试刷新 Token');

      try {
        // TODO: 实现 Token 刷新逻辑
        // final newToken = await _refreshToken();
        // if (newToken != null) {
        //   // 重试原请求
        //   final options = err.requestOptions;
        //   options.headers['Authorization'] = 'Bearer $newToken';
        //   final response = await Dio().fetch(options);
        //   return handler.resolve(response);
        // }
      } catch (e) {
        _logger.e('Token 刷新失败: $e');
      }

      // 如果刷新失败，清除本地 Token 并跳转到登录页
      await StorageService().clearTokens();
      // TODO: 导航到登录页
    }

    handler.next(err);
  }
}

/// 日志拦截器
class LoggerInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('''
┌─────────────────────────────────────────────────────────
│ 🌐 请求开始
├─────────────────────────────────────────────────────────
│ URL: ${options.uri}
│ Method: ${options.method}
│ Headers: ${options.headers}
│ Query Parameters: ${options.queryParameters}
│ Data: ${options.data}
└─────────────────────────────────────────────────────────
''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('''
┌─────────────────────────────────────────────────────────
│ ✅ 响应成功
├─────────────────────────────────────────────────────────
│ URL: ${response.requestOptions.uri}
│ Status Code: ${response.statusCode}
│ Data: ${response.data}
└─────────────────────────────────────────────────────────
''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('''
┌─────────────────────────────────────────────────────────
│ ❌ 请求错误
├─────────────────────────────────────────────────────────
│ URL: ${err.requestOptions.uri}
│ Method: ${err.requestOptions.method}
│ Error Type: ${err.type}
│ Error Message: ${err.message}
│ Response: ${err.response?.data}
└─────────────────────────────────────────────────────────
''');
    handler.next(err);
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  final Logger _logger = Logger();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = '连接超时，请检查网络连接';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = '发送超时，请稍后重试';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = '接收超时，请稍后重试';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = '请求已取消';
        break;
      case DioExceptionType.unknown:
        if (err.message?.contains('SocketException') ?? false) {
          errorMessage = '网络连接失败，请检查网络设置';
        } else {
          errorMessage = '未知错误: ${err.message}';
        }
        break;
      default:
        errorMessage = '请求失败: ${err.message}';
    }

    _logger.e('网络错误: $errorMessage');

    // 将错误信息附加到 DioException
    err = err.copyWith(
      message: errorMessage,
    );

    handler.next(err);
  }

  /// 处理 HTTP 状态码
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '禁止访问';
      case 404:
        return '请求的资源不存在';
      case 405:
        return '请求方法不允许';
      case 408:
        return '请求超时';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务暂时不可用';
      case 504:
        return '网关超时';
      default:
        return '请求失败 (状态码: $statusCode)';
    }
  }
}
