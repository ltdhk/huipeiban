import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/service.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

part 'service_api_provider.g.dart';

/// 服务列表响应模型
class ServiceListResponse {
  final List<Service> list;
  final int total;
  final int page;
  final int pageSize;

  ServiceListResponse({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) {
    return ServiceListResponse(
      list: (json['list'] as List<dynamic>)
          .map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }
}

/// 服务切换状态响应模型
class ServiceToggleResponse {
  final bool isActive;

  ServiceToggleResponse({required this.isActive});

  factory ServiceToggleResponse.fromJson(Map<String, dynamic> json) {
    return ServiceToggleResponse(
      isActive: json['is_active'] as bool,
    );
  }
}

/// 服务 API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class ServiceApiProvider {
  factory ServiceApiProvider(Dio dio, {String baseUrl}) = _ServiceApiProvider;

  /// 获取服务列表
  @GET(ApiConstants.services)
  Future<ApiResponse<ServiceListResponse>> getServices(
    @Query('page') int page,
    @Query('page_size') int pageSize,
    @Query('is_active') String? isActive,
  );

  /// 获取服务详情
  @GET('${ApiConstants.services}/{id}')
  Future<ApiResponse<Service>> getService(@Path('id') int id);

  /// 创建服务
  @POST(ApiConstants.services)
  Future<ApiResponse<Service>> createService(@Body() Map<String, dynamic> data);

  /// 更新服务
  @PUT('${ApiConstants.services}/{id}')
  Future<ApiResponse<Service>> updateService(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  /// 删除服务
  @DELETE('${ApiConstants.services}/{id}')
  Future<HttpResponse<void>> deleteService(@Path('id') int id);

  /// 切换服务上下架状态
  @POST('${ApiConstants.services}/{id}/toggle')
  Future<ApiResponse<ServiceToggleResponse>> toggleService(@Path('id') int id);
}
