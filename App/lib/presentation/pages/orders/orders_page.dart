import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/order.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../data/repositories/message_repository.dart';
import 'order_detail_page.dart';
import '../messages/chat_detail_page.dart';

/// 订单页面
class OrdersPage extends ConsumerStatefulWidget {
  final VoidCallback onMenuTap;

  const OrdersPage({
    super.key,
    required this.onMenuTap,
  });

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderRepository _orderRepository = OrderRepository();

  // 订单状态标签
  final List<Map<String, String>> _tabs = [
    {'label': '全部', 'status': ''},
    {'label': '已预约', 'status': 'pending_payment'},
    {'label': '待服务', 'status': 'pending_accept,accepted'},
    {'label': '服务中', 'status': 'in_progress'},
    {'label': '已完成', 'status': 'completed'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
        title: const Text('我的订单'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuTap,
          tooltip: '菜单',
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,  // 选中文字颜色：白色
          unselectedLabelColor: Colors.white70,  // 未选中文字颜色：半透明白色
          indicatorColor: Colors.white,  // 指示器颜色：白色
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          tabs: _tabs.map((tab) => Tab(text: tab['label'])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          return _OrderListView(
            status: tab['status']!,
            orderRepository: _orderRepository,
          );
        }).toList(),
      ),
    );
  }
}

/// 订单列表视图
class _OrderListView extends StatefulWidget {
  final String status;
  final OrderRepository orderRepository;

  const _OrderListView({
    required this.status,
    required this.orderRepository,
  });

  @override
  State<_OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<_OrderListView>
    with AutomaticKeepAliveClientMixin {
  List<Order> _orders = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  final MessageRepository _messageRepository = MessageRepository();
  bool _isCreatingConversation = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  /// 加载订单列表
  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await widget.orderRepository.getOrders(
        page: 1,
        pageSize: 50,
        status: widget.status.isEmpty ? null : widget.status,
      );

      final ordersData = response['list'] as List<dynamic>?;
      if (ordersData != null) {
        setState(() {
          _orders = ordersData
              .map((item) => Order.fromJson(item as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _orders = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: AppTheme.errorColor,
            ),
            SizedBox(height: 16.h),
            Text(
              '加载失败',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
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

    if (_orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(_orders[index]);
        },
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80.w,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无订单',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建订单卡片
  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(order: order),
          ),
        ).then((_) {
          // 从详情页返回后刷新列表
          _loadOrders();
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单头部：服务类型和状态
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getServiceIcon(order.orderType),
                      size: 20.w,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _getServiceTypeName(order.orderType),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                _buildStatusTag(order.status),
              ],
            ),

            SizedBox(height: 12.h),
            Divider(height: 1.h, color: AppTheme.dividerColor),
            SizedBox(height: 12.h),

            // 医院和时间信息
            _buildInfoRow(Icons.local_hospital, order.hospitalName),
            SizedBox(height: 8.h),
            if (order.appointmentDate != null)
              _buildInfoRow(
                Icons.access_time,
                '${order.appointmentDate!.year}-${_padZero(order.appointmentDate!.month)}-${_padZero(order.appointmentDate!.day)} ${order.appointmentTime}',
              ),

            // 陪诊师信息（如果有）
            if (order.companion != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow(Icons.person, order.companion!.name),
            ],

            SizedBox(height: 12.h),
            Divider(height: 1.h, color: AppTheme.dividerColor),
            SizedBox(height: 12.h),

            // 底部：价格和按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '总计：',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '¥',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    Text(
                      order.totalPrice.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
                _buildActionButton(order),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.w,
          color: AppTheme.textSecondary,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 构建状态标签
  Widget _buildStatusTag(String status) {
    final config = _getStatusConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        config['text'],
        style: TextStyle(
          fontSize: 12.sp,
          color: config['color'],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 联系服务提供方（陪诊师或机构）
  Future<void> _contactServiceProvider(Order order) async {
    if (_isCreatingConversation) return;

    setState(() => _isCreatingConversation = true);

    try {
      // 获取服务提供方的用户ID
      // 注意：需要使用 companion.userId，而不是 order.companionId
      // companion.userId 是关联到 users 表的 ID，用于即时通讯
      // order.companionId 是 companions 表的主键 ID
      int? targetUserId;
      if (order.orderType == 'companion') {
        targetUserId = order.companion?.userId;
      } else {
        // 机构使用 institution.userId 进行即时通讯
        targetUserId = order.institution?.userId;
      }

      if (targetUserId == null) {
        throw Exception('无法获取服务提供方信息');
      }

      // 调用API创建或获取已存在的会话
      final conversation = await _messageRepository.createConversation(
        targetUserId: targetUserId,
      );

      if (!mounted) return;

      // 跳转到聊天详情页
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(conversation: conversation),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('创建会话失败: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isCreatingConversation = false);
      }
    }
  }

  /// 构建操作按钮
  Widget _buildActionButton(Order order) {
    switch (order.status) {
      case 'pending_payment':
        return ElevatedButton(
          onPressed: () => _contactServiceProvider(order),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(80.w, 32.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            backgroundColor: AppTheme.primaryColor,
          ),
          child: Text(
            '去联系',
            style: TextStyle(fontSize: 13.sp, color: Colors.white),
          ),
        );
      case 'completed':
        return OutlinedButton(
          onPressed: () {
            // TODO: 再次预约
          },
          style: OutlinedButton.styleFrom(
            minimumSize: Size(80.w, 32.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
          child: Text(
            '再次预约',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.primaryColor,
            ),
          ),
        );
      default:
        return OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailPage(order: order),
              ),
            ).then((_) => _loadOrders());
          },
          style: OutlinedButton.styleFrom(
            minimumSize: Size(80.w, 32.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            side: BorderSide(color: AppTheme.textSecondary.withOpacity(0.5)),
          ),
          child: Text(
            '查看详情',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        );
    }
  }

  /// 获取服务类型图标
  IconData _getServiceIcon(String orderType) {
    switch (orderType) {
      case 'companion':
        return Icons.person_outline;
      case 'report':
        return Icons.description_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  /// 获取服务类型名称
  String _getServiceTypeName(String orderType) {
    switch (orderType) {
      case 'companion':
        return '全程陪诊';
      case 'report':
        return '代取报告';
      default:
        return '未知服务';
    }
  }

  /// 获取状态配置
  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'pending_payment':
        return {'text': '预约成功', 'color': AppTheme.successColor};
      case 'pending_accept':
        return {'text': '待接单', 'color': AppTheme.infoColor};
      case 'accepted':
        return {'text': '已接单', 'color': AppTheme.infoColor};
      case 'in_progress':
        return {'text': '服务中', 'color': AppTheme.primaryColor};
      case 'completed':
        return {'text': '已完成', 'color': AppTheme.successColor};
      case 'cancelled':
        return {'text': '已取消', 'color': AppTheme.textSecondary};
      case 'refunding':
        return {'text': '退款中', 'color': AppTheme.warningColor};
      case 'refunded':
        return {'text': '已退款', 'color': AppTheme.textSecondary};
      default:
        return {'text': status, 'color': AppTheme.textSecondary};
    }
  }

  /// 补零
  String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }
}
