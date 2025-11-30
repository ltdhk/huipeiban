import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/order.dart';
import '../../../data/repositories/companion_order_repository.dart';
import '../../../data/repositories/message_repository.dart';
import '../messages/chat_detail_page.dart';

/// 陪诊师订单详情页面
class CompanionOrderDetailPage extends StatefulWidget {
  final Order order;

  const CompanionOrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<CompanionOrderDetailPage> createState() =>
      _CompanionOrderDetailPageState();
}

class _CompanionOrderDetailPageState extends State<CompanionOrderDetailPage> {
  final CompanionOrderRepository _repository = CompanionOrderRepository();
  late Order _order;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = AppTheme.getStatusColor(_order.status);
    final statusText = AppTheme.getStatusText(_order.status);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('订单详情'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 订单状态卡片
                _buildStatusCard(statusColor, statusText),
                SizedBox(height: 16.h),

                // 患者信息卡片
                _buildPatientCard(),
                SizedBox(height: 16.h),

                // 服务信息卡片
                _buildServiceCard(),
                SizedBox(height: 16.h),

                // 订单信息卡片
                _buildOrderInfoCard(),
                SizedBox(height: 100.h), // 底部留白给操作按钮
              ],
            ),
          ),

          // 底部操作按钮
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActions(),
          ),

          // 加载遮罩
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建状态卡片
  Widget _buildStatusCard(Color statusColor, String statusText) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor, statusColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(_order.status),
            size: 48.w,
            color: Colors.white,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _getStatusDescription(_order.status),
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

  /// 构建患者信息卡片
  Widget _buildPatientCard() {
    final patient = _order.patient;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                size: 20.w,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '患者信息',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (patient != null) ...[
            _buildInfoItem('姓名', patient.name),
            _buildInfoItem('性别', patient.gender == 'male' ? '男' : '女'),
            if (patient.phone != null && patient.phone!.isNotEmpty) ...[
              _buildInfoItem('电话', patient.phone!),
              // 联系方式操作按钮
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildContactButton(
                        icon: Icons.phone,
                        label: '拨打电话',
                        color: AppTheme.successColor,
                        onTap: () => _callPhone(patient.phone!),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildContactButton(
                        icon: Icons.message,
                        label: '发送短信',
                        color: AppTheme.primaryColor,
                        onTap: () => _sendSms(patient.phone!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  '暂无患者信息',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建服务信息卡片
  Widget _buildServiceCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services,
                size: 20.w,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '服务信息',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoItem(
            '服务类型',
            _order.orderType == 'companion' ? '陪诊服务' : '机构服务',
          ),
          if (_order.hospitalName.isNotEmpty)
            _buildInfoItem('医院', _order.hospitalName),
          if (_order.department != null && _order.department!.isNotEmpty)
            _buildInfoItem('科室', _order.department!),
          if (_order.appointmentDate != null)
            _buildInfoItem(
              '服务时间',
              '${_order.appointmentDate!.year}年${_order.appointmentDate!.month}月${_order.appointmentDate!.day}日 ${_order.appointmentTime}',
            ),
          if (_order.needPickup)
            _buildInfoItem('接送服务', '需要接送'),
          Divider(height: 24.h, color: AppTheme.dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '服务费用',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '¥${_order.servicePrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          if (_order.needPickup) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '接送费用',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '¥${_order.pickupPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '总计',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '¥${_order.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建订单信息卡片
  Widget _buildOrderInfoCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                size: 20.w,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '订单信息',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoItemWithCopy('订单编号', _order.orderNo ?? ''),
          _buildInfoItem(
            '下单时间',
            _formatDateTime(_order.createdAt),
          ),
        ],
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建联系按钮
  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.w, color: color),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建带复制的信息项
  Widget _buildInfoItemWithCopy(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _copyToClipboard(value),
            child: Icon(
              Icons.copy,
              size: 18.w,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作按钮
  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: _buildActionButtonsByStatus(),
        ),
      ),
    );
  }

  /// 根据订单状态构建操作按钮
  List<Widget> _buildActionButtonsByStatus() {
    switch (_order.status) {
      case AppConstants.orderStatusPendingAccept:
        return [
          Expanded(
            child: OutlinedButton(
              onPressed: _handleRejectOrder,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: BorderSide(color: AppTheme.errorColor),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: const Text('拒绝订单'),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _handleAcceptOrder,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: const Text('接受订单'),
            ),
          ),
        ];

      case AppConstants.orderStatusPendingService:
        return [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openChat,
              icon: const Icon(Icons.chat),
              label: const Text('联系患者'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _handleStartService,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: const Text('开始服务'),
            ),
          ),
        ];

      case AppConstants.orderStatusInService:
        return [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openChat,
              icon: const Icon(Icons.chat),
              label: const Text('联系患者'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _handleCompleteService,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: const Text('完成服务'),
            ),
          ),
        ];

      default:
        return [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _openChat,
              icon: const Icon(Icons.chat),
              label: const Text('联系患者'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ];
    }
  }

  /// 打开即时通讯
  Future<void> _openChat() async {
    if (_order.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法获取用户信息')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final messageRepo = MessageRepository();
      // 创建或获取与用户的会话（使用统一的用户ID）
      final conversation = await messageRepo.createConversation(
        targetUserId: _order.userId!,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        // 跳转到聊天详情页
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(conversation: conversation),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('打开聊天失败: $e')),
        );
      }
    }
  }

  /// 拨打电话
  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法拨打电话')),
        );
      }
    }
  }

  /// 发送短信
  Future<void> _sendSms(String phone) async {
    final uri = Uri.parse('sms:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法发送短信')),
        );
      }
    }
  }

  /// 复制到剪贴板
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板')),
    );
  }

  /// 接受订单
  Future<void> _handleAcceptOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认接单'),
        content: const Text('确定接受这个订单吗？'),
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

    if (confirmed == true && _order.id != null) {
      setState(() => _isLoading = true);
      try {
        await _repository.acceptOrder(_order.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('接单成功')),
          );
          setState(() {
            _order = _order.copyWith(status: AppConstants.orderStatusPendingService);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('接单失败: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 拒绝订单
  Future<void> _handleRejectOrder() async {
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

    if (confirmed == true && _order.id != null) {
      setState(() => _isLoading = true);
      try {
        await _repository.rejectOrder(_order.id!, rejectReason: '陪诊师拒绝接单');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已拒绝订单')),
          );
          Navigator.of(context).pop(true); // 返回并刷新列表
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('拒绝失败: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 开始服务
  Future<void> _handleStartService() async {
    if (_order.id == null) return;

    setState(() => _isLoading = true);
    try {
      await _repository.startService(_order.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('服务已开始')),
        );
        setState(() {
          _order = _order.copyWith(status: AppConstants.orderStatusInService);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('开始服务失败: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 完成服务
  Future<void> _handleCompleteService() async {
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

    if (confirmed == true && _order.id != null) {
      setState(() => _isLoading = true);
      try {
        await _repository.completeService(_order.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('服务已完成')),
          );
          setState(() {
            _order = _order.copyWith(status: AppConstants.orderStatusCompleted);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('完成服务失败: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 获取状态图标
  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.orderStatusPendingAccept:
        return Icons.notification_important;
      case AppConstants.orderStatusPendingService:
        return Icons.schedule;
      case AppConstants.orderStatusInService:
        return Icons.play_circle;
      case AppConstants.orderStatusCompleted:
        return Icons.check_circle;
      case AppConstants.orderStatusCancelled:
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  /// 获取状态描述
  String _getStatusDescription(String status) {
    switch (status) {
      case AppConstants.orderStatusPendingAccept:
        return '请尽快确认是否接受此订单';
      case AppConstants.orderStatusPendingService:
        return '请在约定时间提供服务';
      case AppConstants.orderStatusInService:
        return '服务进行中，请确保服务质量';
      case AppConstants.orderStatusCompleted:
        return '服务已完成';
      case AppConstants.orderStatusCancelled:
        return '订单已取消';
      default:
        return '';
    }
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
