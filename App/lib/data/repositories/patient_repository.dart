import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/patient.dart';
import '../providers/patient_api_provider.dart';
import '../../core/network/dio_client.dart';

/// 就诊人仓库
class PatientRepository {
  final PatientApiProvider _apiProvider;
  final Logger _logger = Logger();

  PatientRepository() : _apiProvider = PatientApiProvider(DioClient().dio);

  /// 获取就诊人列表
  Future<List<Patient>> getPatients() async {
    try {
      final response = await _apiProvider.getPatients();

      if (response.success && response.data != null) {
        _logger.i('获取就诊人列表成功: ${response.data!.total} 个');
        return response.data!.list;
      } else {
        throw Exception(response.message ?? '获取就诊人列表失败');
      }
    } on DioException catch (e) {
      _logger.e('获取就诊人列表失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 获取就诊人详情
  Future<Patient> getPatient(int id) async {
    try {
      final response = await _apiProvider.getPatient(id);

      if (response.success && response.data != null) {
        _logger.i('获取就诊人详情成功: ${response.data!.name}');
        return response.data!;
      } else {
        throw Exception(response.message ?? '获取就诊人详情失败');
      }
    } on DioException catch (e) {
      _logger.e('获取就诊人详情失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 创建就诊人（Map 参数版本）
  Future<Patient> createPatient(Map<String, dynamic> data) async {
    try {
      final response = await _apiProvider.createPatient(data);

      if (response.success && response.data != null) {
        _logger.i('创建就诊人成功: ${response.data!.name}');
        return response.data!;
      } else {
        throw Exception(response.message ?? '创建就诊人失败');
      }
    } on DioException catch (e) {
      _logger.e('创建就诊人失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 更新就诊人
  Future<Patient> updatePatient(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiProvider.updatePatient(id, data);

      if (response.success && response.data != null) {
        _logger.i('更新就诊人成功: ${response.data!.name}');
        return response.data!;
      } else {
        throw Exception(response.message ?? '更新就诊人失败');
      }
    } on DioException catch (e) {
      _logger.e('更新就诊人失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 删除就诊人
  Future<void> deletePatient(int id) async {
    try {
      await _apiProvider.deletePatient(id);
      _logger.i('删除就诊人成功: $id');
    } on DioException catch (e) {
      _logger.e('删除就诊人失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }

  /// 设置默认就诊人
  Future<Patient> setDefaultPatient(int id) async {
    try {
      final response = await _apiProvider.setDefaultPatient(id);

      if (response.success && response.data != null) {
        _logger.i('设置默认就诊人成功: ${response.data!.name}');
        return response.data!;
      } else {
        throw Exception(response.message ?? '设置默认就诊人失败');
      }
    } on DioException catch (e) {
      _logger.e('设置默认就诊人失败: ${e.message}');
      throw Exception(e.message ?? '网络错误');
    }
  }
}
