/**
 * 小程序 API 请求封装
 */

// API 基础配置
const config = {
  baseURL: 'http://localhost:5000/api/v1', // 开发环境 API 地址
  timeout: 15000, // 请求超时时间
  header: {
    'Content-Type': 'application/json'
  }
};

/**
 * 获取存储的 token
 */
function getToken() {
  return wx.getStorageSync('access_token') || '';
}

/**
 * 设置 token
 */
function setToken(token) {
  wx.setStorageSync('access_token', token);
}

/**
 * 清除 token
 */
function clearToken() {
  wx.removeStorageSync('access_token');
  wx.removeStorageSync('refresh_token');
  wx.removeStorageSync('userInfo');
}

/**
 * 请求拦截器
 */
function requestInterceptor(options) {
  // 添加 token
  const token = getToken();
  if (token) {
    options.header = {
      ...options.header,
      'Authorization': `Bearer ${token}`
    };
  }

  // 添加时间戳防止缓存
  if (options.method === 'GET') {
    options.url += (options.url.indexOf('?') === -1 ? '?' : '&') + '_t=' + Date.now();
  }

  return options;
}

/**
 * 响应拦截器
 */
function responseInterceptor(res, resolve, reject) {
  const { statusCode, data } = res;

  // HTTP 状态码处理
  if (statusCode === 200 || statusCode === 201) {
    // 统一处理业务响应格式
    if (data.success) {
      // 返回完整的响应对象，包括 data 和 message
      resolve(data);
    } else {
      wx.showToast({
        title: data.error?.message || data.message || '请求失败',
        icon: 'none',
        duration: 2000
      });
      reject(data);
    }
  } else if (statusCode === 401 || (statusCode === 422 && data.msg === 'Not enough segments')) {
    // token 失效或格式错误，清除登录信息，跳转登录页
    clearToken();
    wx.showModal({
      title: '提示',
      content: '登录已过期，请重新登录',
      showCancel: false,
      success: () => {
        wx.reLaunch({
          url: '/pages/login/login'
        });
      }
    });
    reject(data);
  } else if (statusCode === 403) {
    wx.showToast({
      title: '无权限访问',
      icon: 'none'
    });
    reject(data);
  } else if (statusCode === 404) {
    wx.showToast({
      title: '请求的资源不存在',
      icon: 'none'
    });
    reject(data);
  } else if (statusCode === 500) {
    wx.showToast({
      title: '服务器错误',
      icon: 'none'
    });
    reject(data);
  } else {
    wx.showToast({
      title: data.message || '请求失败',
      icon: 'none'
    });
    reject(data);
  }
}

/**
 * 通用请求方法
 */
function request(options) {
  return new Promise((resolve, reject) => {
    // 请求拦截
    options = requestInterceptor({
      ...options,
      url: config.baseURL + options.url,
      timeout: options.timeout || config.timeout,
      header: {
        ...config.header,
        ...options.header
      }
    });

    // 发送请求
    wx.request({
      ...options,
      success: (res) => {
        responseInterceptor(res, resolve, reject);
      },
      fail: (err) => {
        console.error('请求失败:', err);
        wx.showToast({
          title: '网络请求失败',
          icon: 'none'
        });
        reject(err);
      }
    });
  });
}

/**
 * GET 请求
 */
function get(url, data = {}, options = {}) {
  return request({
    url,
    method: 'GET',
    data,
    ...options
  });
}

/**
 * POST 请求
 */
function post(url, data = {}, options = {}) {
  return request({
    url,
    method: 'POST',
    data,
    ...options
  });
}

/**
 * PUT 请求
 */
function put(url, data = {}, options = {}) {
  return request({
    url,
    method: 'PUT',
    data,
    ...options
  });
}

/**
 * DELETE 请求
 */
function del(url, data = {}, options = {}) {
  return request({
    url,
    method: 'DELETE',
    data,
    ...options
  });
}

/**
 * 文件上传
 */
function upload(url, filePath, name = 'file', formData = {}) {
  return new Promise((resolve, reject) => {
    const token = getToken();

    wx.uploadFile({
      url: config.baseURL + url,
      filePath,
      name,
      formData,
      header: {
        'Authorization': `Bearer ${token}`
      },
      success: (res) => {
        const data = JSON.parse(res.data);
        if (data.success) {
          resolve(data.data);
        } else {
          wx.showToast({
            title: data.message || '上传失败',
            icon: 'none'
          });
          reject(data);
        }
      },
      fail: (err) => {
        console.error('上传失败:', err);
        wx.showToast({
          title: '上传失败',
          icon: 'none'
        });
        reject(err);
      }
    });
  });
}

module.exports = {
  request,
  get,
  post,
  put,
  delete: del,
  upload,
  getToken,
  setToken,
  clearToken,
  config
};
