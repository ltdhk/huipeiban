Component({
  properties: {
    image: {
      type: String,
      value: ''
    },
    name: {
      type: String,
      value: ''
    },
    tags: {
      type: Array,
      value: []
    },
    rating: {
      type: Number,
      value: 0
    },
    orderCount: {
      type: Number,
      value: 0
    },
    price: {
      type: Number,
      value: 0
    },
    data: {
      type: Object,
      value: {}
    }
  },

  methods: {
    onTap() {
      this.triggerEvent('tap', this.data.data);
    }
  }
});
