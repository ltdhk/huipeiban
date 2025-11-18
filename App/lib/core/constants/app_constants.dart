/// 应用全局常量
class AppConstants {
  AppConstants._();

  /// 应用名称
  static const String appName = 'CareLink';

  /// 应用中文名称
  static const String appNameCN = '会照护';

  /// 应用版本
  static const String appVersion = '1.0.0';

  // ==================== 主题颜色 ====================
  /// 主色调 - 紫蓝色
  static const int primaryColorValue = 0xFF667EEA;

  /// 渐变色起始
  static const int gradientStartColor = 0xFF667EEA;

  /// 渐变色结束
  static const int gradientEndColor = 0xFF764BA2;

  // ==================== 分页配置 ====================
  /// 默认每页数量
  static const int defaultPageSize = 20;

  /// 默认起始页码
  static const int defaultPageNumber = 1;

  // ==================== 订单状态 ====================
  /// 待支付
  static const String orderStatusPendingPayment = 'pending_payment';

  /// 待接单
  static const String orderStatusPendingAccept = 'pending_accept';

  /// 待服务
  static const String orderStatusPendingService = 'pending_service';

  /// 服务中
  static const String orderStatusInService = 'in_service';

  /// 已完成
  static const String orderStatusCompleted = 'completed';

  /// 已取消
  static const String orderStatusCancelled = 'cancelled';

  // ==================== 订单类型 ====================
  /// 陪诊师订单
  static const String orderTypeCompanion = 'companion';

  /// 机构订单
  static const String orderTypeInstitution = 'institution';

  // ==================== 性别 ====================
  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const String genderUnknown = 'unknown';

  // ==================== 消息类型 ====================
  static const String messageTypeText = 'text';
  static const String messageTypeImage = 'image';
  static const String messageTypeVoice = 'voice';

  // ==================== 发送者类型 ====================
  static const String senderTypeUser = 'user';
  static const String senderTypeCompanion = 'companion';
  static const String senderTypeInstitution = 'institution';

  // ==================== 用户关系 ====================
  static const String relationshipSelf = 'self';
  static const String relationshipParent = 'parent';
  static const String relationshipSpouse = 'spouse';
  static const String relationshipChild = 'child';
  static const String relationshipOther = 'other';

  // ==================== 地址类型 ====================
  static const String addressTypeHome = 'home';
  static const String addressTypeCompany = 'company';
  static const String addressTypeHospital = 'hospital';
  static const String addressTypeOther = 'other';

  // ==================== 本地存储键 ====================
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserInfo = 'user_info';
  static const String keyIsFirstLaunch = 'is_first_launch';

  // ==================== 图片占位符 ====================
  static const String placeholderAvatar = 'https://ui-avatars.com/api/?name=User&background=667eea&color=fff&size=200';

  // ==================== 时间格式 ====================
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String shortDateTimeFormat = 'MM-dd HH:mm';
}
