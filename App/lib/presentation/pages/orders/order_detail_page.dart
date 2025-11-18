import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/order.dart';
import '../../../data/repositories/order_repository.dart';

/// 订单详情页面
class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderRepository _orderRepository = OrderRepository();
  bool _isCancelling = false;

  /// 取消订单
  Future<void> _cancelOrder() async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认取消订单'),
        content: const Text('确定要取消这个订单吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('再想想'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('确认取消'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isCancelling = true;
    });

    try {
      if (widget.order.id == null) {
        throw Exception('订单ID不存在');
      }

      await _orderRepository.cancelOrder(
        widget.order.id!,
        cancelReason: '用户取消',
      );

      if (!mounted) return;

      // 显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('订单已取消'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      // 返回上一页并刷新
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isCancelling = false;
      });

      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('取消失败: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('订单详情'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单状态卡片
            _buildOrderStatusCard(),
            SizedBox(height: 8.h),

            // 服务信息
            _buildServiceInfo(),
            SizedBox(height: 8.h),

            // 预约信息
            _buildAppointmentInfo(),
            SizedBox(height: 8.h),

            // 陪诊师信息
            if (widget.order.companion != null) _buildCompanionInfo(),
            if (widget.order.companion != null) SizedBox(height: 8.h),

            // 就诊人信息
            if (widget.order.patient != null) _buildPatientInfo(),
            if (widget.order.patient != null) SizedBox(height: 8.h),

            // 订单备注
            if (widget.order.userNote != null && widget.order.userNote!.isNotEmpty)
              _buildOrderNote(),
            if (widget.order.userNote != null && widget.order.userNote!.isNotEmpty)
              SizedBox(height: 8.h),

            // 价格信息
            _buildPriceInfo(),
            SizedBox(height: 8.h),

            // 订单信息
            _buildOrderInfo(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  /// 构建订单状态卡片
  Widget _buildOrderStatusCard() {
    final statusColor = AppTheme.getStatusColor(widget.order.status);
    final statusText = AppTheme.getStatusText(widget.order.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(widget.order.status),
              size: 24.w,
              color: statusColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _getStatusDescription(widget.order.status),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建服务信息
  Widget _buildServiceInfo() {
    // 根据订单类型显示服务名称
    String serviceName = '';
    String serviceSpec = '';

    if (widget.order.orderType == 'companion') {
      serviceName = '全程陪诊';
      // 根据服务价格推断服务规格
      if (widget.order.servicePrice >= 500) {
        serviceSpec = '全天陪诊（8小时）';
      } else if (widget.order.servicePrice >= 300) {
        serviceSpec = '半天陪诊（4小时）';
      } else {
        serviceSpec = '基础陪诊（2小时）';
      }
    } else if (widget.order.orderType == 'institution') {
      serviceName = '机构陪诊';
      serviceSpec = '专业服务';
    } else {
      serviceName = '陪诊服务';
      serviceSpec = '标准服务';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '服务信息',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('服务产品', serviceName),
          SizedBox(height: 8.h),
          _buildInfoRow('服务规格', serviceSpec),
        ],
      ),
    );
  }

  /// 构建预约信息
  Widget _buildAppointmentInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '预约信息',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('医院', widget.order.hospitalName),
          if (widget.order.department != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow('科室', widget.order.department!),
          ],
          SizedBox(height: 8.h),
          _buildInfoRow(
            '预约时间',
            '${_formatDate(widget.order.appointmentDate)} ${widget.order.appointmentTime}',
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            '是否接送',
            widget.order.needPickup ? '需要上门接送' : '不需要接送',
            valueColor: widget.order.needPickup ? AppTheme.primaryColor : null,
          ),
        ],
      ),
    );
  }

  /// 构建陪诊师信息
  Widget _buildCompanionInfo() {
    final companion = widget.order.companion!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '陪诊师',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              // 头像
              CircleAvatar(
                radius: 28.w,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage: companion.avatarUrl != null &&
                        (companion.avatarUrl!.startsWith('http://') ||
                            companion.avatarUrl!.startsWith('https://'))
                    ? NetworkImage(companion.avatarUrl!)
                    : null,
                child: companion.avatarUrl == null ||
                        !(companion.avatarUrl!.startsWith('http://') ||
                            companion.avatarUrl!.startsWith('https://'))
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
                    Row(
                      children: [
                        Text(
                          companion.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.star,
                          size: 14.w,
                          color: AppTheme.warningColor,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          companion.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppTheme.warningColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '专业陪诊师 · ${companion.serviceYears ?? 0}年经验',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // 联系按钮
              if (widget.order.status != 'cancelled' && widget.order.status != 'completed')
                IconButton(
                  onPressed: () {
                    // TODO: 拨打电话
                  },
                  icon: Icon(
                    Icons.phone_outlined,
                    size: 24.w,
                    color: AppTheme.primaryColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建就诊人信息
  Widget _buildPatientInfo() {
    final patient = widget.order.patient!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '就诊人',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('姓名', patient.name),
          SizedBox(height: 8.h),
          _buildInfoRow('性别', _getGenderText(patient.gender)),
          SizedBox(height: 8.h),
          _buildInfoRow('电话', patient.phone ?? '未填写'),
        ],
      ),
    );
  }

  /// 构建订单备注
  Widget _buildOrderNote() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '订单备注',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.order.userNote!,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建价格信息
  Widget _buildPriceInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '费用明细',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildPriceRow('服务费用', widget.order.servicePrice),
          if (widget.order.needPickup) ...[
            SizedBox(height: 8.h),
            _buildPriceRow('接送费用', widget.order.pickupPrice),
          ],
          if (widget.order.couponDiscount > 0) ...[
            SizedBox(height: 8.h),
            _buildPriceRow('优惠券', -widget.order.couponDiscount),
          ],
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppTheme.dividerColor),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '实付金额',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '¥${widget.order.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建订单信息
  Widget _buildOrderInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '订单信息',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('订单编号', widget.order.orderNo ?? ''),
          SizedBox(height: 8.h),
          _buildInfoRow('下单时间', _formatDateTime(widget.order.createdAt)),
          if (widget.order.paidAt != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow('支付时间', _formatDateTime(widget.order.paidAt)),
          ],
          if (widget.order.acceptedAt != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow('接单时间', _formatDateTime(widget.order.acceptedAt)),
          ],
          if (widget.order.serviceCompletedAt != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow('完成时间', _formatDateTime(widget.order.serviceCompletedAt)),
          ],
          if (widget.order.cancelledAt != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow('取消时间', _formatDateTime(widget.order.cancelledAt)),
          ],
          if (widget.order.cancelReason != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow('取消原因', widget.order.cancelReason!),
          ],
        ],
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: SafeArea(
        child: Row(
          children: [
            // 根据订单状态显示不同的操作按钮
            if (widget.order.status == 'pending_payment') ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _isCancelling ? null : _cancelOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    side: BorderSide(color: AppTheme.dividerColor),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: _isCancelling
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          '取消订单',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 去支付
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    '去支付',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ] else if (widget.order.status == 'completed') ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 评价订单
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    '评价订单',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ] else if (widget.order.status == 'pending_accept' ||
                       widget.order.status == 'accepted') ...[
              // 待接单和已接单状态，显示取消订单按钮
              Expanded(
                child: OutlinedButton(
                  onPressed: _isCancelling ? null : _cancelOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: BorderSide(color: AppTheme.errorColor),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: _isCancelling
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          '取消订单',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 联系客服
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    '联系客服',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ),
            ] else if (widget.order.status != 'cancelled' &&
                       widget.order.status != 'completed') ...[
              // 其他状态只显示联系客服
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 联系客服
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    '联系客服',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70.w,
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
              color: valueColor ?? AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建价格行
  Widget _buildPriceRow(String label, double price) {
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
          price < 0
              ? '-¥${(-price).toStringAsFixed(2)}'
              : '¥${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 获取状态图标
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending_payment':
        return Icons.payment_outlined;
      case 'pending_accept':
        return Icons.schedule_outlined;
      case 'pending_service':
        return Icons.access_time_outlined;
      case 'in_service':
        return Icons.medical_services_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  /// 获取状态描述
  String _getStatusDescription(String status) {
    switch (status) {
      case 'pending_payment':
        return '请尽快完成支付';
      case 'pending_accept':
        return '陪诊师将尽快接单';
      case 'pending_service':
        return '等待服务开始';
      case 'in_service':
        return '服务进行中';
      case 'completed':
        return '服务已完成，期待您的评价';
      case 'cancelled':
        return '订单已取消';
      default:
        return '';
    }
  }

  /// 格式化日期
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year}-${_padZero(dateTime.month)}-${_padZero(dateTime.day)} '
        '${_padZero(dateTime.hour)}:${_padZero(dateTime.minute)}';
  }

  /// 补零
  String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  /// 获取性别文本
  String _getGenderText(String gender) {
    switch (gender) {
      case 'male':
        return '男';
      case 'female':
        return '女';
      default:
        return '未知';
    }
  }
}
