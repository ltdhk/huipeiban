import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/service.dart';
import '../../../data/repositories/service_repository.dart';
import 'add_service_page.dart';

/// 陪诊服务管理页面
class ServiceManagementPage extends ConsumerStatefulWidget {
  const ServiceManagementPage({super.key});

  @override
  ConsumerState<ServiceManagementPage> createState() =>
      _ServiceManagementPageState();
}

class _ServiceManagementPageState extends ConsumerState<ServiceManagementPage> {
  final _serviceRepository = ServiceRepository();
  List<Service> _services = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  /// 加载服务列表
  Future<void> _loadServices() async {
    setState(() => _isLoading = true);

    try {
      final result = await _serviceRepository.getServices(
        page: _currentPage,
        pageSize: 20,
      );

      setState(() {
        _services = result['list'] as List<Service>;
        _totalCount = result['total'] as int;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('服务管理'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleAddService,
            tooltip: '添加服务',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
              ? _buildEmptyState()
              : _buildServiceList(),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80.w,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 24.h),
          Text(
            '暂无服务项目',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '点击右上角 + 添加服务项目',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: _handleAddService,
            icon: const Icon(Icons.add),
            label: const Text('添加服务'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建服务列表
  Widget _buildServiceList() {
    return RefreshIndicator(
      onRefresh: _loadServices,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(_services[index]);
        },
      ),
    );
  }

  /// 构建服务卡片
  Widget _buildServiceCard(Service service) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 服务头部
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (service.category != null) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            service.category!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // 上架/下架状态
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: service.isActive
                        ? AppTheme.successColor.withValues(alpha: 0.1)
                        : AppTheme.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    service.isActive ? '已上架' : '已下架',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: service.isActive
                          ? AppTheme.successColor
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 服务内容
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (service.description != null) ...[
                  Text(
                    service.description!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                ],

                // 价格信息
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 20.w,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '基础价格：',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '¥${service.basePrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                if (service.additionalHourPrice != null &&
                    service.additionalHourPrice! > 0) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 20.w,
                        color: AppTheme.textSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '超时加价：¥${service.additionalHourPrice!.toStringAsFixed(0)}/小时',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 12.h),

                // 统计信息
                Row(
                  children: [
                    _buildStatItem(
                      icon: Icons.visibility_outlined,
                      label: '浏览',
                      value: '${service.viewCount}',
                    ),
                    SizedBox(width: 24.w),
                    _buildStatItem(
                      icon: Icons.shopping_cart_outlined,
                      label: '销量',
                      value: '${service.salesCount}',
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // 操作按钮
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleEditService(service),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('编辑'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleToggleServiceStatus(service),
                        icon: Icon(
                          service.isActive
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        label: Text(service.isActive ? '下架' : '上架'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: service.isActive
                              ? AppTheme.textSecondary
                              : AppTheme.successColor,
                          side: BorderSide(
                            color: service.isActive
                                ? AppTheme.textSecondary
                                : AppTheme.successColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    IconButton(
                      onPressed: () => _handleDeleteService(service),
                      icon: const Icon(Icons.delete_outline),
                      color: AppTheme.errorColor,
                      tooltip: '删除',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppTheme.textSecondary),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  /// 添加服务
  Future<void> _handleAddService() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddServicePage(),
      ),
    );

    if (result != null && result is Service) {
      try {
        // 将Service对象转换为API格式并创建
        final serviceData = ServiceRepository.serviceToJson(result);
        await _serviceRepository.createService(serviceData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('创建成功')),
          );
        }

        // 重新加载列表
        await _loadServices();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('创建失败: $e')),
          );
        }
      }
    }
  }

  /// 编辑服务
  Future<void> _handleEditService(Service service) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddServicePage(service: service),
      ),
    );

    if (result != null && result is Service) {
      try {
        // 将Service对象转换为API格式并更新
        final serviceData = ServiceRepository.serviceToJson(result);
        await _serviceRepository.updateService(service.id, serviceData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('更新成功')),
          );
        }

        // 重新加载列表
        await _loadServices();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('更新失败: $e')),
          );
        }
      }
    }
  }

  /// 切换服务上架状态
  Future<void> _handleToggleServiceStatus(Service service) async {
    final action = service.isActive ? '下架' : '上架';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认$action'),
        content: Text('确定要$action服务"${service.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // 调用 API 切换服务状态
        await _serviceRepository.toggleService(service.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$action成功')),
          );
        }

        // 重新加载列表
        await _loadServices();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$action失败: $e')),
          );
        }
      }
    }
  }

  /// 删除服务
  Future<void> _handleDeleteService(Service service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除服务"${service.title}"吗？\n此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // 调用 API 删除服务
        await _serviceRepository.deleteService(service.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('删除成功')),
          );
        }

        // 重新加载列表
        await _loadServices();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除失败: $e')),
          );
        }
      }
    }
  }
}
