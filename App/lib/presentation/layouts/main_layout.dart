import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../pages/home/home_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/messages/messages_page.dart';
import '../pages/profile/profile_page.dart';

/// 主布局 - 带侧边栏导航
class MainLayout extends ConsumerStatefulWidget {
  final Map<String, dynamic>? arguments;

  const MainLayout({
    super.key,
    this.arguments,
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSidebarOpen = false; // 侧边栏默认关闭
  late AnimationController _animationController;
  late Animation<double> _animation;

  // 获取页面（传入 toggleSidebar 回调）
  List<Widget> _getPages() => [
    HomePage(
      onMenuTap: _toggleSidebar,
    ),
    OrdersPage(onMenuTap: _toggleSidebar),    // 订单
    MessagesPage(onMenuTap: _toggleSidebar),  // 消息
    ProfilePage(onMenuTap: _toggleSidebar),   // 个人中心
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 切换侧边栏
  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      body: Stack(
        children: [
          // 主内容区
          _getPages()[_selectedIndex],

          // 遮罩层（当侧边栏打开时）- 只覆盖侧边栏右侧区域
          if (_isSidebarOpen)
            Positioned(
              left: 280.w, // 从侧边栏右边缘开始
              top: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _isSidebarOpen ? 0.5 : 0.0,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          // 侧边栏（从左侧滑入）- 放在遮罩层之上
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-280.w * (1 - _animation.value), 0),
                child: child,
              );
            },
            child: _buildSidebar(user),
          ),
        ],
      ),
    );
  }

  /// 构建侧边栏
  Widget _buildSidebar(dynamic user) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24.h),

            // Logo 和标题
            _buildHeader(),

            SizedBox(height: 32.h),

            // 用户信息
            _buildUserInfo(user),

            SizedBox(height: 32.h),

            // 导航菜单
            Expanded(
              child: _buildNavMenu(),
            ),

            // 底部退出按钮
            _buildLogoutButton(),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  /// 构建头部 Logo
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.medical_services_rounded,
          size: 48.w,
          color: Colors.white,
        ),
        SizedBox(height: 12.h),
        Text(
          AppConstants.appNameCN,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '智能陪诊，贴心服务',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  /// 构建用户信息
  Widget _buildUserInfo(dynamic user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 24.w,
            backgroundColor: Colors.white,
            backgroundImage: user?.avatarUrl != null &&
                    (user!.avatarUrl!.startsWith('http://') ||
                        user!.avatarUrl!.startsWith('https://'))
                ? NetworkImage(user!.avatarUrl!)
                : null,
            child: user?.avatarUrl == null ||
                    !(user!.avatarUrl!.startsWith('http://') ||
                        user!.avatarUrl!.startsWith('https://'))
                ? Icon(
                    Icons.person,
                    size: 24.w,
                    color: AppTheme.primaryColor,
                  )
                : null,
          ),
          SizedBox(width: 12.w),

          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.nickname ?? '未命名用户',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  user?.phone ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建导航菜单
  Widget _buildNavMenu() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        _buildNavItem(
          icon: Icons.chat_bubble_outline,
          label: 'AI 助手',
          index: 0,
        ),
        SizedBox(height: 8.h),
        _buildNavItem(
          icon: Icons.assignment_outlined,
          label: '我的订单',
          index: 1,
        ),
        SizedBox(height: 8.h),
        _buildNavItem(
          icon: Icons.message_outlined,
          label: '消息',
          index: 2,
        ),
        SizedBox(height: 8.h),
        _buildNavItem(
          icon: Icons.person_outline,
          label: '个人中心',
          index: 3,
        ),
      ],
    );
  }

  /// 构建导航项
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            // 切换页面时自动关闭侧边栏
            if (_isSidebarOpen) {
              _toggleSidebar();
            }
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24.w,
                color: Colors.white,
              ),
              SizedBox(width: 16.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建退出按钮
  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleLogout,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  size: 20.w,
                  color: Colors.white,
                ),
                SizedBox(width: 12.w),
                Text(
                  '退出登录',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 处理退出登录
  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}
