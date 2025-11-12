// MiniApp/pages/home/home.js
Page({
  data: {
    banners: [
      { id: 1, image: '/assets/banner1.jpg' },
      { id: 2, image: '/assets/banner2.jpg' },
      { id: 3, image: '/assets/banner3.jpg' }
    ],
    companions: [],
    institutions: []
  },

  onLoad() {
    this.loadHomeData();
  },

  async loadHomeData() {
    try {
      // TODO: 调用后端API获取首页数据
      // 模拟数据
      this.setData({
        companions: [
          {
            id: 1,
            name: '张护士',
            avatar: '/assets/avatar1.jpg',
            tags: ['三甲医院', '5年经验'],
            rating: 4.9,
            orderCount: 128
          },
          {
            id: 2,
            name: '李护士',
            avatar: '/assets/avatar2.jpg',
            tags: ['专业陪诊', '耐心细致'],
            rating: 4.8,
            orderCount: 95
          }
        ],
        institutions: [
          {
            id: 1,
            name: '安心陪诊服务中心',
            logo: '/assets/institution1.jpg',
            description: '专业医疗陪诊服务,多年行业经验',
            rating: 4.9,
            serviceCount: 12
          },
          {
            id: 2,
            name: '贴心陪护中心',
            logo: '/assets/institution2.jpg',
            description: '提供全方位陪诊陪护服务',
            rating: 4.7,
            serviceCount: 8
          }
        ]
      });
    } catch (error) {
      console.error('加载首页数据失败:', error);
    }
  },

  goToAIChat() {
    wx.navigateTo({
      url: '/pages/ai-chat/ai-chat'
    });
  },

  goToCompanions() {
    wx.navigateTo({
      url: '/pages/companions/list'
    });
  },

  goToInstitutions() {
    wx.navigateTo({
      url: '/pages/institutions/list'
    });
  },

  goToOrders() {
    wx.switchTab({
      url: '/pages/orders/list'
    });
  },

  goToCompanionDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/companions/detail?id=${id}`
    });
  },

  goToInstitutionDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/institutions/detail?id=${id}`
    });
  },

  onPullDownRefresh() {
    this.loadHomeData().then(() => {
      wx.stopPullDownRefresh();
    });
  }
});
