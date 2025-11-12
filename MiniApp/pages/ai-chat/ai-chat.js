// MiniApp/pages/ai-chat/ai-chat.js
Page({
  data: {
    messages: [
      {
        role: 'assistant',
        content: '您好！我是AI智能陪诊助手，我可以帮您：\n1. 推荐合适的陪诊师\n2. 推荐陪诊机构\n3. 解答陪诊相关问题\n\n请问有什么可以帮助您的？'
      }
    ],
    inputText: '',
    scrollIntoView: 'bottom',
    loading: false
  },

  onLoad(options) {
    // 页面加载时的初始化
    console.log('AI聊天页面加载');
  },

  onInput(e) {
    this.setData({
      inputText: e.detail.value
    });
  },

  async sendMessage() {
    const { inputText, messages } = this.data;

    if (!inputText.trim()) {
      wx.showToast({
        title: '请输入消息',
        icon: 'none'
      });
      return;
    }

    // 添加用户消息到列表
    const userMessage = {
      role: 'user',
      content: inputText
    };

    this.setData({
      messages: [...messages, userMessage],
      inputText: '',
      loading: true,
      scrollIntoView: 'bottom'
    });

    try {
      // TODO: 调用后端AI接口
      // const res = await wx.request({
      //   url: 'YOUR_API_URL/ai/chat',
      //   method: 'POST',
      //   data: {
      //     message: inputText,
      //     history: messages
      //   }
      // });

      // 模拟AI回复（实际开发时替换为真实API调用）
      setTimeout(() => {
        const assistantMessage = {
          role: 'assistant',
          content: '感谢您的咨询！这是一个模拟回复。实际使用时会连接到后端AI服务。'
        };

        this.setData({
          messages: [...this.data.messages, assistantMessage],
          loading: false,
          scrollIntoView: 'bottom'
        });
      }, 1000);

    } catch (error) {
      console.error('发送消息失败:', error);
      wx.showToast({
        title: '发送失败，请重试',
        icon: 'none'
      });
      this.setData({
        loading: false
      });
    }
  },

  onShow() {
    // 页面显示时滚动到底部
    this.setData({
      scrollIntoView: 'bottom'
    });
  }
});
