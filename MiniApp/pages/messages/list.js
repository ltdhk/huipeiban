// MiniApp/pages/messages/list.js
const { getConversations } = require('../../utils/api.js');

Page({
  data: {
    conversations: [],
    loading: false,
    page: 1,
    hasMore: true
  },

  onLoad() {
    this.loadConversations();
  },

  /**
   * 加载会话列表
   */
  async loadConversations(refresh = false) {
    if (this.data.loading || (!refresh && !this.data.hasMore)) return;

    this.setData({ loading: true });

    try {
      const page = refresh ? 1 : this.data.page;

      const res = await getConversations({
        page: page,
        page_size: 20
      });

      if (res.success && res.data) {
        const newConversations = res.data.list || [];

        this.setData({
          conversations: refresh ? newConversations : [...this.data.conversations, ...newConversations],
          hasMore: res.data.has_more || false,
          page: page + 1,
          loading: false
        });
      } else {
        throw new Error(res.message || '获取会话列表失败');
      }
    } catch (error) {
      console.error('加载会话列表失败:', error);

      wx.showToast({
        title: error.message || '加载失败',
        icon: 'none'
      });

      this.setData({ loading: false });
    }
  },

  /**
   * 进入聊天页面
   */
  goToChat(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/messages/chat?conversationId=${id}`
    });
  },

  /**
   * 下拉刷新
   */
  onPullDownRefresh() {
    this.setData({
      page: 1,
      hasMore: true
    });

    this.loadConversations(true);

    wx.stopPullDownRefresh();
  },

  /**
   * 上拉加载更多
   */
  onReachBottom() {
    this.loadConversations();
  },

  /**
   * 页面显示时刷新
   */
  onShow() {
    this.setData({
      page: 1,
      hasMore: true
    });

    this.loadConversations(true);
  }
});
