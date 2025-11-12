// MiniApp/pages/companions/list.js
Page({
  data: {
    searchText: '',
    currentFilter: '',
    companions: [],
    page: 1,
    pageSize: 10,
    loading: false,
    noMore: false
  },

  onLoad() {
    this.loadCompanions();
  },

  async loadCompanions(refresh = false) {
    if (this.data.loading || this.data.noMore) return;

    this.setData({ loading: true });

    try {
      // TODO: 调用后端API获取陪诊师列表
      // 模拟数据
      const mockData = [
        {
          id: 1,
          name: '张护士',
          avatar: '/assets/avatar1.jpg',
          verified: true,
          tags: ['三甲医院', '5年经验', '专业认证'],
          introduction: '从事医疗陪诊工作5年，熟悉各大医院流程',
          rating: 4.9,
          orderCount: 128,
          serviceYears: 5,
          price: 200
        },
        {
          id: 2,
          name: '李护士',
          avatar: '/assets/avatar2.jpg',
          verified: true,
          tags: ['耐心细致', '经验丰富'],
          introduction: '专业陪诊服务，细心负责',
          rating: 4.8,
          orderCount: 95,
          serviceYears: 3,
          price: 180
        }
      ];

      this.setData({
        companions: refresh ? mockData : [...this.data.companions, ...mockData],
        loading: false,
        page: this.data.page + 1
      });

    } catch (error) {
      console.error('加载陪诊师列表失败:', error);
      this.setData({ loading: false });
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      });
    }
  },

  onSearchInput(e) {
    this.setData({ searchText: e.detail.value });
    // 实际开发中应该加防抖
    this.searchCompanions();
  },

  searchCompanions() {
    // TODO: 实现搜索功能
    console.log('搜索:', this.data.searchText);
  },

  onFilterChange(e) {
    const { filter } = e.currentTarget.dataset;
    this.setData({
      currentFilter: filter,
      companions: [],
      page: 1,
      noMore: false
    });
    this.loadCompanions(true);
  },

  loadMore() {
    this.loadCompanions();
  },

  goToDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/companions/detail?id=${id}`
    });
  },

  onPullDownRefresh() {
    this.setData({
      companions: [],
      page: 1,
      noMore: false
    });
    this.loadCompanions(true).then(() => {
      wx.stopPullDownRefresh();
    });
  }
});
