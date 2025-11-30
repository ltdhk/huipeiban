import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';

/// 我的收藏页面
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('我的收藏'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '陪诊师'),
            Tab(text: '机构'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCompanionList(),
          _buildInstitutionList(),
        ],
      ),
    );
  }

  /// 构建陪诊师收藏列表
  Widget _buildCompanionList() {
    // TODO: 接入真实数据
    return _buildEmptyState(
      icon: Icons.person_outline,
      title: '暂无收藏的陪诊师',
      subtitle: '浏览陪诊师列表，收藏您喜欢的陪诊师',
    );
  }

  /// 构建机构收藏列表
  Widget _buildInstitutionList() {
    // TODO: 接入真实数据
    return _buildEmptyState(
      icon: Icons.business_outlined,
      title: '暂无收藏的机构',
      subtitle: '浏览机构列表，收藏您感兴趣的机构',
    );
  }

  /// 构建空状态
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72.w,
            color: AppTheme.textHint,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 构建收藏项卡片（示例）
  Widget _buildFavoriteCard({
    required String name,
    required String description,
    String? avatarUrl,
    required double rating,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // 头像
                CircleAvatar(
                  radius: 28.w,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 28.w,
                          color: AppTheme.primaryColor,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),

                // 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.w,
                            color: AppTheme.warningColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppTheme.warningColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 取消收藏按钮
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: AppTheme.errorColor,
                  ),
                  onPressed: () {
                    // TODO: 取消收藏
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
