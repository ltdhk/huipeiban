import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/companion.dart';
import '../models/service.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

part 'companion_api_provider.g.dart';

/// 陪诊师详情响应（包含服务列表）
class CompanionDetailResponse {
  final Companion companion;
  final List<Service> services;

  CompanionDetailResponse({
    required this.companion,
    required this.services,
  });

  factory CompanionDetailResponse.fromJson(Map<String, dynamic> json) {
    // 从 JSON 中提取服务列表
    final services = (json['services'] as List<dynamic>?)
            ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // 移除 services 字段，剩余的就是 companion 数据
    final companionData = Map<String, dynamic>.from(json);
    companionData.remove('services');
    companionData.remove('institution'); // 也移除 institution，如果不需要的话

    return CompanionDetailResponse(
      companion: Companion.fromJson(companionData),
      services: services,
    );
  }
}

/// 陪诊师 API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class CompanionApiProvider {
  factory CompanionApiProvider(Dio dio, {String baseUrl}) =
      _CompanionApiProvider;

  /// 获取陪诊师详情（包含服务列表）
  @GET('${ApiConstants.companions}/{id}')
  Future<ApiResponse<CompanionDetailResponse>> getCompanionDetail(
    @Path('id') int id,
  );
}
