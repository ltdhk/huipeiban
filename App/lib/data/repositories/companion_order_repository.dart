import '../providers/companion_order_api_provider.dart';
import '../../core/network/dio_client.dart';

/// 陪诊师订单 Repository
class CompanionOrderRepository {
  late final CompanionOrderApiProvider _apiProvider;

  CompanionOrderRepository() {
    _apiProvider = CompanionOrderApiProvider(DioClient().dio);
  }

  /// 获取陪诊师订单列表
  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final response = await _apiProvider.getOrders(
      page,
      pageSize,
      status,
    );

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '获取订单列表失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 获取订单详情
  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    final response = await _apiProvider.getOrderDetail(orderId);

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '获取订单详情失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 接受订单
  Future<Map<String, dynamic>> acceptOrder(int orderId) async {
    final response = await _apiProvider.acceptOrder(orderId);

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '接单失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 拒绝订单
  Future<Map<String, dynamic>> rejectOrder(
    int orderId, {
    String? rejectReason,
  }) async {
    final response = await _apiProvider.rejectOrder(
      orderId,
      {
        if (rejectReason != null) 'reject_reason': rejectReason,
      },
    );

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '拒绝订单失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 开始服务
  Future<Map<String, dynamic>> startService(int orderId) async {
    final response = await _apiProvider.startService(orderId);

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '开始服务失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 完成服务
  Future<Map<String, dynamic>> completeService(
    int orderId, {
    String? serviceNote,
  }) async {
    final response = await _apiProvider.completeService(
      orderId,
      {
        if (serviceNote != null) 'service_note': serviceNote,
      },
    );

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '完成服务失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 获取订单统计
  Future<Map<String, dynamic>> getOrderStats() async {
    final response = await _apiProvider.getOrderStats();

    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '获取订单统计失败');
    }

    return json['data'] as Map<String, dynamic>;
  }
}
