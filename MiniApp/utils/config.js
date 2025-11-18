/**
 * 应用配置
 */

// API 基础地址配置
const API_BASE_URL = {
  // 开发环境
  development: 'http://127.0.0.1:5000/api/v1',
  // 生产环境（待配置）
  production: 'https://api.carelink.com/api/v1',
};

// 当前环境
const ENV = 'development'; // 可以根据需要切换为 'production'

// 导出配置
export default {
  // API 基础地址
  apiBaseUrl: API_BASE_URL[ENV],

  // 请求超时时间（毫秒）
  timeout: 10000,

  // Token 存储 key
  tokenKey: 'access_token',
  refreshTokenKey: 'refresh_token',
  userInfoKey: 'userInfo',
};
