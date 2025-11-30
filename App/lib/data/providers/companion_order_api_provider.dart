import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../core/constants/api_constants.dart';

part 'companion_order_api_provider.g.dart';

/// 陪诊师订单 API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class CompanionOrderApiProvider {
  factory CompanionOrderApiProvider(Dio dio, {String baseUrl}) =
      _CompanionOrderApiProvider;

  /// 获取陪诊师订单列表
  @GET(ApiConstants.companionOrders)
  @DioResponseType(ResponseType.json)
  Future<dynamic> getOrders(
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Query('status') String? status,
  );

  /// 获取订单详情
  @GET('/companion/orders/{id}')
  @DioResponseType(ResponseType.json)
  Future<dynamic> getOrderDetail(
    @Path('id') int id,
  );

  /// 接受订单
  @POST('/companion/orders/{id}/accept')
  @DioResponseType(ResponseType.json)
  Future<dynamic> acceptOrder(
    @Path('id') int id,
  );

  /// 拒绝订单
  @POST('/companion/orders/{id}/reject')
  @DioResponseType(ResponseType.json)
  Future<dynamic> rejectOrder(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  /// 开始服务
  @POST('/companion/orders/{id}/start')
  @DioResponseType(ResponseType.json)
  Future<dynamic> startService(
    @Path('id') int id,
  );

  /// 完成服务
  @POST('/companion/orders/{id}/complete')
  @DioResponseType(ResponseType.json)
  Future<dynamic> completeService(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  /// 获取订单统计
  @GET(ApiConstants.companionOrderStats)
  @DioResponseType(ResponseType.json)
  Future<dynamic> getOrderStats();
}
