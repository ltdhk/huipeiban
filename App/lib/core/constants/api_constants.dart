/// API 常量配置
class ApiConstants {
  ApiConstants._();

  /// API 基础 URL - 可根据环境配置
  /// Android Studio 模拟器: 10.0.2.2
  /// iOS 模拟器: localhost 或 127.0.0.1
  /// 真机/其他设备: 192.168.3.138 (您的局域网IP)
  /// 虚拟机内部: 127.0.0.1 或 198.18.0.1
  static const String baseUrl = 'http://198.18.0.1:5001';
  static const String imBaseUrl = 'http://198.18.0.1:6001';
  static const String imWsUrl = 'ws://198.18.0.1:6001/ws';

  /// API 版本
  static const String apiVersion = '/api/v1';

  /// API 基础路径
  static const String apiBasePath = '$baseUrl$apiVersion';
  static const String imApiBasePath = '$imBaseUrl$apiVersion';

  // ==================== 认证相关 ====================
  /// 微信登录
  static const String wechatLogin = '/user/auth/wechat-login';

  /// 手机登录 (测试用)
  static const String login = '/user/auth/login';

  /// 刷新 Token
  static const String refreshToken = '/user/auth/refresh-token';

  /// 获取当前用户
  static const String currentUser = '/user/auth/current';

  /// 绑定手机号
  static const String bindPhone = '/user/auth/bind-phone';

  /// 登出
  static const String logout = '/user/auth/logout';

  // ==================== 用户相关 ====================
  /// 用户资料
  static const String userProfile = '/user/profile';

  // ==================== 就诊人管理 ====================
  /// 就诊人列表
  static const String patients = '/user/patients';

  /// 就诊人详情
  static String patientDetail(int id) => '/user/patients/$id';

  /// 设置默认就诊人
  static String setDefaultPatient(int id) => '/user/patients/$id/set-default';

  // ==================== 地址管理 ====================
  /// 地址列表
  static const String addresses = '/user/addresses';

  /// 地址详情
  static String addressDetail(int id) => '/user/addresses/$id';

  /// 设置默认地址
  static String setDefaultAddress(int id) => '/user/addresses/$id/set-default';

  // ==================== 订单相关 ====================
  /// 订单列表
  static const String orders = '/user/orders';

  /// 订单详情
  static String orderDetail(int id) => '/user/orders/$id';

  /// 取消订单
  static String cancelOrder(int id) => '/user/orders/$id/cancel';

  // ==================== 支付相关 ====================
  /// 创建支付
  static const String createPayment = '/user/payments/create';

  /// 支付状态
  static String paymentStatus(int id) => '/user/payments/$id/status';

  // ==================== 消息相关 ====================
  /// 会话列表
  static const String conversations = '/user/messages/conversations';

  /// 会话详情
  static String conversationDetail(int id) =>
      '/user/messages/conversations/$id';

  /// 发送消息
  static String sendMessage(int id) =>
      '/user/messages/conversations/$id/messages';

  /// 删除会话
  static String deleteConversation(int id) =>
      '/user/messages/conversations/$id';

  /// 未读消息数
  static const String unreadCount = '/user/messages/unread-count';

  // ==================== AI 聊天相关 ====================
  /// AI 聊天
  static const String aiChat = '/user/ai/chat';

  /// AI 聊天历史
  static const String aiHistory = '/user/ai/history';

  /// AI 会话列表
  static const String aiSessions = '/user/ai/sessions';

  // ==================== 陪诊师相关 ====================
  /// 陪诊师列表
  static const String companions = '/user/companions';

  /// 陪诊师详情
  static String companionDetail(int id) => '/user/companions/$id';

  /// 陪诊师评价列表
  static String companionReviews(int id) => '/user/companions/$id/reviews';

  // ==================== 陪诊师订单管理 ====================
  /// 陪诊师订单列表
  static const String companionOrders = '/companion/orders';

  /// 陪诊师订单详情
  static String companionOrderDetail(int id) => '/companion/orders/$id';

  /// 陪诊师接单
  static String companionAcceptOrder(int id) => '/companion/orders/$id/accept';

  /// 陪诊师拒绝订单
  static String companionRejectOrder(int id) => '/companion/orders/$id/reject';

  /// 陪诊师开始服务
  static String companionStartService(int id) => '/companion/orders/$id/start';

  /// 陪诊师完成服务
  static String companionCompleteService(int id) => '/companion/orders/$id/complete';

  /// 陪诊师订单统计
  static const String companionOrderStats = '/companion/orders/stats';

  // ==================== 服务管理 ====================
  /// 服务列表
  static const String services = '/user/services';

  /// 服务详情
  static String serviceDetail(int id) => '/user/services/$id';

  /// 切换服务状态
  static String toggleService(int id) => '/user/services/$id/toggle';

  // ==================== 评价相关 ====================
  /// 评价列表
  static const String reviews = '/user/reviews';

  /// 评价详情
  static String reviewDetail(int id) => '/user/reviews/$id';

  // ==================== 超时配置 ====================
  /// 连接超时时间 (毫秒)
  static const int connectTimeout = 30000;

  /// 接收超时时间 (毫秒)
  static const int receiveTimeout = 30000;

  /// 发送超时时间 (毫秒)
  static const int sendTimeout = 30000;
}
