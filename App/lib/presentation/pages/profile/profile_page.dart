import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../controllers/auth_controller.dart';

/// 个人中心页面
class ProfilePage extends ConsumerWidget {
  final VoidCallback onMenuTap;

  const ProfilePage({
    super.key,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 渐变色头部
          SliverToBoxAdapter(
            child: _buildHeader(context, user),
          ),

          // 功能菜单
          SliverToBoxAdapter(
            child: _buildMenuSection(context),
          ),

          // 底部留白
          SliverToBoxAdapter(
            child: SizedBox(height: 32.h),
          ),
        ],
      ),
    );
  }

  /// 构建头部区域
  Widget _buildHeader(BuildContext context, dynamic user) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // AppBar 区域
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: onMenuTap,
                    tooltip: '菜单',
                  ),
                  Expanded(
                    child: Text(
                      '个人中心',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white),
                    onPressed: () {
                      // TODO: 跳转到设置页面
                    },
                    tooltip: '设置',
                  ),
                ],
              ),
            ),

            // 用户信息卡片
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
              child: _buildUserInfoCard(context, user),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserInfoCard(BuildContext context, dynamic user) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 33.w,
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
                      size: 36.w,
                      color: AppTheme.primaryColor,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 16.w),

          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user?.nickname ?? '未设置昵称',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 编辑按钮
                    GestureDetector(
                      onTap: () {
                        // TODO: 编辑个人信息
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '编辑',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // 手机号
                if (user?.phone != null && user!.phone!.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 14.w,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _maskPhone(user!.phone!),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 8.h),

                // 用户类型标签
                _buildUserTypeTag(user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建用户类型标签
  Widget _buildUserTypeTag(dynamic user) {
    String label;
    IconData icon;

    if (user?.isCompanion == true) {
      label = '陪诊师';
      icon = Icons.medical_services_outlined;
    } else if (user?.isInstitution == true) {
      label = '机构';
      icon = Icons.business_outlined;
    } else {
      label = '普通用户';
      icon = Icons.person_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.w,
            color: Colors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建功能菜单区域
  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // 第一组菜单
          _buildMenuGroup(
            context,
            items: [
              _MenuItem(
                icon: Icons.people_outline,
                title: '就诊人管理',
                subtitle: '管理您的就诊人信息',
                onTap: () => Navigator.pushNamed(context, '/patients'),
              ),
              _MenuItem(
                icon: Icons.favorite_outline,
                title: '我的收藏',
                subtitle: '查看收藏的陪诊师和机构',
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 第二组菜单
          _buildMenuGroup(
            context,
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                title: '帮助与反馈',
                subtitle: '常见问题和意见反馈',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
              _MenuItem(
                icon: Icons.info_outline,
                title: '关于我们',
                subtitle: '了解${AppConstants.appNameCN}',
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建菜单组
  Widget _buildMenuGroup(BuildContext context, {required List<_MenuItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildMenuItem(context, item),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56.w,
                  endIndent: 16.w,
                  color: AppTheme.dividerColor,
                ),
            ],
          );
        }),
      ),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  item.icon,
                  size: 22.w,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: AppTheme.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 隐藏手机号中间四位
  String _maskPhone(String phone) {
    if (phone.length < 7) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
  }
}

/// 菜单项数据类
class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
