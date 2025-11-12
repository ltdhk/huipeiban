/**
 * API 接口统一管理
 */
const { get, post, put, delete: del } = require('./request.js');

// ============= 用户认证 =============

/**
 * 微信登录
 */
function wechatLogin(code) {
  return post('/user/auth/wechat-login', { code });
}

/**
 * 刷新 token
 */
function refreshToken(refreshToken) {
  return post('/user/auth/refresh-token', { refreshToken });
}

/**
 * 绑定手机号
 */
function bindPhone(data) {
  return post('/user/auth/bind-phone', data);
}

// ============= 用户信息 =============

/**
 * 获取用户信息
 */
function getUserProfile() {
  return get('/user/profile');
}

/**
 * 更新用户信息
 */
function updateUserProfile(data) {
  return put('/user/profile', data);
}

// ============= 就诊人管理 =============

/**
 * 获取就诊人列表
 */
function getPatients() {
  return get('/user/patients');
}

/**
 * 创建就诊人
 */
function createPatient(data) {
  return post('/user/patients', data);
}

/**
 * 更新就诊人
 */
function updatePatient(id, data) {
  return put(`/user/patients/${id}`, data);
}

/**
 * 删除就诊人
 */
function deletePatient(id) {
  return del(`/user/patients/${id}`);
}

// ============= 地址管理 =============

/**
 * 获取地址列表
 */
function getAddresses() {
  return get('/user/addresses');
}

/**
 * 创建地址
 */
function createAddress(data) {
  return post('/user/addresses', data);
}

/**
 * 更新地址
 */
function updateAddress(id, data) {
  return put(`/user/addresses/${id}`, data);
}

/**
 * 删除地址
 */
function deleteAddress(id) {
  return del(`/user/addresses/${id}`);
}

// ============= 陪诊师 =============

/**
 * 获取陪诊师列表
 */
function getCompanions(params) {
  return get('/user/companions', params);
}

/**
 * 获取陪诊师详情
 */
function getCompanionDetail(id) {
  return get(`/user/companions/${id}`);
}

// ============= 陪诊机构 =============

/**
 * 获取机构列表
 */
function getInstitutions(params) {
  return get('/user/institutions', params);
}

/**
 * 获取机构详情
 */
function getInstitutionDetail(id) {
  return get(`/user/institutions/${id}`);
}

// ============= 订单管理 =============

/**
 * 创建订单
 */
function createOrder(data) {
  return post('/user/orders', data);
}

/**
 * 获取订单列表
 */
function getOrders(params) {
  return get('/user/orders', params);
}

/**
 * 获取订单详情
 */
function getOrderDetail(id) {
  return get(`/user/orders/${id}`);
}

/**
 * 取消订单
 */
function cancelOrder(id) {
  return post(`/user/orders/${id}/cancel`);
}

/**
 * 确认完成订单
 */
function completeOrder(id) {
  return post(`/user/orders/${id}/complete`);
}

// ============= 支付 =============

/**
 * 创建支付
 */
function createPayment(orderId) {
  return post('/user/payments/create', { orderId });
}

/**
 * 查询支付状态
 */
function getPaymentStatus(paymentId) {
  return get(`/user/payments/${paymentId}/status`);
}

// ============= 消息 =============

/**
 * 获取消息列表
 */
function getMessages(params) {
  return get('/user/messages', params);
}

/**
 * 获取聊天记录
 */
function getChatHistory(conversationId, params) {
  return get(`/user/messages/${conversationId}/history`, params);
}

/**
 * 发送消息
 */
function sendMessage(data) {
  return post('/user/messages/send', data);
}

// ============= AI 对话 =============

/**
 * AI 对话
 */
function aiChat(data) {
  return post('/user/ai/chat', data);
}

/**
 * 获取 AI 对话历史
 */
function getAiChatHistory(params) {
  return get('/user/ai/history', params);
}

// ============= 评价 =============

/**
 * 创建评价
 */
function createReview(data) {
  return post('/user/reviews', data);
}

/**
 * 获取评价列表
 */
function getReviews(params) {
  return get('/user/reviews', params);
}

module.exports = {
  // 认证
  wechatLogin,
  refreshToken,
  bindPhone,

  // 用户
  getUserProfile,
  updateUserProfile,

  // 就诊人
  getPatients,
  createPatient,
  updatePatient,
  deletePatient,

  // 地址
  getAddresses,
  createAddress,
  updateAddress,
  deleteAddress,

  // 陪诊师
  getCompanions,
  getCompanionDetail,

  // 机构
  getInstitutions,
  getInstitutionDetail,

  // 订单
  createOrder,
  getOrders,
  getOrderDetail,
  cancelOrder,
  completeOrder,

  // 支付
  createPayment,
  getPaymentStatus,

  // 消息
  getMessages,
  getChatHistory,
  sendMessage,

  // AI
  aiChat,
  getAiChatHistory,

  // 评价
  createReview,
  getReviews
};
