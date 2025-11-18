import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/order.dart';
import '../../../data/models/companion.dart';
import '../../../data/models/patient.dart';
import '../../controllers/ai_chat_controller.dart';
import '../orders/order_detail_page.dart';

/// 支付成功页面
class PaymentSuccessPage extends ConsumerWidget {
  final String orderNo;
  final double amount;
  final String paymentMethod;
  final Map<String, dynamic>? orderDetails;

  const PaymentSuccessPage({
    super.key,
    required this.orderNo,
    required this.amount,
    required this.paymentMethod,
    this.orderDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('支付结果'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),

                      // 成功图标
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 60.w,
                          color: AppTheme.successColor,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // 支付成功文本
                      Text(
                        '支付成功',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // 支付金额
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '¥',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            amount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.h),

                      // 订单信息卡片
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('订单编号', orderNo),
                            SizedBox(height: 12.h),
                            Divider(height: 1.h, color: AppTheme.dividerColor),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              '支付方式',
                              _getPaymentMethodName(paymentMethod),
                            ),
                            SizedBox(height: 12.h),
                            Divider(height: 1.h, color: AppTheme.dividerColor),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              '支付时间',
                              _formatDateTime(DateTime.now()),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // 提示信息
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppTheme.infoColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20.w,
                              color: AppTheme.infoColor,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                '订单已提交，陪诊师将尽快接单。请注意查收订单通知。',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppTheme.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 底部按钮
            Container(
              padding: EdgeInsets.all(16.w),
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
              child: Row(
                children: [
                  // 返回首页
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // 将订单卡片消息添加到聊天历史
                        if (orderDetails != null) {
                          ref.read(aiChatControllerProvider.notifier).addOrderCardMessage(
                            orderNo: orderNo,
                            amount: amount,
                            orderDetails: orderDetails!,
                          );
                        }

                        // 返回首页
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        '返回首页',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // 查看订单
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 跳转到订单详情页面
                        _navigateToOrderDetail(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        '查看订单',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建信息行
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
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// 获取支付方式名称
  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'wechat':
        return '微信支付';
      case 'alipay':
        return '支付宝';
      default:
        return '未知';
    }
  }

  /// 格式化时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_padZero(dateTime.month)}-${_padZero(dateTime.day)} '
        '${_padZero(dateTime.hour)}:${_padZero(dateTime.minute)}:${_padZero(dateTime.second)}';
  }

  /// 补零
  String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  /// 跳转到订单详情页
  void _navigateToOrderDetail(BuildContext context) {
    if (orderDetails == null) {
      // 如果没有订单详情，返回首页
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      return;
    }

    // 从 orderDetails 创建 Order 对象
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch, // 临时 ID
      orderNo: orderNo,
      userId: 0, // 临时值
      patientId: orderDetails!['patient']?['id'] ?? 0,
      orderType: 'companion', // 陪诊订单
      companionId: orderDetails!['companion']?['id'],
      hospitalName: orderDetails!['hospitalName'] ?? '',
      department: orderDetails!['department'],
      appointmentDate: DateTime.parse(
          orderDetails!['appointmentDate'] ?? DateTime.now().toIso8601String()),
      appointmentTime: orderDetails!['appointmentTime'] ?? '',
      needPickup: orderDetails!['needPickup'] ?? false,
      servicePrice: (orderDetails!['servicePrice'] ?? 0.0).toDouble(),
      pickupPrice: (orderDetails!['pickupPrice'] ?? 0.0).toDouble(),
      totalPrice: (orderDetails!['totalPrice'] ?? 0.0).toDouble(),
      userNote: orderDetails!['userNote'],
      status: 'pending_accept', // 默认状态：待接单
      paidAt: DateTime.now(), // 刚支付完成
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      // 关联数据
      companion: orderDetails!['companion'] != null
          ? Companion(
              id: orderDetails!['companion']['id'] ?? 0,
              name: orderDetails!['companion']['name'] ?? '',
              avatarUrl: orderDetails!['companion']['avatarUrl'],
              gender: 'female',
              rating: 5.0,
            )
          : null,
      patient: orderDetails!['patient'] != null
          ? Patient(
              id: orderDetails!['patient']['id'] ?? 0,
              userId: 0,
              name: orderDetails!['patient']['name'] ?? '',
              gender: orderDetails!['patient']['gender'] ?? 'unknown',
              phone: orderDetails!['patient']['phone'],
              relationship: orderDetails!['patient']['relationship'] ?? 'self',
            )
          : null,
    );

    // 跳转到订单详情页
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(order: order),
      ),
    );
  }
}
