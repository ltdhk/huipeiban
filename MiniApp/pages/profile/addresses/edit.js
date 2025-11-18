// MiniApp/pages/profile/addresses/edit.js
const { getAddresses, createAddress, updateAddress } = require('../../../utils/api.js');

Page({
  data: {
    addressId: null,
    formData: {
      contact_name: '',
      contact_phone: '',
      province: '',
      city: '',
      district: '',
      detail_address: '',
      address_type: 'home',
      label: '',
      is_default: false
    },
    addressTypes: [
      { label: '家', value: 'home' },
      { label: '公司', value: 'company' },
      { label: '医院', value: 'hospital' },
      { label: '其他', value: 'other' }
    ],
    submitting: false
  },

  onLoad(options) {
    if (options.id) {
      this.setData({ addressId: options.id });
      this.loadAddressDetail(options.id);
    }

    wx.setNavigationBarTitle({
      title: options.id ? '编辑地址' : '添加地址'
    });
  },

  async loadAddressDetail(id) {
    try {
      wx.showLoading({ title: '加载中...' });

      const res = await getAddresses();

      if (res.success && res.data) {
        const address = res.data.list.find(a => a.id === parseInt(id));

        if (address) {
          this.setData({ formData: address });
        }
      }
    } catch (error) {
      console.error('加载地址详情失败:', error);

      wx.showToast({
        title: '加载失败',
        icon: 'none'
      });
    } finally {
      wx.hideLoading();
    }
  },

  onInputChange(e) {
    const { field } = e.currentTarget.dataset;
    const { value } = e.detail;

    this.setData({
      [`formData.${field}`]: value
    });
  },

  onRegionChange(e) {
    const [province, city, district] = e.detail.value;

    this.setData({
      'formData.province': province,
      'formData.city': city,
      'formData.district': district
    });
  },

  onTypeChange(e) {
    const index = e.detail.value;
    this.setData({
      'formData.address_type': this.data.addressTypes[index].value
    });
  },

  onDefaultChange(e) {
    this.setData({
      'formData.is_default': e.detail.value
    });
  },

  validateForm() {
    const { contact_name, contact_phone, province, city, district, detail_address } = this.data.formData;

    if (!contact_name || !contact_name.trim()) {
      wx.showToast({
        title: '请输入联系人',
        icon: 'none'
      });
      return false;
    }

    if (!contact_phone || !/^1[3-9]\d{9}$/.test(contact_phone)) {
      wx.showToast({
        title: '请输入正确的手机号',
        icon: 'none'
      });
      return false;
    }

    if (!province || !city || !district) {
      wx.showToast({
        title: '请选择省市区',
        icon: 'none'
      });
      return false;
    }

    if (!detail_address || !detail_address.trim()) {
      wx.showToast({
        title: '请输入详细地址',
        icon: 'none'
      });
      return false;
    }

    return true;
  },

  async submitForm() {
    if (!this.validateForm()) {
      return;
    }

    if (this.data.submitting) return;

    this.setData({ submitting: true });

    try {
      wx.showLoading({ title: '保存中...' });

      let res;
      if (this.data.addressId) {
        res = await updateAddress(this.data.addressId, this.data.formData);
      } else {
        res = await createAddress(this.data.formData);
      }

      if (res.success) {
        wx.showToast({
          title: '保存成功',
          icon: 'success'
        });

        setTimeout(() => {
          wx.navigateBack();
        }, 1500);
      } else {
        throw new Error(res.message || '保存失败');
      }
    } catch (error) {
      console.error('保存地址失败:', error);

      wx.showToast({
        title: error.message || '保存失败',
        icon: 'none'
      });

      this.setData({ submitting: false });
    } finally {
      wx.hideLoading();
    }
  }
});
