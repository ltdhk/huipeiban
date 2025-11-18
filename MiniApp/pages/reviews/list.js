// MiniApp/pages/reviews/list.js
const { getReviews, deleteReview } = require('../../utils/api.js');

Page({
  data: {
    reviews: [],
    loading: false,
    page: 1,
    hasMore: true
  },

  onLoad() {
    this.loadReviews();
  },

  async loadReviews(refresh = false) {
    if (this.data.loading || (!refresh && !this.data.hasMore)) return;

    this.setData({ loading: true });

    try {
      const page = refresh ? 1 : this.data.page;

      const res = await getReviews({
        page: page,
        page_size: 20
      });

      if (res.success && res.data) {
        const newReviews = res.data.list || [];

        this.setData({
          reviews: refresh ? newReviews : [...this.data.reviews, ...newReviews],
          hasMore: res.data.has_more || false,
          page: page + 1,
          loading: false
        });
      } else {
        throw new Error(res.message || '获取评价列表失败');
      }
    } catch (error) {
      console.error('加载评价列表失败:', error);

      wx.showToast({
        title: error.message || '加载失败',
        icon: 'none'
      });

      this.setData({ loading: false });
    }
  },

  deleteReview(e) {
    const { id } = e.currentTarget.dataset;

    wx.showModal({
      title: '确认删除',
      content: '确定要删除这条评价吗？',
      success: async (res) => {
        if (res.confirm) {
          try {
            wx.showLoading({ title: '删除中...' });

            const result = await deleteReview(id);

            if (result.success) {
              wx.showToast({
                title: '删除成功',
                icon: 'success'
              });

              // 刷新列表
              this.setData({
                page: 1,
                hasMore: true
              });

              this.loadReviews(true);
            } else {
              throw new Error(result.message || '删除失败');
            }
          } catch (error) {
            console.error('删除评价失败:', error);

            wx.showToast({
              title: error.message || '删除失败',
              icon: 'none'
            });
          } finally {
            wx.hideLoading();
          }
        }
      }
    });
  },

  onPullDownRefresh() {
    this.setData({
      page: 1,
      hasMore: true
    });

    this.loadReviews(true);
    wx.stopPullDownRefresh();
  },

  onReachBottom() {
    this.loadReviews();
  }
});
