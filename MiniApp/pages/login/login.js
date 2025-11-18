// 登录页面
const app = getApp();
import Toast from 'tdesign-miniprogram/toast/index';
import { login } from '../../utils/api';

Page({
  data: {
    isLoggedIn: false,
    loading: false,
  },

  onLoad() {
    // ===== 测试模式开始 =====
    // 测试模式：自动登录（使用真实的 JWT token）
    const TEST_MODE = true; // 设置为 false 可以禁用测试模式

    if (TEST_MODE) {
      console.log('🧪 测试模式：自动登录');
      const testToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2MzEzMTU2NCwianRpIjoiNzY3NzllMTQtZTUwMC00MTQ5LWIzOTMtMGYxNGI4ZjcxMWFiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IjE3NjMxMTE2MzczNzI2OTEiLCJuYmYiOjE3NjMxMzE1NjQsImNzcmYiOiI1ODZmNGQ3Ni00NDFlLTRjYjAtODFmNC1lNmRiOTcyNjQyMmMiLCJleHAiOjE3NjMxMzg3NjQsInVzZXJfdHlwZSI6InVzZXIiLCJ0aW1lc3RhbXAiOiIyMDI1LTExLTE0VDE0OjQ2OjA0LjU4NzY1NyIsInBob25lIjoiMTM4MDAxMzgwMDEifQ.N96FwIc_PU4HAJeoNw_uXBxugVtJ3X_Um7S9lffiFC4';

      const testUserInfo = {
        id: 1763111637372691,
        nickname: '测试用户1',
        phone: '13800138001'
      };

      wx.setStorageSync('access_token', testToken);
      wx.setStorageSync('userInfo', testUserInfo);

      // 同步到全局数据
      if (app && app.globalData) {
        app.globalData.userInfo = testUserInfo;
        app.globalData.isLoggedIn = true;
      }

      // 延迟跳转，确保存储完成
      setTimeout(() => {
        wx.switchTab({
          url: '/pages/home/home'
        });
      }, 100);

      return; // 立即返回，不执行后续代码
    }
    // ===== 测试模式结束 =====

    // 正常登录流程
    this.checkLoginStatus();
  },

  /**
   * 检查登录状态
   */
  checkLoginStatus() {
    const token = wx.getStorageSync('access_token');
    const userInfo = wx.getStorageSync('userInfo');

    if (token && userInfo) {
      this.setData({
        isLoggedIn: true,
      });
    }
  },

  /**
   * 获取用户信息并登录
   */
  async handleGetUserProfile() {
    try {
      // 获取用户信息
      const { userInfo } = await wx.getUserProfile({
        desc: '用于完善会员资料',
      });

      console.log('获取用户信息成功:', userInfo);

      // 执行微信登录
      await this.performWechatLogin(userInfo);
    } catch (error) {
      console.error('获取用户信息失败:', error);
      if (error.errMsg && error.errMsg.includes('auth deny')) {
        Toast({
          context: this,
          selector: '#t-toast',
          message: '需要授权才能登录',
          theme: 'warning',
        });
      }
    }
  },

  /**
   * 执行微信登录
   */
  async performWechatLogin(userInfo) {
    this.setData({ loading: true });

    try {
      // 获取微信登录 code
      const { code } = await wx.login();

      console.log('微信登录 code:', code);

      // 调用后端登录接口
      const res = await login({
        code,
        userInfo: {
          nickname: userInfo.nickName,
          avatar: userInfo.avatarUrl,
          gender: userInfo.gender,
        },
      });

      console.log('后端登录响应:', res);

      // 保存登录信息
      wx.setStorageSync('access_token', res.data.access_token);
      wx.setStorageSync('refresh_token', res.data.refresh_token);
      wx.setStorageSync('userInfo', res.data.user);

      // 更新全局用户信息
      app.globalData.userInfo = res.data.user;
      app.globalData.isLoggedIn = true;

      // 更新状态
      this.setData({
        isLoggedIn: true,
      });

      Toast({
        context: this,
        selector: '#t-toast',
        message: res.data.is_new_user ? '欢迎加入会照护！' : '登录成功！',
        theme: 'success',
        duration: 1500,
      });

      // 1.5秒后跳转到首页
      setTimeout(() => {
        this.navigateToHome();
      }, 1500);
    } catch (error) {
      console.error('登录失败:', error);
      Toast({
        context: this,
        selector: '#t-toast',
        message: error.message || '登录失败，请稍后重试',
        theme: 'error',
      });
    } finally {
      this.setData({ loading: false });
    }
  },

  /**
   * 跳转到首页
   */
  navigateToHome() {
    wx.reLaunch({
      url: '/pages/home/home',
    });
  },

  /**
   * 显示用户协议
   */
  showUserAgreement() {
    Toast({
      context: this,
      selector: '#t-toast',
      message: '用户协议开发中',
      theme: 'info',
    });
  },

  /**
   * 显示隐私政策
   */
  showPrivacyPolicy() {
    Toast({
      context: this,
      selector: '#t-toast',
      message: '隐私政策开发中',
      theme: 'info',
    });
  },
});
