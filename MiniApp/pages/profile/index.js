// MiniApp/pages/profile/index.js
Page({
  data: {
    userInfo: {
      id: null,
      nickname: '',
      avatar: '/assets/default-avatar.png',
      phone: ''
    }
  },

  onLoad() {
    this.loadUserInfo();
  },

  async loadUserInfo() {
    try {
      // TODO: 从本地存储或后端API获取用户信息
      // 模拟数据
      this.setData({
        userInfo: {
          id: 1,
          nickname: '用户123',
          avatar: '/assets/avatar1.jpg',
          phone: '138****8888'
        }
      });
    } catch (error) {
      console.error('加载用户信息失败:', error);
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
    wx.switchTab({
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
