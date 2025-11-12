// MiniApp/pages/institutions/list.js
Page({
  data: {
    searchText: '',
    institutions: [],
    page: 1,
    pageSize: 10,
    loading: false,
    noMore: false
  },

  onLoad() {
    this.loadInstitutions();
  },

  async loadInstitutions(refresh = false) {
    if (this.data.loading || this.data.noMore) return;

    this.setData({ loading: true });

    try {
      // TODO: 调用后端API获取机构列表
      // 模拟数据
      const mockData = [
        {
          id: 1,
          name: '安心陪诊服务中心',
          logo: '/assets/institution1.jpg',
          verified: true,
          description: '专业医疗陪诊服务，多年行业经验，服务质量有保障',
          rating: 4.9,
          serviceCount: 12,
          address: '北京市朝阳区'
        },
        {
          id: 2,
          name: '贴心陪护中心',
          logo: '/assets/institution2.jpg',
          verified: true,
          description: '提供全方位陪诊陪护服务，专业团队',
          rating: 4.7,
          serviceCount: 8,
          address: '北京市海淀区'
        }
      ];

      this.setData({
        institutions: refresh ? mockData : [...this.data.institutions, ...mockData],
        loading: false,
        page: this.data.page + 1
      });

    } catch (error) {
      console.error('加载机构列表失败:', error);
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
    this.searchInstitutions();
  },

  searchInstitutions() {
    // TODO: 实现搜索功能
    console.log('搜索:', this.data.searchText);
  },

  loadMore() {
    this.loadInstitutions();
  },

  goToDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/institutions/detail?id=${id}`
    });
  },

  onPullDownRefresh() {
    this.setData({
      institutions: [],
      page: 1,
      noMore: false
    });
    this.loadInstitutions(true).then(() => {
      wx.stopPullDownRefresh();
    });
  }
});
