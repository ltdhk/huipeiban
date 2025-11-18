// MiniApp/pages/profile/patients/edit.js
const { getPatients, createPatient, updatePatient } = require('../../../utils/api.js');

Page({
  data: {
    patientId: null,
    formData: {
      name: '',
      gender: 'male',
      birth_date: '',
      phone: '',
      relationship: 'self',
      medical_history: '',
      allergies: '',
      special_needs: '',
      is_default: false
    },
    genderOptions: [
      { label: '男', value: 'male' },
      { label: '女', value: 'female' }
    ],
    relationshipOptions: [
      { label: '本人', value: 'self' },
      { label: '父母', value: 'parent' },
      { label: '配偶', value: 'spouse' },
      { label: '子女', value: 'child' },
      { label: '其他', value: 'other' }
    ],
    submitting: false
  },

  onLoad(options) {
    if (options.id) {
      this.setData({ patientId: options.id });
      this.loadPatientDetail(options.id);
    }

    // 设置导航标题
    wx.setNavigationBarTitle({
      title: options.id ? '编辑就诊人' : '添加就诊人'
    });
  },

  /**
   * 加载就诊人详情
   */
  async loadPatientDetail(id) {
    try {
      wx.showLoading({ title: '加载中...' });

      const res = await getPatients();

      if (res.success && res.data) {
        const patient = res.data.list.find(p => p.id === parseInt(id));

        if (patient) {
          this.setData({
            formData: {
              name: patient.name || '',
              gender: patient.gender || 'male',
              birth_date: patient.birth_date || '',
              phone: patient.phone || '',
              relationship: patient.relationship || 'self',
              medical_history: patient.medical_history || '',
              allergies: patient.allergies || '',
              special_needs: patient.special_needs || '',
              is_default: patient.is_default || false
            }
          });
        }
      }
    } catch (error) {
      console.error('加载就诊人详情失败:', error);

      wx.showToast({
        title: '加载失败',
        icon: 'none'
      });
    } finally {
      wx.hideLoading();
    }
  },

  /**
   * 表单输入处理
   */
  onInputChange(e) {
    const { field } = e.currentTarget.dataset;
    const { value } = e.detail;

    this.setData({
      [`formData.${field}`]: value
    });
  },

  /**
   * 日期选择
   */
  onDateChange(e) {
    this.setData({
      'formData.birth_date': e.detail.value
    });
  },

  /**
   * 性别选择
   */
  onGenderChange(e) {
    const index = e.detail.value;
    this.setData({
      'formData.gender': this.data.genderOptions[index].value
    });
  },

  /**
   * 关系选择
   */
  onRelationshipChange(e) {
    const index = e.detail.value;
    this.setData({
      'formData.relationship': this.data.relationshipOptions[index].value
    });
  },

  /**
   * 默认状态切换
   */
  onDefaultChange(e) {
    this.setData({
      'formData.is_default': e.detail.value
    });
  },

  /**
   * 表单验证
   */
  validateForm() {
    const { name, gender, phone } = this.data.formData;

    if (!name || !name.trim()) {
      wx.showToast({
        title: '请输入姓名',
        icon: 'none'
      });
      return false;
    }

    if (!gender) {
      wx.showToast({
        title: '请选择性别',
        icon: 'none'
      });
      return false;
    }

    // 手机号验证（可选）
    if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
      wx.showToast({
        title: '请输入正确的手机号',
        icon: 'none'
      });
      return false;
    }

    return true;
  },

  /**
   * 提交表单
   */
  async submitForm() {
    if (!this.validateForm()) {
      return;
    }

    if (this.data.submitting) return;

    this.setData({ submitting: true });

    try {
      wx.showLoading({ title: '保存中...' });

      let res;
      if (this.data.patientId) {
        // 更新
        res = await updatePatient(this.data.patientId, this.data.formData);
      } else {
        // 创建
        res = await createPatient(this.data.formData);
      }

      if (res.success) {
        wx.showToast({
          title: '保存成功',
          icon: 'success'
        });

        // 延迟返回
        setTimeout(() => {
          wx.navigateBack();
        }, 1500);
      } else {
        throw new Error(res.message || '保存失败');
      }
    } catch (error) {
      console.error('保存就诊人失败:', error);

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
