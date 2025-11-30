import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../controllers/auth_controller.dart';
import 'service_management_page.dart';
import 'schedule_management_page.dart';
import 'order_management_page.dart';

/// 陪诊管理主页面
class CompanionManagementPage extends ConsumerStatefulWidget {
  final VoidCallback onMenuTap;

  const CompanionManagementPage({
    super.key,
    required this.onMenuTap,
  });

  @override
  ConsumerState<CompanionManagementPage> createState() =>
      _CompanionManagementPageState();
}

class _CompanionManagementPageState
    extends ConsumerState<CompanionManagementPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuTap,
        ),
        title: const Text('陪诊管理'),
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 欢迎信息
                _buildWelcomeCard(user),
                SizedBox(height: 16.h),

                // 数据统计卡片
                _buildStatsCards(user),
                SizedBox(height: 24.h),

                // 功能入口卡片
                Text(
                  '功能管理',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildFunctionCards(user),
                SizedBox(height: 24.h),

                // 最近订单
                _buildRecentOrdersSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建欢迎卡片
  Widget _buildWelcomeCard(dynamic user) {
    final isCompanion = user?.isCompanion ?? false;
    final name = isCompanion
        ? (user?.companionInfo?['name'] as String?) ?? '陪诊师'
        : (user?.institutionInfo?['name'] as String?) ?? '机构';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isCompanion ? Icons.person : Icons.business,
              size: 32.w,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好，$name',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isCompanion ? '继续为患者提供优质服务' : '继续管理您的陪诊团队',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建数据统计卡片
  Widget _buildStatsCards(dynamic user) {
    final isCompanion = user?.isCompanion == true;
    final info = isCompanion ? user?.companionInfo : user?.institutionInfo;

    final totalOrders = info?['total_orders'] ?? 0;
    final completedOrders = info?['completed_orders'] ?? 0;
    final rating = info?['rating'] ?? 5.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.assignment,
            label: '总订单',
            value: '$totalOrders',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            label: '已完成',
            value: '$completedOrders',
            color: Colors.green,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            label: '评分',
            value: rating.toStringAsFixed(1),
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  /// 构建单个统计卡片
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28.w, color: color),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建功能入口卡片
  Widget _buildFunctionCards(dynamic user) {
    return Column(
      children: [
        _buildFunctionCard(
          icon: Icons.medical_services,
          title: '服务管理',
          subtitle: '管理服务项目、价格和规格',
          color: AppTheme.primaryColor,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ServiceManagementPage(),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        _buildFunctionCard(
          icon: Icons.schedule,
          title: '时间管理',
          subtitle: '设置可接单时间和休息时间',
          color: Colors.blue,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ScheduleManagementPage(),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        _buildFunctionCard(
          icon: Icons.list_alt,
          title: '订单管理',
          subtitle: '查看和管理所有订单',
          color: Colors.green,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OrderManagementPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 构建单个功能卡片
  Widget _buildFunctionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 28.w,
                  color: color,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建最近订单部分
  Widget _buildRecentOrdersSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近订单',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OrderManagementPage(),
                    ),
                  );
                },
                child: Text(
                  '查看全部',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // TODO: 这里应该从API获取最近订单数据
          _buildEmptyOrdersPlaceholder(),
        ],
      ),
    );
  }

  /// 构建空订单占位符
  Widget _buildEmptyOrdersPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64.w,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无最近订单',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '订单数据将在这里显示',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理刷新
  Future<void> _handleRefresh() async {
    // TODO: 刷新数据
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('数据已刷新')),
      );
    }
  }
}
