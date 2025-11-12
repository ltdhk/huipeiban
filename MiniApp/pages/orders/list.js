// MiniApp/pages/orders/list.js
Page({
  data: {
    currentTab: 0,
    orders: []
  },

  onLoad() {
    this.loadOrders();
  },

  async loadOrders() {
    try {
      // TODO: 调用后端API获取订单列表
      // 模拟数据
      this.setData({
        orders: [
          {
            id: 1,
            orderNo: '202511120001',
            title: '张护士 - 陪诊服务',
            image: '/assets/avatar1.jpg',
            serviceTime: '2025-11-15 09:00',
            price: 200,
            statusText: '待支付',
            statusClass: 'pending',
            showPay: true,
            showCancel: true
          }
        ]
      });
    } catch (error) {
      console.error('加载订单列表失败:', error);
    }
  },

  switchTab(e) {
    const { tab } = e.currentTarget.dataset;
    this.setData({ currentTab: parseInt(tab) });
    this.loadOrders();
  },

  goToDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/orders/detail?id=${id}`
    });
  },

  handlePay(e) {
    const { id } = e.currentTarget.dataset;
    // TODO: 实现支付功能
    wx.showToast({
      title: '跳转支付',
      icon: 'none'
    });
  },

  handleCancel(e) {
    const { id } = e.currentTarget.dataset;
    // TODO: 实现取消订单功能
    wx.showModal({
      title: '确认取消',
      content: '确定要取消这个订单吗?',
      success: (res) => {
        if (res.confirm) {
          console.log('取消订单:', id);
        }
      }
    });
  },

  handleReview(e) {
    const { id } = e.currentTarget.dataset;
    // TODO: 跳转到评价页面
    wx.navigateTo({
      url: `/pages/orders/review?id=${id}`
    });
  }
});
