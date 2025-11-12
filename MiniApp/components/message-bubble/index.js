Component({
  properties: {
    role: {
      type: String,
      value: 'user' // 'user' | 'assistant'
    },
    content: {
      type: String,
      value: ''
    },
    time: {
      type: String,
      value: ''
    },
    avatar: {
      type: String,
      value: '/assets/default-avatar.png'
    }
  }
});
