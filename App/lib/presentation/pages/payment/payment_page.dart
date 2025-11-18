import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/companion.dart';
import '../../../data/models/service.dart';
import '../../../data/models/patient.dart';
import '../../../data/repositories/order_repository.dart';

/// 支付确认页面
class PaymentPage extends StatefulWidget {
  final String hospitalName;
  final String? department;
  final DateTime appointmentDate;
  final String appointmentTime;
  final ServiceSpec serviceSpec;
  final bool needPickup;
  final Companion companion;
  final Patient patient;
  final double servicePrice;
  final double pickupPrice;
  final String? userNote;

  const PaymentPage({
    super.key,
    required this.hospitalName,
    this.department,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.serviceSpec,
    required this.needPickup,
    required this.companion,
    required this.patient,
    required this.servicePrice,
    required this.pickupPrice,
    this.userNote,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // 支付方式: wechat, alipay
  String _selectedPaymentMethod = 'wechat';

  // 订单备注控制器
  final TextEditingController _noteController = TextEditingController();

  // 订单仓库
  final OrderRepository _orderRepository = OrderRepository();

  // 是否正在处理支付
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.userNote != null) {
      _noteController.text = widget.userNote!;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// 计算总价
  double get totalPrice => widget.servicePrice + widget.pickupPrice;

  /// 处理支付
  Future<void> _handlePayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                '正在创建订单...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // 调用后端 API 创建订单
      final result = await _orderRepository.createOrder(
        patientId: widget.patient.id,
        orderType: 'companion',
        companionId: widget.companion.id,
        serviceSpecId: widget.serviceSpec.id,
        hospitalName: widget.hospitalName,
        department: widget.department,
        appointmentDate: widget.appointmentDate,
        appointmentTime: widget.appointmentTime,
        needPickup: widget.needPickup,
        servicePrice: widget.servicePrice,
        pickupPrice: widget.pickupPrice,
        userNote: _noteController.text.isEmpty ? null : _noteController.text,
      );

      // 获取订单编号
      final orderNo = result['order_no'] as String;

      // TODO: 这里应该调用支付接口
      // 目前模拟支付成功
      await Future.delayed(const Duration(seconds: 1));

      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();

        // 跳转到支付成功页面，传递完整的订单信息
        Navigator.of(context).pushReplacementNamed(
          '/payment-success',
          arguments: {
            'orderNo': orderNo,
            'amount': totalPrice,
            'paymentMethod': _selectedPaymentMethod,
            // 订单详细信息
            'orderDetails': {
              'hospitalName': widget.hospitalName,
              'department': widget.department,
              'appointmentDate': widget.appointmentDate.toIso8601String(),
              'appointmentTime': widget.appointmentTime,
              'serviceSpec': widget.serviceSpec.name,
              'needPickup': widget.needPickup,
              'companion': {
                'id': widget.companion.id,
                'name': widget.companion.name,
                'avatarUrl': widget.companion.avatarUrl,
              },
              'patient': {
                'id': widget.patient.id,
                'name': widget.patient.name,
                'gender': widget.patient.gender,
                'phone': widget.patient.phone,
                'relationship': widget.patient.relationship,
              },
              'servicePrice': widget.servicePrice,
              'pickupPrice': widget.pickupPrice,
              'totalPrice': totalPrice,
              'userNote': _noteController.text.isEmpty ? null : _noteController.text,
            },
          },
        );
      }
    } catch (e) {
      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();

        // 显示错误提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('创建订单失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('确认订单'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 预约信息
                  _buildAppointmentInfo(),
                  SizedBox(height: 8.h),

                  // 陪诊师信息
                  _buildCompanionInfo(),
                  SizedBox(height: 8.h),

                  // 订单备注
                  _buildOrderNote(),
                  SizedBox(height: 8.h),

                  // 支付方式
                  _buildPaymentMethod(),
                  SizedBox(height: 8.h),

                  // 价格明细
                  _buildPriceDetail(),
                ],
              ),
            ),
          ),

          // 底部支付按钮
          _buildPaymentButton(),
        ],
      ),
    );
  }

  /// 构建预约信息
  Widget _buildAppointmentInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_hospital,
                size: 20.w,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  widget.hospitalName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (widget.department != null) ...[
            SizedBox(height: 8.h),
            Text(
              widget.department!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppTheme.dividerColor),
          SizedBox(height: 12.h),
          _buildInfoRow(
            '预约时间',
            '${widget.appointmentDate.year}年${widget.appointmentDate.month}月${widget.appointmentDate.day}日 ${widget.appointmentTime}',
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            '服务类型',
            widget.serviceSpec.name,
          ),
          if (widget.needPickup) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(
              '接送服务',
              '需要上门接送',
              valueColor: AppTheme.primaryColor,
            ),
          ],
        ],
      ),
    );
  }

  /// 构建陪诊师信息
  Widget _buildCompanionInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 28.w,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            backgroundImage: widget.companion.avatarUrl != null &&
                    (widget.companion.avatarUrl!.startsWith('http://') ||
                        widget.companion.avatarUrl!.startsWith('https://'))
                ? NetworkImage(widget.companion.avatarUrl!)
                : null,
            child: widget.companion.avatarUrl == null ||
                    !(widget.companion.avatarUrl!.startsWith('http://') ||
                        widget.companion.avatarUrl!.startsWith('https://'))
                ? Icon(Icons.person, size: 28.w, color: AppTheme.primaryColor)
                : null,
          ),
          SizedBox(width: 12.w),

          // 陪诊师信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.companion.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.star,
                      size: 16.w,
                      color: AppTheme.warningColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      widget.companion.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '专业陪诊师 · ${widget.companion.serviceYears ?? 0}年经验',
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

  /// 构建订单备注
  Widget _buildOrderNote() {
    return Container(
      color: Colors.white,
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
          SizedBox(height: 12.h),
          TextField(
            controller: _noteController,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: '请输入订单备注信息（选填）',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textHint,
              ),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建支付方式
  Widget _buildPaymentMethod() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '支付方式',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),

          // 微信支付
          _buildPaymentOption(
            method: 'wechat',
            icon: Icons.chat_bubble_outline,
            iconColor: const Color(0xFF07C160),
            title: '微信支付',
          ),

          SizedBox(height: 12.h),

          // 支付宝
          _buildPaymentOption(
            method: 'alipay',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF1677FF),
            title: '支付宝',
          ),
        ],
      ),
    );
  }

  /// 构建支付方式选项
  Widget _buildPaymentOption({
    required String method,
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.w,
              color: iconColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20.w,
                color: AppTheme.primaryColor,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                size: 20.w,
                color: AppTheme.textHint,
              ),
          ],
        ),
      ),
    );
  }

  /// 构建价格明细
  Widget _buildPriceDetail() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '价格明细',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildPriceRow('服务费用', widget.servicePrice),
          if (widget.needPickup) ...[
            SizedBox(height: 8.h),
            _buildPriceRow('接送费用', widget.pickupPrice),
          ],
        ],
      ),
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
          '¥${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 构建底部支付按钮
  Widget _buildPaymentButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: SafeArea(
        child: Row(
          children: [
            // 总价
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '实付金额',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.errorColor,
                        ),
                      ),
                      Text(
                        totalPrice.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 支付按钮
            SizedBox(
              width: 160.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  '立即支付',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
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
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
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
}
