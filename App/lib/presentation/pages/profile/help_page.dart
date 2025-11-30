import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';

/// 帮助与反馈页面
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<_FaqItem> _faqList = [
    _FaqItem(
      question: '如何预约陪诊服务？',
      answer: '您可以在首页选择陪诊师或机构，选择服务类型和时间后提交订单即可完成预约。',
    ),
    _FaqItem(
      question: '如何取消订单？',
      answer: '在"我的订单"中找到需要取消的订单，点击"取消订单"按钮即可。请注意，不同时间取消可能会收取不同比例的取消费。',
    ),
    _FaqItem(
      question: '如何联系陪诊师？',
      answer: '订单确认后，您可以通过订单详情页面的"联系陪诊师"按钮与陪诊师进行即时通讯。',
    ),
    _FaqItem(
      question: '付款方式有哪些？',
      answer: '目前支持微信支付、支付宝等主流支付方式。',
    ),
    _FaqItem(
      question: '如何申请退款？',
      answer: '如需退款，请在订单详情页面点击"申请退款"，填写退款原因后提交，我们会在1-3个工作日内处理。',
    ),
    _FaqItem(
      question: '如何修改就诊人信息？',
      answer: '在"个人中心"-"就诊人管理"中可以添加、编辑或删除就诊人信息。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('帮助与反馈'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // 常见问题
          _buildSectionTitle('常见问题'),
          SizedBox(height: 12.h),
          _buildFaqList(),

          SizedBox(height: 24.h),

          // 联系我们
          _buildSectionTitle('联系我们'),
          SizedBox(height: 12.h),
          _buildContactCard(),

          SizedBox(height: 24.h),

          // 意见反馈
          _buildSectionTitle('意见反馈'),
          SizedBox(height: 12.h),
          _buildFeedbackCard(),
        ],
      ),
    );
  }

  /// 构建分区标题
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  /// 构建常见问题列表
  Widget _buildFaqList() {
    return Container(
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
      child: Column(
        children: _faqList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == _faqList.length - 1;

          return Column(
            children: [
              _buildFaqItem(item),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 16.w,
                  endIndent: 16.w,
                  color: AppTheme.dividerColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 构建常见问题项
  Widget _buildFaqItem(_FaqItem item) {
    return ExpansionTile(
      title: Text(
        item.question,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.answer,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// 构建联系卡片
  Widget _buildContactCard() {
    return Container(
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
      child: Column(
        children: [
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: '客服电话',
            subtitle: '400-123-4567',
            onTap: () {
              // TODO: 拨打电话
            },
          ),
          Divider(
            height: 1,
            indent: 56.w,
            endIndent: 16.w,
            color: AppTheme.dividerColor,
          ),
          _buildContactItem(
            icon: Icons.access_time,
            title: '服务时间',
            subtitle: '周一至周日 9:00-21:00',
          ),
          Divider(
            height: 1,
            indent: 56.w,
            endIndent: 16.w,
            color: AppTheme.dividerColor,
          ),
          _buildContactItem(
            icon: Icons.email_outlined,
            title: '客服邮箱',
            subtitle: 'support@carelink.com',
            onTap: () {
              // TODO: 发送邮件
            },
          ),
        ],
      ),
    );
  }

  /// 构建联系项
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 22.w,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: AppTheme.textHint,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建反馈卡片
  Widget _buildFeedbackCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '您的反馈对我们很重要',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '如果您在使用过程中遇到问题或有任何建议，欢迎告诉我们。',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showFeedbackDialog(),
              child: const Text('提交反馈'),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示反馈对话框
  void _showFeedbackDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('意见反馈'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: '请输入您的意见或建议...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('感谢您的反馈！')),
                );
              }
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}

/// 常见问题数据类
class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}
