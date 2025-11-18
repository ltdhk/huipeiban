import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/patient.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

part 'patient_api_provider.g.dart';

/// 就诊人响应模型
class PatientListResponse {
  final List<Patient> list;
  final int total;

  PatientListResponse({required this.list, required this.total});

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    return PatientListResponse(
      list: (json['list'] as List<dynamic>)
          .map((e) => Patient.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}

/// 就诊人 API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class PatientApiProvider {
  factory PatientApiProvider(Dio dio, {String baseUrl}) = _PatientApiProvider;

  /// 获取就诊人列表
  @GET(ApiConstants.patients)
  Future<ApiResponse<PatientListResponse>> getPatients();

  /// 获取就诊人详情
  @GET('${ApiConstants.patients}/{id}')
  Future<ApiResponse<Patient>> getPatient(@Path('id') int id);

  /// 创建就诊人
  @POST(ApiConstants.patients)
  Future<ApiResponse<Patient>> createPatient(@Body() Map<String, dynamic> data);

  /// 更新就诊人
  @PUT('${ApiConstants.patients}/{id}')
  Future<ApiResponse<Patient>> updatePatient(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  /// 删除就诊人
  @DELETE('${ApiConstants.patients}/{id}')
  Future<HttpResponse<void>> deletePatient(@Path('id') int id);

  /// 设置默认就诊人
  @POST('${ApiConstants.patients}/{id}/set-default')
  Future<ApiResponse<Patient>> setDefaultPatient(@Path('id') int id);
}
