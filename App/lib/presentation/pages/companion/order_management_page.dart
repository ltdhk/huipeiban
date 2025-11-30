import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/order.dart';
import '../../../data/models/patient.dart';
import '../../../data/repositories/companion_order_repository.dart';
import 'companion_order_detail_page.dart';

/// 陪诊订单管理页面
class OrderManagementPage extends ConsumerStatefulWidget {
  const OrderManagementPage({super.key});

  @override
  ConsumerState<OrderManagementPage> createState() =>
      _OrderManagementPageState();
}

class _OrderManagementPageState extends ConsumerState<OrderManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CompanionOrderRepository _repository = CompanionOrderRepository();

  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _tabs = ['全部', '待接单', '待服务', '服务中', '已完成', '已取消'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 加载订单列表
  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.getOrders(
        page: 1,
        pageSize: 100,
      );

      final List<dynamic> orderList = result['list'] ?? [];
      final orders = orderList.map((json) {
        // 解析患者信息
        Patient? patient;
        if (json['patient'] != null) {
          patient = Patient(
            id: json['patient']['id'] ?? 0,
            userId: 0,
            name: json['patient']['name'] ?? '',
            gender: json['patient']['gender'] ?? 'unknown',
            phone: json['patient']['phone'],
            relationship: 'self',
          );
        }

        return Order(
          id: json['id'] ?? 0,
          orderNo: json['order_no'] ?? '',
          userId: json['user_id'] ?? 0,
          patientId: json['patient_id'],
          orderType: json['order_type'] ?? 'companion',
          companionId: json['companion_id'],
          institutionId: json['institution_id'],
          hospitalName: json['hospital_name'] ?? '',
          hospitalAddress: json['hospital_address'],
          department: json['department'],
          appointmentDate: json['appointment_date'] != null
              ? DateTime.parse(json['appointment_date'])
              : null,
          appointmentTime: json['appointment_time'] ?? '',
          needPickup: json['need_pickup'] ?? false,
          servicePrice: (json['service_price'] ?? 0.0).toDouble(),
          pickupPrice: (json['pickup_price'] ?? 0.0).toDouble(),
          totalPrice: (json['total_price'] ?? 0.0).toDouble(),
          status: json['status'] ?? 'pending_accept',
          createdAt: json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
          updatedAt: json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
          patient: patient,
        );
      }).toList();

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('订单管理'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
          labelStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: _tabs.map((tab) => _buildOrderList(tab)).toList(),
                ),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.w,
            color: AppTheme.errorColor,
          ),
          SizedBox(height: 16.h),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              _errorMessage ?? '未知错误',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadOrders,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 构建订单列表
  Widget _buildOrderList(String status) {
    // 根据状态过滤订单
    final filteredOrders = _getOrdersByStatus(status);

    if (filteredOrders.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(filteredOrders[index]);
        },
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80.w,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 24.h),
          Text(
            '暂无$status订单',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '订单将在这里显示',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建订单卡片
  Widget _buildOrderCard(Order order) {
    final statusColor = AppTheme.getStatusColor(order.status);
    final statusText = AppTheme.getStatusText(order.status);

    return GestureDetector(
      onTap: () => _handleViewOrderDetail(order),
      child: Container(
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
          // 订单头部
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '订单编号: ${_formatOrderNo(order.orderNo ?? '')}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 订单内容
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 服务信息
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 20.w,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        order.orderType == 'companion' ? '陪诊服务' : '机构服务',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 患者信息
                _buildInfoRow(
                  icon: Icons.person_outline,
                  label: '患者',
                  value: order.patient?.name ?? '-',
                ),
                SizedBox(height: 8.h),

                // 服务时间
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: '服务时间',
                  value: order.appointmentDate != null
                      ? '${order.appointmentDate!.month}月${order.appointmentDate!.day}日 ${order.appointmentTime}'
                      : '-',
                ),
                SizedBox(height: 8.h),

                // 服务地点
                if (order.hospitalName.isNotEmpty) ...[
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    label: '医院',
                    value: order.hospitalName,
                  ),
                  SizedBox(height: 8.h),
                ],

                // 价格
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 16.w,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '服务费用：',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '¥${order.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                Divider(height: 1, color: AppTheme.dividerColor),
                SizedBox(height: 12.h),

                // 操作按钮
                _buildActionButtons(order),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppTheme.textSecondary),
        SizedBox(width: 8.w),
        Text(
          '$label：',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(Order order) {
    final buttons = <Widget>[];

    // 根据订单状态显示不同的操作按钮
    switch (order.status) {
      case AppConstants.orderStatusPendingAccept:
        buttons.addAll([
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleRejectOrder(order),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: BorderSide(color: AppTheme.errorColor),
              ),
              child: const Text('拒绝'),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _handleAcceptOrder(order),
              child: const Text('接单'),
            ),
          ),
        ]);
        break;

      case AppConstants.orderStatusPendingService:
        buttons.addAll([
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleStartService(order),
              child: const Text('开始服务'),
            ),
          ),
        ]);
        break;

      case AppConstants.orderStatusInService:
        buttons.addAll([
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleCompleteService(order),
              child: const Text('完成服务'),
            ),
          ),
        ]);
        break;

      case AppConstants.orderStatusCompleted:
        buttons.addAll([
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleViewOrderDetail(order),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
              ),
              child: const Text('查看详情'),
            ),
          ),
        ]);
        break;

      default:
        buttons.add(
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleViewOrderDetail(order),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
              ),
              child: const Text('查看详情'),
            ),
          ),
        );
    }

    return Row(children: buttons);
  }

  /// 格式化订单号（缩略显示）
  String _formatOrderNo(String orderNo) {
    if (orderNo.length <= 8) return orderNo;
    return '...${orderNo.substring(orderNo.length - 8)}';
  }

  /// 根据状态获取订单
  List<Order> _getOrdersByStatus(String status) {
    if (status == '全部') return _orders;

    final statusMap = {
      '待接单': AppConstants.orderStatusPendingAccept,
      '待服务': AppConstants.orderStatusPendingService,
      '服务中': AppConstants.orderStatusInService,
      '已完成': AppConstants.orderStatusCompleted,
      '已取消': AppConstants.orderStatusCancelled,
    };

    final targetStatus = statusMap[status];
    if (targetStatus == null) return _orders;

    return _orders.where((order) => order.status == targetStatus).toList();
  }

  /// 接单
  Future<void> _handleAcceptOrder(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认接单'),
        content: Text('确定接受订单 ${order.orderNo} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true && order.id != null) {
      try {
        await _repository.acceptOrder(order.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('接单成功')),
          );
          await _loadOrders();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('接单失败: $e')),
          );
        }
      }
    }
  }

  /// 拒绝订单
  Future<void> _handleRejectOrder(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认拒绝'),
        content: const Text('确定拒绝这个订单吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('拒绝'),
          ),
        ],
      ),
    );

    if (confirmed == true && order.id != null) {
      try {
        await _repository.rejectOrder(order.id!, rejectReason: '陪诊师拒绝接单');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已拒绝订单')),
          );
          await _loadOrders();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('拒绝失败: $e')),
          );
        }
      }
    }
  }

  /// 开始服务
  Future<void> _handleStartService(Order order) async {
    if (order.id == null) return;
    try {
      await _repository.startService(order.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('服务已开始')),
        );
        await _loadOrders();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('开始服务失败: $e')),
        );
      }
    }
  }

  /// 完成服务
  Future<void> _handleCompleteService(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认完成'),
        content: const Text('确认服务已完成吗？完成后将无法修改。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true && order.id != null) {
      try {
        await _repository.completeService(order.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('服务已完成')),
          );
          await _loadOrders();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('完成服务失败: $e')),
          );
        }
      }
    }
  }

  /// 查看订单详情
  void _handleViewOrderDetail(Order order) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => CompanionOrderDetailPage(order: order),
      ),
    );

    // 如果详情页返回 true，刷新列表
    if (result == true) {
      await _loadOrders();
    }
  }
}
