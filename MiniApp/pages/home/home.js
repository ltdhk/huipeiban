// MiniApp/pages/home/home.js
const { aiChat } = require('../../utils/api.js');

Page({
  data: {
    drawerVisible: false,
    currentTab: 'ai',
    inputText: '',
    userInfo: null,
    // AI 聊天相关
    messages: [],
    sessionId: null,
    loading: false,
    scrollIntoView: ''
  },

  onLoad() {
    // 检查登录状态
    const token = wx.getStorageSync('access_token');
    if (!token) {
      // 未登录，跳转到登录页
      wx.reLaunch({
        url: '/pages/login/login'
      });
      return;
    }

    // 加载用户信息
    const userInfo = wx.getStorageSync('userInfo');
    if (userInfo) {
      this.setData({ userInfo });
    }

    // 加载会话历史
    const sessionId = wx.getStorageSync('ai_session_id');
    const messages = wx.getStorageSync('ai_messages') || [];
    if (sessionId && messages.length > 0) {
      this.setData({
        sessionId,
        messages
      });
    }
  },

  onShow() {
    // 每次显示时检查用户信息
    const userInfo = wx.getStorageSync('userInfo');
    if (userInfo) {
      this.setData({ userInfo });
    }
  },

  // 切换抽屉状态
  toggleDrawer() {
    this.setData({
      drawerVisible: !this.data.drawerVisible
    });
  },

  // 切换导航标签
  switchTab(e) {
    const tab = e.currentTarget.dataset.tab;
    this.setData({
      currentTab: tab,
      drawerVisible: false
    });

    // 根据标签导航到对应页面
    switch (tab) {
      case 'ai':
        // 当前页面就是AI预约，不需要跳转
        break;
      case 'order':
        wx.navigateTo({
          url: '/pages/orders/list'
        });
        break;
      case 'message':
        wx.navigateTo({
          url: '/pages/messages/list'
        });
        break;
      case 'profile':
        wx.navigateTo({
          url: '/pages/profile/index'
        });
        break;
    }
  },

  // 前往个人中心
  goToProfile() {
    wx.navigateTo({
      url: '/pages/profile/index'
    });
  },

  // 快速预约
  quickBooking(e) {
    const text = e.currentTarget.dataset.text;
    // 直接在当前页面发送消息
    this.setData({ inputText: text }, () => {
      this.sendMessage();
    });
  },

  // 输入框内容变化
  onInput(e) {
    this.setData({
      inputText: e.detail.value
    });
  },

  // 发送消息
  async sendMessage() {
    const { inputText, loading } = this.data;
    if (!inputText.trim() || loading) {
      if (!inputText.trim()) {
        wx.showToast({
          title: '请输入内容',
          icon: 'none'
        });
      }
      return;
    }

    const message = inputText.trim();

    // 添加用户消息到消息列表
    const userMessage = {
      id: Date.now(),
      role: 'user',
      content: message
    };

    this.data.messages.push(userMessage);

    // 更新UI
    this.setData({
      messages: this.data.messages,
      inputText: '',
      loading: true,
      scrollIntoView: 'bottom'
    });

    try {
      // 调用AI聊天接口
      const res = await aiChat({
        message: message,
        session_id: this.data.sessionId
      });

      if (res.success) {
        // 添加AI回复到消息列表
        // 注意：后端返回的数据在 res.data 中
        const responseData = res.data || res;

        console.log('AI响应数据:', responseData); // 调试用

        const aiMessage = {
          id: Date.now() + 1,
          role: 'assistant',
          content: responseData.message || responseData.content || '回复内容为空',
          recommendations: responseData.recommendations || []
        };

        this.data.messages.push(aiMessage);

        // 更新UI和会话ID
        this.setData({
          messages: this.data.messages,
          sessionId: responseData.session_id,
          loading: false,
          scrollIntoView: 'bottom'
        });

        // 保存会话历史到本地存储
        wx.setStorageSync('ai_session_id', responseData.session_id);
        wx.setStorageSync('ai_messages', this.data.messages);
      } else {
        throw new Error(res.message || '发送失败');
      }
    } catch (error) {
      console.error('发送消息失败:', error);

      // 检查是否是认证错误
      if (error.statusCode === 401 || error.message?.includes('Not enough segments')) {
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
        return;
      }

      wx.showToast({
        title: error.message || '发送失败，请重试',
        icon: 'none',
        duration: 2000
      });

      // 移除刚添加的用户消息
      this.data.messages.pop();

      this.setData({
        messages: this.data.messages,
        inputText: message, // 恢复输入框内容
        loading: false
      });
    }
  },

  // 查看推荐详情
  viewRecommendation(e) {
    const { type, id } = e.currentTarget.dataset;

    if (type === 'companion') {
      // 跳转到陪诊师详情页
      wx.navigateTo({
        url: `/pages/companions/detail?id=${id}`
      });
    } else if (type === 'institution') {
      // 跳转到机构详情页
      wx.navigateTo({
        url: `/pages/institutions/detail?id=${id}`
      });
    }
  },

  // 语音输入
  startVoice() {
    wx.showToast({
      title: '语音功能开发中',
      icon: 'none'
    });
  },

  // 滚动到顶部
  scrollToTop() {
    wx.pageScrollTo({
      scrollTop: 0,
      duration: 300
    });
  },

  // 退出登录
  handleLogout() {
    wx.showModal({
      title: '提示',
      content: '确定要退出登录吗?',
      success: (res) => {
        if (res.confirm) {
          // 清除本地存储
          wx.clearStorageSync();

          // 返回登录页
          wx.reLaunch({
            url: '/pages/login/login'
          });
        }
      }
    });
  }
});
