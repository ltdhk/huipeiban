// MiniApp/pages/profile/index.js
const { getUserProfile } = require('../../utils/api.js');

Page({
  data: {
    userInfo: {
      id: null,
      nickname: '',
      avatar_url: '/assets/default-avatar.png',
      phone: '',
      balance: 0,
      points: 0,
      member_level: 'normal',
      total_orders: 0
    },
    loading: false,
    unreadCount: 0
  },

  onLoad() {
    this.loadUserInfo();
  },

  async loadUserInfo() {
    if (this.data.loading) return;

    this.setData({ loading: true });

    try {
      const res = await getUserProfile();

      if (res.success && res.data) {
        this.setData({
          userInfo: res.data,
          loading: false
        });
      } else {
        throw new Error(res.message || '获取用户信息失败');
      }
    } catch (error) {
      console.error('加载用户信息失败:', error);

      this.setData({ loading: false });

      // 如果未登录,跳转到登录页
      if (error.message && error.message.includes('未登录')) {
        wx.navigateTo({
          url: '/pages/login/index'
        });
      }
    }
  },

  goToPatients() {
    wx.navigateTo({
      url: '/pages/profile/patients'
    });
  },

  goToAddresses() {
    wx.navigateTo({
      url: '/pages/profile/addresses'
    });
  },

  goToOrders() {
    wx.navigateTo({
      url: '/pages/orders/list'
    });
  },

  goToCoupons() {
    wx.navigateTo({
      url: '/pages/profile/coupons'
    });
  },

  goToFavorites() {
    wx.navigateTo({
      url: '/pages/profile/favorites'
    });
  },

  goToSettings() {
    wx.navigateTo({
      url: '/pages/profile/settings'
    });
  },

  goToAbout() {
    wx.navigateTo({
      url: '/pages/profile/about'
    });
  },

  handleLogout() {
    wx.showModal({
      title: '确认退出',
      content: '确定要退出登录吗?',
      success: (res) => {
        if (res.confirm) {
          // TODO: 清除本地登录信息
          this.setData({
            userInfo: {
              id: null,
              nickname: '',
              avatar: '/assets/default-avatar.png',
              phone: ''
            }
          });
          wx.showToast({
            title: '已退出登录',
            icon: 'success'
          });
        }
      }
    });
  },

  onShow() {
    this.loadUserInfo();
  }
});
