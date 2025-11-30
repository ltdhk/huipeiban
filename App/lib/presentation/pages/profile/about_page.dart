import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';

/// 关于我们页面
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('关于我们'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Logo 和应用信息
          _buildAppInfo(),

          SizedBox(height: 24.h),

          // 应用介绍
          _buildSection(
            title: '应用介绍',
            content: '${AppConstants.appNameCN}是一款专业的医疗陪诊服务平台，'
                '致力于为患者和家属提供贴心、专业的陪诊服务。\n\n'
                '我们整合优质陪诊师和医疗机构资源，'
                '通过智能匹配和便捷预约，让就医更加轻松、高效。',
          ),

          SizedBox(height: 16.h),

          // 核心功能
          _buildFeatures(),

          SizedBox(height: 16.h),

          // 联系方式
          _buildContactInfo(),

          SizedBox(height: 16.h),

          // 版本信息
          _buildVersionInfo(),

          SizedBox(height: 24.h),

          // 协议链接
          _buildAgreementLinks(context),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  /// 构建应用信息
  Widget _buildAppInfo() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.medical_services_rounded,
              size: 48.w,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),

          // 应用名称
          Text(
            AppConstants.appNameCN,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),

          // 标语
          Text(
            '智能陪诊，贴心服务',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 12.h),

          // 版本号
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分区
  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建核心功能
  Widget _buildFeatures() {
    final features = [
      _Feature(Icons.person_search, '专业陪诊', '认证陪诊师，专业服务'),
      _Feature(Icons.schedule, '便捷预约', '在线预约，省时省心'),
      _Feature(Icons.chat_bubble_outline, 'AI 助手', '智能咨询，随时解答'),
      _Feature(Icons.security, '安全保障', '信息加密，隐私保护'),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '核心功能',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 2.2,
            children: features.map((f) => _buildFeatureItem(f)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(_Feature feature) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            feature.icon,
            size: 24.w,
            color: AppTheme.primaryColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  feature.subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textHint,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建联系方式
  Widget _buildContactInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '联系我们',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildContactRow(Icons.email_outlined, 'support@carelink.com'),
          SizedBox(height: 8.h),
          _buildContactRow(Icons.phone_outlined, '400-123-4567'),
          SizedBox(height: 8.h),
          _buildContactRow(Icons.language_outlined, 'www.carelink.com'),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.w,
          color: AppTheme.primaryColor,
        ),
        SizedBox(width: 12.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  /// 构建版本信息
  Widget _buildVersionInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '版本信息',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('当前版本', AppConstants.appVersion),
          SizedBox(height: 8.h),
          _buildInfoRow('构建日期', '2024-01-01'),
          SizedBox(height: 8.h),
          _buildInfoRow('开发者', 'CareLink Team'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 构建协议链接
  Widget _buildAgreementLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // TODO: 跳转用户协议
          },
          child: Text(
            '用户协议',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Text(
          '|',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textHint,
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: 跳转隐私政策
          },
          child: Text(
            '隐私政策',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// 功能数据类
class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;

  _Feature(this.icon, this.title, this.subtitle);
}
