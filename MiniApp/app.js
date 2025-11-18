import gulpError from './utils/gulpError';
App({
    globalData: {
        userInfo: null,
        isLoggedIn: false
    },

    onShow() {
        if (gulpError !== 'gulpErrorPlaceHolder') {
            wx.redirectTo({
                url: `/pages/gulp-error/index?gulpError=${gulpError}`,
            });
        }
    },
});
