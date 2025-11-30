import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/repositories/order_repository.dart';
import '../../controllers/ai_chat_controller.dart';
import '../orders/order_detail_page.dart';

/// 预约成功页面
class BookingSuccessPage extends ConsumerWidget {
  final int? orderId;  // 订单ID，用于获取完整订单数据
  final String orderNo;
  final double amount;
  final Map<String, dynamic>? orderDetails;

  const BookingSuccessPage({
    super.key,
    this.orderId,
    required this.orderNo,
    required this.amount,
    this.orderDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('预约结果'),
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

                      // 预约成功文本
                      Text(
                        '预约成功',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // 订单金额
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '订单金额: ¥',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            amount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 24.sp,
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
                            _buildInfoRow('支付方式', '线下支付'),
                            SizedBox(height: 12.h),
                            Divider(height: 1.h, color: AppTheme.dividerColor),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              '订单时间',
                              _formatDateTime(DateTime.now()),
                            ),
                            SizedBox(height: 12.h),
                            Divider(height: 1.h, color: AppTheme.dividerColor),
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              '订单状态',
                              '预约成功',
                              valueColor: AppTheme.successColor,
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
                                '订单已提交，陪诊师/机构将尽快与您联系确认。服务费用请在服务当天现场支付。',
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
  Future<void> _navigateToOrderDetail(BuildContext context) async {
    if (orderId == null) {
      // 如果没有订单ID，返回首页
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      return;
    }

    // 显示加载指示器
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 从服务器获取完整的订单数据
      final orderRepository = OrderRepository();
      final order = await orderRepository.getOrderDetail(orderId!);

      if (!context.mounted) return;
      Navigator.pop(context); // 关闭加载指示器

      // 跳转到订单详情页
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(order: order),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // 关闭加载指示器

      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取订单详情失败: $e')),
      );

      // 返回首页
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }
}
