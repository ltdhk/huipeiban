import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme.dart';

/// 订单卡片消息组件 - 在 AI 聊天中显示
class OrderCardMessage extends StatelessWidget {
  final String orderNo;
  final double amount;
  final Map<String, dynamic>? orderDetails;
  final VoidCallback? onTap;

  const OrderCardMessage({
    super.key,
    required this.orderNo,
    required this.amount,
    this.orderDetails,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final details = orderDetails;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14.w,
                        color: AppTheme.successColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '支付成功',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                  color: AppTheme.textHint,
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 订单编号
            Text(
              '订单编号：$orderNo',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppTheme.textSecondary,
              ),
            ),

            SizedBox(height: 8.h),

            // 订单信息
            if (details != null) ...[
              _buildInfoRow(
                Icons.local_hospital,
                details['hospitalName'] ?? '未知医院',
              ),
              if (details['department'] != null) ...[
                SizedBox(height: 6.h),
                _buildInfoRow(
                  Icons.medical_services,
                  details['department'],
                ),
              ],
              SizedBox(height: 6.h),
              _buildInfoRow(
                Icons.access_time,
                '${_formatDate(details['appointmentDate'])} ${details['appointmentTime'] ?? ''}',
              ),
            ],

            SizedBox(height: 12.h),
            Divider(height: 1.h, color: AppTheme.dividerColor),
            SizedBox(height: 12.h),

            // 金额信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '实付金额',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
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
                      amount.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 查看详情按钮
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '点击查看订单详情',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
          color: AppTheme.primaryColor,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 格式化日期
  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}年${date.month}月${date.day}日';
    } catch (e) {
      return '';
    }
  }
}
