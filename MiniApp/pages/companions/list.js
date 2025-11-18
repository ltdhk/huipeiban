// MiniApp/pages/companions/list.js
const { getCompanions } = require('../../utils/api.js');

Page({
  data: {
    searchText: '',
    currentFilter: '',
    companions: [],
    page: 1,
    pageSize: 20,
    loading: false,
    noMore: false,
    // 筛选参数
    gender: '',
    has_car: '',
    min_rating: '',
    sort_by: 'rating',
    order: 'desc'
  },

  onLoad(options) {
    // 从参数中获取筛选条件（如果从其他页面跳转过来）
    if (options.city) {
      this.setData({ city: options.city });
    }
    if (options.min_rating) {
      this.setData({ min_rating: parseFloat(options.min_rating) });
    }

    this.loadCompanions(true);
  },

  async loadCompanions(refresh = false) {
    if (this.data.loading) return;
    if (!refresh && this.data.noMore) return;

    this.setData({ loading: true });

    try {
      // 构建查询参数
      const params = {
        page: refresh ? 1 : this.data.page,
        page_size: this.data.pageSize,
        sort_by: this.data.sort_by,
        order: this.data.order
      };

      // 添加筛选条件
      if (this.data.searchText) {
        params.keyword = this.data.searchText;
      }
      if (this.data.gender) {
        params.gender = this.data.gender;
      }
      if (this.data.has_car) {
        params.has_car = this.data.has_car;
      }
      if (this.data.min_rating) {
        params.min_rating = this.data.min_rating;
      }
      if (this.data.city) {
        params.city = this.data.city;
      }

      // 根据筛选标签设置参数
      if (this.data.currentFilter === 'high-rating') {
        params.min_rating = 4.5;
        params.sort_by = 'rating';
      } else if (this.data.currentFilter === 'experienced') {
        params.sort_by = 'orders';
      } else if (this.data.currentFilter === 'has-car') {
        params.has_car = 'true';
      }

      // 调用API
      const res = await getCompanions(params);

      if (res.success && res.data) {
        const newCompanions = res.data.list || [];

        // 处理数据，确保字段匹配
        const processedCompanions = newCompanions.map(item => ({
          id: item.id,
          name: item.name,
          avatar: item.avatar_url || '/assets/default-avatar.png',
          verified: item.is_verified,
          tags: this.generateTags(item),
          introduction: item.introduction || '专业陪诊服务',
          rating: item.rating,
          orderCount: item.completed_orders,
          serviceYears: item.service_years || 0,
          price: item.hourly_rate || 0,
          has_car: item.has_car,
          is_online: item.is_online
        }));

        this.setData({
          companions: refresh ? processedCompanions : [...this.data.companions, ...processedCompanions],
          page: refresh ? 2 : this.data.page + 1,
          loading: false,
          noMore: newCompanions.length < this.data.pageSize
        });
      } else {
        throw new Error(res.message || '加载失败');
      }

    } catch (error) {
      console.error('加载陪诊师列表失败:', error);
      this.setData({ loading: false });
      wx.showToast({
        title: error.message || '加载失败',
        icon: 'none'
      });
    }
  },

  /**
   * 生成标签
   */
  generateTags(companion) {
    const tags = [];

    // 评分标签
    if (companion.rating >= 4.8) {
      tags.push('⭐ 高评分');
    }

    // 经验标签
    if (companion.service_years >= 5) {
      tags.push(`${companion.service_years}年经验`);
    }

    // 订单量标签
    if (companion.completed_orders >= 100) {
      tags.push('经验丰富');
    }

    // 有车标签
    if (companion.has_car) {
      tags.push('🚗 提供接送');
    }

    // 在线标签
    if (companion.is_online) {
      tags.push('🟢 在线');
    }

    // 认证标签
    if (companion.is_verified) {
      tags.push('✓ 已认证');
    }

    return tags.slice(0, 3); // 最多显示3个标签
  },

  /**
   * 搜索输入
   */
  onSearchInput(e) {
    this.setData({ searchText: e.detail.value });
  },

  /**
   * 执行搜索（防抖）
   */
  searchCompanions() {
    // 清除之前的定时器
    if (this.searchTimer) {
      clearTimeout(this.searchTimer);
    }

    // 设置新的定时器（500ms防抖）
    this.searchTimer = setTimeout(() => {
      this.setData({
        companions: [],
        page: 1,
        noMore: false
      });
      this.loadCompanions(true);
    }, 500);
  },

  /**
   * 搜索确认
   */
  onSearchConfirm() {
    if (this.searchTimer) {
      clearTimeout(this.searchTimer);
    }
    this.setData({
      companions: [],
      page: 1,
      noMore: false
    });
    this.loadCompanions(true);
  },

  /**
   * 筛选标签切换
   */
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

  /**
   * 加载更多
   */
  loadMore() {
    this.loadCompanions(false);
  },

  /**
   * 跳转到详情页
   */
  goToDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/companions/detail?id=${id}`
    });
  },

  /**
   * 下拉刷新
   */
  onPullDownRefresh() {
    this.setData({
      companions: [],
      page: 1,
      noMore: false
    });
    this.loadCompanions(true).then(() => {
      wx.stopPullDownRefresh();
    });
  },

  /**
   * 显示筛选器
   */
  showFilterModal() {
    // TODO: 实现高级筛选弹窗
    wx.showToast({
      title: '筛选功能开发中',
      icon: 'none'
    });
  }
});
