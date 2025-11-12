Component({
  properties: {
    orderId: {
      type: Number,
      value: 0
    },
    orderNo: {
      type: String,
      value: ''
    },
    image: {
      type: String,
      value: ''
    },
    title: {
      type: String,
      value: ''
    },
    serviceTime: {
      type: String,
      value: ''
    },
    price: {
      type: Number,
      value: 0
    },
    statusText: {
      type: String,
      value: ''
    },
    statusClass: {
      type: String,
      value: 'pending'
    },
    showActions: {
      type: Boolean,
      value: true
    },
    showPay: {
      type: Boolean,
      value: false
    },
    showCancel: {
      type: Boolean,
      value: false
    },
    showReview: {
      type: Boolean,
      value: false
    },
    data: {
      type: Object,
      value: {}
    }
  },

  methods: {
    onTap() {
      this.triggerEvent('tap', this.data.data);
    },

    handlePay(e) {
      e.stopPropagation();
      const { id } = e.currentTarget.dataset;
      this.triggerEvent('pay', { id });
    },

    handleCancel(e) {
      e.stopPropagation();
      const { id } = e.currentTarget.dataset;
      this.triggerEvent('cancel', { id });
    },

    handleReview(e) {
      e.stopPropagation();
      const { id } = e.currentTarget.dataset;
      this.triggerEvent('review', { id });
    }
  }
});
