// MiniApp/pages/messages/list.js
Page({
  data: {
    messages: []
  },

  onLoad() {
    this.loadMessages();
  },

  async loadMessages() {
    try {
      // TODO: 调用后端API获取消息列表
      // 模拟数据
      this.setData({
        messages: [
          {
            id: 1,
            name: '张护士',
            avatar: '/assets/avatar1.jpg',
            lastMessage: '好的，明天见',
            time: '10:30',
            unreadCount: 2
          },
          {
            id: 2,
            name: '系统消息',
            avatar: '/assets/system.jpg',
            lastMessage: '您的订单已完成',
            time: '昨天',
            unreadCount: 0
          }
        ]
      });
    } catch (error) {
      console.error('加载消息列表失败:', error);
    }
  },

  goToChat(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/messages/chat?id=${id}`
    });
  },

  onShow() {
    this.loadMessages();
  }
});
