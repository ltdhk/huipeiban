import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/order.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

part 'order_api_provider.g.dart';

/// 订单 API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class OrderApiProvider {
  factory OrderApiProvider(Dio dio, {String baseUrl}) = _OrderApiProvider;

  /// 创建订单
  @POST(ApiConstants.orders)
  @DioResponseType(ResponseType.json)
  Future<dynamic> createOrder(
    @Body() Map<String, dynamic> data,
  );

  /// 获取订单列表
  @GET(ApiConstants.orders)
  @DioResponseType(ResponseType.json)
  Future<dynamic> getOrders(
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Query('status') String? status,
    @Query('order_type') String? orderType,
  );

  /// 获取订单详情
  @GET('/user/orders/{id}')
  Future<ApiResponse<Order>> getOrderDetail(
    @Path('id') int id,
  );

  /// 取消订单
  @POST('/user/orders/{id}/cancel')
  @DioResponseType(ResponseType.json)
  Future<dynamic> cancelOrder(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );
}
