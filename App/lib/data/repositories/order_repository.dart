import '../models/order.dart';
import '../providers/order_api_provider.dart';
import '../../core/network/dio_client.dart';

/// 订单 Repository
class OrderRepository {
  late final OrderApiProvider _apiProvider;

  OrderRepository() {
    _apiProvider = OrderApiProvider(DioClient().dio);
  }

  /// 创建订单
  Future<Map<String, dynamic>> createOrder({
    required int patientId,
    required String orderType,
    int? companionId,
    int? institutionId,
    int? serviceId,
    int? serviceSpecId,
    required String hospitalName,
    String? hospitalAddress,
    String? department,
    required DateTime appointmentDate,
    required String appointmentTime,
    bool needPickup = false,
    String? pickupType,
    int? pickupAddressId,
    required double servicePrice,
    double pickupPrice = 0.0,
    int? couponId,
    String? userNote,
  }) async {
    final response = await _apiProvider.createOrder({
      'patient_id': patientId,
      'order_type': orderType,
      if (companionId != null) 'companion_id': companionId,
      if (institutionId != null) 'institution_id': institutionId,
      if (serviceId != null) 'service_id': serviceId,
      if (serviceSpecId != null) 'service_spec_id': serviceSpecId,
      'hospital_name': hospitalName,
      if (hospitalAddress != null) 'hospital_address': hospitalAddress,
      if (department != null) 'department': department,
      'appointment_date': '${appointmentDate.year}-${_padZero(appointmentDate.month)}-${_padZero(appointmentDate.day)}',
      'appointment_time': appointmentTime,
      'need_pickup': needPickup,
      if (pickupType != null) 'pickup_type': pickupType,
      if (pickupAddressId != null) 'pickup_address_id': pickupAddressId,
      'service_price': servicePrice,
      'pickup_price': pickupPrice,
      if (couponId != null) 'coupon_id': couponId,
      if (userNote != null) 'user_note': userNote,
    });

    // response 现在直接是后端返回的 JSON (dynamic 类型)
    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '创建订单失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 获取订单列表
  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? orderType,
  }) async {
    final response = await _apiProvider.getOrders(
      page,
      pageSize,
      status,
      orderType,
    );

    // response 现在直接是后端返回的 JSON (dynamic 类型)
    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '获取订单列表失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 获取订单详情
  Future<Order> getOrderDetail(int orderId) async {
    final response = await _apiProvider.getOrderDetail(orderId);

    if (!response.success) {
      throw Exception(response.message);
    }

    return response.data!;
  }

  /// 取消订单
  Future<Map<String, dynamic>> cancelOrder(
    int orderId, {
    String? cancelReason,
  }) async {
    final response = await _apiProvider.cancelOrder(
      orderId,
      {
        if (cancelReason != null) 'cancel_reason': cancelReason,
      },
    );

    // response 现在直接是后端返回的 JSON (dynamic 类型)
    final json = response as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception(json['message'] ?? '取消订单失败');
    }

    return json['data'] as Map<String, dynamic>;
  }

  /// 补零
  String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }
}
