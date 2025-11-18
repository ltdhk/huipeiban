import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// API 统一响应格式
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    @JsonKey(name: 'timestamp') String? timestamp,
    ApiError? error,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

/// API 错误信息
@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String code,
    required String message,
    List<ErrorDetail>? details,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}

/// 错误详情
@freezed
class ErrorDetail with _$ErrorDetail {
  const factory ErrorDetail({
    required String field,
    required String message,
  }) = _ErrorDetail;

  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
}

/// 分页响应数据
@Freezed(genericArgumentFactories: true)
class PaginatedData<T> with _$PaginatedData<T> {
  const factory PaginatedData({
    required List<T> list,
    required int total,
    required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _PaginatedData;

  factory PaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginatedDataFromJson(json, fromJsonT);
}
