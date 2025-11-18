// MiniApp/pages/profile/addresses/index.js
const { getAddresses, deleteAddress, setDefaultAddress } = require('../../../utils/api.js');

Page({
  data: {
    addresses: [],
    loading: false
  },

  onLoad() {
    this.loadAddresses();
  },

  async loadAddresses() {
    if (this.data.loading) return;

    this.setData({ loading: true });

    try {
      const res = await getAddresses();

      if (res.success && res.data) {
        this.setData({
          addresses: res.data.list || [],
          loading: false
        });
      } else {
        throw new Error(res.message || '获取地址列表失败');
      }
    } catch (error) {
      console.error('加载地址列表失败:', error);

      wx.showToast({
        title: error.message || '加载失败',
        icon: 'none'
      });

      this.setData({ loading: false });
    }
  },

  addAddress() {
    wx.navigateTo({
      url: '/pages/profile/addresses/edit'
    });
  },

  editAddress(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/profile/addresses/edit?id=${id}`
    });
  },

  async setDefault(e) {
    const { id } = e.currentTarget.dataset;

    try {
      wx.showLoading({ title: '设置中...' });

      const res = await setDefaultAddress(id);

      if (res.success) {
        wx.showToast({
          title: '设置成功',
          icon: 'success'
        });

        this.loadAddresses();
      } else {
        throw new Error(res.message || '设置失败');
      }
    } catch (error) {
      console.error('设置默认地址失败:', error);

      wx.showToast({
        title: error.message || '设置失败',
        icon: 'none'
      });
    } finally {
      wx.hideLoading();
    }
  },

  deleteAddress(e) {
    const { id, name } = e.currentTarget.dataset;

    wx.showModal({
      title: '确认删除',
      content: `确定要删除地址"${name}"吗？`,
      success: async (res) => {
        if (res.confirm) {
          try {
            wx.showLoading({ title: '删除中...' });

            const result = await deleteAddress(id);

            if (result.success) {
              wx.showToast({
                title: '删除成功',
                icon: 'success'
              });

              this.loadAddresses();
            } else {
              throw new Error(result.message || '删除失败');
            }
          } catch (error) {
            console.error('删除地址失败:', error);

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

  onShow() {
    this.loadAddresses();
  }
});
