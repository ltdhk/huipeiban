// MiniApp/pages/messages/chat.js
const { getConversationMessages, sendMessage } = require('../../utils/api.js');

Page({
  data: {
    conversationId: null,
    messages: [],
    inputText: '',
    scrollIntoView: 'bottom',
    loading: false,
    sending: false,
    page: 1,
    hasMore: true
  },

  onLoad(options) {
    if (options.conversationId) {
      this.setData({ conversationId: options.conversationId });
      this.loadMessages();
    } else {
      wx.showToast({
        title: '会话不存在',
        icon: 'none'
      });

      setTimeout(() => {
        wx.navigateBack();
      }, 1500);
    }
  },

  /**
   * 加载消息列表
   */
  async loadMessages(loadMore = false) {
    if (this.data.loading || (!loadMore && !this.data.hasMore)) return;

    this.setData({ loading: true });

    try {
      const res = await getConversationMessages(this.data.conversationId, {
        page: this.data.page,
        page_size: 20
      });

      if (res.success && res.data) {
        const newMessages = res.data.list || [];

        this.setData({
          messages: loadMore ? [...newMessages, ...this.data.messages] : [...this.data.messages, ...newMessages],
          hasMore: res.data.has_more || false,
          page: this.data.page + 1,
          loading: false
        });

        // 滚动到底部
        if (!loadMore) {
          setTimeout(() => {
            this.setData({ scrollIntoView: 'bottom' });
          }, 100);
        }
      } else {
        throw new Error(res.message || '获取消息失败');
      }
    } catch (error) {
      console.error('加载消息失败:', error);

      wx.showToast({
        title: error.message || '加载失败',
        icon: 'none'
      });

      this.setData({ loading: false });
    }
  },

  /**
   * 输入框内容变化
   */
  onInput(e) {
    this.setData({
      inputText: e.detail.value
    });
  },

  /**
   * 发送消息
   */
  async sendMessage() {
    const { inputText, conversationId, sending } = this.data;

    if (!inputText.trim()) {
      wx.showToast({
        title: '请输入消息',
        icon: 'none'
      });
      return;
    }

    if (sending) return;

    this.setData({ sending: true });

    try {
      // 添加临时消息到列表
      const tempMessage = {
        id: Date.now(),
        content: inputText.trim(),
        sender_type: 'user',
        created_at: new Date().toISOString(),
        is_read: true
      };

      this.setData({
        messages: [...this.data.messages, tempMessage],
        inputText: '',
        sending: false
      });

      // 滚动到底部
      setTimeout(() => {
        this.setData({ scrollIntoView: 'bottom' });
      }, 100);

      // 调用 API 发送消息
      const res = await sendMessage(conversationId, {
        content: inputText.trim()
      });

      if (res.success) {
        // 重新加载消息列表以获取服务器返回的完整消息
        this.setData({
          page: 1,
          hasMore: true,
          messages: []
        });

        this.loadMessages();
      } else {
        throw new Error(res.message || '发送失败');
      }
    } catch (error) {
      console.error('发送消息失败:', error);

      wx.showToast({
        title: error.message || '发送失败',
        icon: 'none'
      });

      this.setData({ sending: false });
    }
  },

  /**
   * 下拉加载更多历史消息
   */
  onPullDownRefresh() {
    this.loadMessages(true);
    wx.stopPullDownRefresh();
  },

  onShow() {
    // 页面显示时滚动到底部
    setTimeout(() => {
      this.setData({ scrollIntoView: 'bottom' });
    }, 100);
  }
});