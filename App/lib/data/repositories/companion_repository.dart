import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/companion.dart';
import '../models/service.dart';
import '../providers/companion_api_provider.dart';
import '../../core/network/dio_client.dart';

/// 陪诊师仓库
class CompanionRepository {
  final CompanionApiProvider _apiProvider;
  final Logger _logger = Logger();

  CompanionRepository() : _apiProvider = CompanionApiProvider(DioClient().dio);

  /// 获取陪诊师详情（包含服务列表）
  Future<CompanionDetailResponse> getCompanionDetail(int id) async {
    try {
      final response = await _apiProvider.getCompanionDetail(id);

      if (response.success && response.data != null) {
        _logger.i('获取陪诊师详情成功: ${response.data!.companion.name}, 服务数量: ${response.data!.services.length}');
        return response.data!;
      } else {
        throw Exception(response.message ?? '获取陪诊师详情失败');
      }
    } on DioException catch (e) {
      _logger.e('获取陪诊师详情失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 获取陪诊师的服务列表
  Future<List<Service>> getCompanionServices(int companionId) async {
    try {
      final detail = await getCompanionDetail(companionId);
      return detail.services;
    } catch (e) {
      _logger.e('获取陪诊师服务列表失败: $e');
      rethrow;
    }
  }
}
