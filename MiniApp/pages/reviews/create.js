// MiniApp/pages/reviews/create.js
const { createReview } = require('../../utils/api.js');

Page({
  data: {
    orderId: null,
    formData: {
      rating: 5,
      service_rating: 5,
      attitude_rating: 5,
      professional_rating: 5,
      content: '',
      tags: [],
      images: [],
      is_anonymous: false
    },
    availableTags: [
      '服务热情',
      '专业靠谱',
      '细心周到',
      '准时守信',
      '沟通顺畅',
      '经验丰富',
      '耐心负责'
    ],
    submitting: false
  },

  onLoad(options) {
    if (options.orderId) {
      this.setData({ orderId: options.orderId });
    } else {
      wx.showToast({
        title: '订单信息错误',
        icon: 'none'
      });

      setTimeout(() => {
        wx.navigateBack();
      }, 1500);
    }
  },

  /**
   * 评分变化
   */
  onRatingChange(e) {
    const { field } = e.currentTarget.dataset;
    const { value } = e.detail;

    this.setData({
      [`formData.${field}`]: parseInt(value)
    });
  },

  /**
   * 内容输入
   */
  onContentInput(e) {
    this.setData({
      'formData.content': e.detail.value
    });
  },

  /**
   * 标签选择
   */
  onTagTap(e) {
    const { tag } = e.currentTarget.dataset;
    const { tags } = this.data.formData;

    let newTags;
    if (tags.includes(tag)) {
      // 移除标签
      newTags = tags.filter(t => t !== tag);
    } else {
      // 添加标签
      newTags = [...tags, tag];
    }

    this.setData({
      'formData.tags': newTags
    });
  },

  /**
   * 选择图片
   */
  chooseImage() {
    wx.chooseImage({
      count: 9 - this.data.formData.images.length,
      sizeType: ['compressed'],
      sourceType: ['album', 'camera'],
      success: (res) => {
        // TODO: 上传图片到服务器
        const tempFilePaths = res.tempFilePaths;

        this.setData({
          'formData.images': [...this.data.formData.images, ...tempFilePaths]
        });

        wx.showToast({
          title: '图片已选择',
          icon: 'success'
        });
      }
    });
  },

  /**
   * 删除图片
   */
  deleteImage(e) {
    const { index } = e.currentTarget.dataset;
    const { images } = this.data.formData;

    images.splice(index, 1);

    this.setData({
      'formData.images': images
    });
  },

  /**
   * 预览图片
   */
  previewImage(e) {
    const { url } = e.currentTarget.dataset;

    wx.previewImage({
      current: url,
      urls: this.data.formData.images
    });
  },

  /**
   * 匿名切换
   */
  onAnonymousChange(e) {
    this.setData({
      'formData.is_anonymous': e.detail.value
    });
  },

  /**
   * 提交评价
   */
  async submitReview() {
    const { rating, content } = this.data.formData;

    if (rating < 1 || rating > 5) {
      wx.showToast({
        title: '请选择评分',
        icon: 'none'
      });
      return;
    }

    if (!content || !content.trim()) {
      wx.showToast({
        title: '请填写评价内容',
        icon: 'none'
      });
      return;
    }

    if (this.data.submitting) return;

    this.setData({ submitting: true });

    try {
      wx.showLoading({ title: '提交中...' });

      const res = await createReview({
        order_id: this.data.orderId,
        ...this.data.formData
      });

      if (res.success) {
        wx.showToast({
          title: '评价成功',
          icon: 'success'
        });

        setTimeout(() => {
          wx.navigateBack();
        }, 1500);
      } else {
        throw new Error(res.message || '评价失败');
      }
    } catch (error) {
      console.error('提交评价失败:', error);

      wx.showToast({
        title: error.message || '提交失败',
        icon: 'none'
      });

      this.setData({ submitting: false });
    } finally {
      wx.hideLoading();
    }
  }
});
