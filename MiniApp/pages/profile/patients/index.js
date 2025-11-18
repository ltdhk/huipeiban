// MiniApp/pages/profile/patients/index.js
const { getPatients, deletePatient, setDefaultPatient } = require('../../../utils/api.js');

Page({
  data: {
    patients: [],
    loading: false
  },

  onLoad() {
    this.loadPatients();
  },

  /**
   * 加载就诊人列表
   */
  async loadPatients() {
    if (this.data.loading) return;

    this.setData({ loading: true });

    try {
      const res = await getPatients();

      if (res.success && res.data) {
        this.setData({
          patients: res.data.list || [],
          loading: false
        });
      } else {
        throw new Error(res.message || '获取就诊人列表失败');
      }
    } catch (error) {
      console.error('加载就诊人列表失败:', error);

      wx.showToast({
        title: error.message || '加载失败',
        icon: 'none'
      });

      this.setData({ loading: false });
    }
  },

  /**
   * 添加就诊人
   */
  addPatient() {
    wx.navigateTo({
      url: '/pages/profile/patients/edit'
    });
  },

  /**
   * 编辑就诊人
   */
  editPatient(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/profile/patients/edit?id=${id}`
    });
  },

  /**
   * 设置默认就诊人
   */
  async setDefault(e) {
    const { id } = e.currentTarget.dataset;

    try {
      wx.showLoading({ title: '设置中...' });

      const res = await setDefaultPatient(id);

      if (res.success) {
        wx.showToast({
          title: '设置成功',
          icon: 'success'
        });

        // 重新加载列表
        this.loadPatients();
      } else {
        throw new Error(res.message || '设置失败');
      }
    } catch (error) {
      console.error('设置默认就诊人失败:', error);

      wx.showToast({
        title: error.message || '设置失败',
        icon: 'none'
      });
    } finally {
      wx.hideLoading();
    }
  },

  /**
   * 删除就诊人
   */
  deletePatient(e) {
    const { id, name } = e.currentTarget.dataset;

    wx.showModal({
      title: '确认删除',
      content: `确定要删除就诊人"${name}"吗？`,
      success: async (res) => {
        if (res.confirm) {
          try {
            wx.showLoading({ title: '删除中...' });

            const result = await deletePatient(id);

            if (result.success) {
              wx.showToast({
                title: '删除成功',
                icon: 'success'
              });

              // 重新加载列表
              this.loadPatients();
            } else {
              throw new Error(result.message || '删除失败');
            }
          } catch (error) {
            console.error('删除就诊人失败:', error);

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

  /**
   * 页面显示时刷新列表
   */
  onShow() {
    this.loadPatients();
  }
});
