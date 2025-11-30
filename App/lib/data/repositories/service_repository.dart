import 'package:dio/dio.dart';
import '../models/service.dart';
import '../providers/service_api_provider.dart';
import '../../core/network/dio_client.dart';

/// 服务仓库
class ServiceRepository {
  late final ServiceApiProvider _apiProvider;

  ServiceRepository() {
    _apiProvider = ServiceApiProvider(DioClient().dio);
  }

  /// 获取服务列表
  ///
  /// [page] 页码
  /// [pageSize] 每页数量
  /// [isActive] 是否上架 (true/false/all)
  Future<Map<String, dynamic>> getServices({
    int page = 1,
    int pageSize = 20,
    String? isActive,
  }) async {
    try {
      final response = await _apiProvider.getServices(
        page,
        pageSize,
        isActive,
      );

      if (response.success && response.data != null) {
        return {
          'list': response.data!.list,
          'total': response.data!.total,
          'page': response.data!.page,
          'page_size': response.data!.pageSize,
        };
      }

      throw Exception(response.message ?? '获取服务列表失败');
    } on DioException catch (e) {
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('获取服务列表失败: $e');
    }
  }

  /// 获取服务详情
  ///
  /// [id] 服务ID
  Future<Service> getService(int id) async {
    try {
      final response = await _apiProvider.getService(id);

      if (response.success && response.data != null) {
        return response.data!;
      }

      throw Exception(response.message ?? '获取服务详情失败');
    } on DioException catch (e) {
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('获取服务详情失败: $e');
    }
  }

  /// 创建服务
  ///
  /// [data] 服务数据
  Future<Service> createService(Map<String, dynamic> data) async {
    try {
      final response = await _apiProvider.createService(data);

      if (response.success && response.data != null) {
        return response.data!;
      }

      throw Exception(response.message ?? '创建服务失败');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        throw Exception(errorData['message'] ?? '请求参数错误');
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('创建服务失败: $e');
    }
  }

  /// 更新服务
  ///
  /// [id] 服务ID
  /// [data] 更新数据
  Future<Service> updateService(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiProvider.updateService(id, data);

      if (response.success && response.data != null) {
        return response.data!;
      }

      throw Exception(response.message ?? '更新服务失败');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        throw Exception(errorData['message'] ?? '请求参数错误');
      } else if (e.response?.statusCode == 404) {
        throw Exception('服务不存在');
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('更新服务失败: $e');
    }
  }

  /// 删除服务
  ///
  /// [id] 服务ID
  Future<void> deleteService(int id) async {
    try {
      final response = await _apiProvider.deleteService(id);

      if (response.response.statusCode != 200) {
        throw Exception('删除服务失败');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('服务不存在');
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('删除服务失败: $e');
    }
  }

  /// 切换服务上下架状态
  ///
  /// [id] 服务ID
  Future<bool> toggleService(int id) async {
    try {
      final response = await _apiProvider.toggleService(id);

      if (response.success && response.data != null) {
        return response.data!.isActive;
      }

      throw Exception(response.message ?? '切换服务状态失败');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('服务不存在');
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('切换服务状态失败: $e');
    }
  }

  /// 将Service对象转换为API请求格式
  ///
  /// [service] 服务对象
  static Map<String, dynamic> serviceToJson(Service service) {
    return {
      'title': service.title,
      'category': service.category,
      'description': service.description,
      'features': service.features,
      'base_price': service.basePrice,
      'additional_hour_price': service.additionalHourPrice,
      'is_active': service.isActive,
      'specs': service.specs?.map((spec) => {
        'name': spec.name,
        'description': spec.description,
        'duration_hours': spec.durationHours,
        'price': spec.price,
        'features': spec.features,
        'sort_order': spec.sortOrder,
        'is_active': spec.isActive,
      }).toList() ?? [],
    };
  }
}
