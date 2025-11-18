import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme.dart';
import '../../../data/models/ai_chat.dart';
import '../../../data/models/companion.dart';
import '../../../data/models/order.dart';
import '../../../data/models/patient.dart';
import '../../controllers/ai_chat_controller.dart';
import '../orders/create_order_page.dart';
import '../orders/order_detail_page.dart';
import '../../widgets/order_card_message.dart';

/// 主页 - AI 聊天界面
class HomePage extends ConsumerStatefulWidget {
  final VoidCallback onMenuTap;

  const HomePage({
    super.key,
    required this.onMenuTap,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    try {
      await ref.read(aiChatControllerProvider.notifier).sendMessage(message);
      // 延迟滚动，等待消息添加到列表
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发送失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesState = ref.watch(aiChatControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('AI 智能助手'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuTap,
          tooltip: '菜单',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(aiChatControllerProvider.notifier).clearMessages();
            },
            tooltip: '清空对话',
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: messagesState.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildMessageList(messages);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('加载失败: $error'),
              ),
            ),
          ),

          // 输入框
          _buildInputArea(),
        ],
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
            Icons.chat_bubble_outline,
            size: 80.w,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 24.h),
          Text(
            '你好！我是 CareLink AI 助手',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '我可以帮您找到合适的陪诊师',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          _buildQuickActions(),
        ],
      ),
    );
  }

  /// 构建快捷操作
  Widget _buildQuickActions() {
    final quickMessages = [
      '我需要陪诊服务',
      '预约体检陪诊',
      '查看我的订单',
    ];

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: quickMessages.map((message) {
        return ActionChip(
          label: Text(message),
          onPressed: () {
            _messageController.text = message;
            _sendMessage();
          },
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 13.sp,
          ),
        );
      }).toList(),
    );
  }

  /// 构建消息列表
  Widget _buildMessageList(List<AiChatMessage> messages) {
    // 在构建完成后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        // 如果是订单卡片消息（system 角色且有 orderCard 数据）
        if (message.role == 'system' && message.orderCard != null) {
          return _buildOrderCardBubble(message);
        }

        return _buildMessageBubble(message);
      },
    );
  }

  /// 构建订单卡片气泡
  Widget _buildOrderCardBubble(AiChatMessage message) {
    final orderCard = message.orderCard!;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(isUser: false),
          SizedBox(width: 12.w),
          Expanded(
            child: OrderCardMessage(
              orderNo: orderCard['orderNo'] ?? '',
              amount: (orderCard['amount'] as num?)?.toDouble() ?? 0.0,
              orderDetails: orderCard['orderDetails'] as Map<String, dynamic>?,
              onTap: () => _navigateToOrderDetailFromMessage(message),
            ),
          ),
        ],
      ),
    );
  }

  /// 从消息中跳转到订单详情页
  void _navigateToOrderDetailFromMessage(AiChatMessage message) {
    final orderCard = message.orderCard;
    if (orderCard == null) return;

    final orderDetails = orderCard['orderDetails'] as Map<String, dynamic>?;
    if (orderDetails == null) return;

    // 从 orderCard 创建 Order 对象
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch, // 临时 ID
      orderNo: orderCard['orderNo'] ?? '',
      userId: 0, // 临时值
      patientId: orderDetails['patient']?['id'] ?? 0,
      orderType: 'companion', // 陪诊订单
      companionId: orderDetails['companion']?['id'],
      hospitalName: orderDetails['hospitalName'] ?? '',
      department: orderDetails['department'],
      appointmentDate: DateTime.parse(orderDetails['appointmentDate'] ?? DateTime.now().toIso8601String()),
      appointmentTime: orderDetails['appointmentTime'] ?? '',
      needPickup: orderDetails['needPickup'] ?? false,
      servicePrice: (orderDetails['servicePrice'] as num?)?.toDouble() ?? 0.0,
      pickupPrice: (orderDetails['pickupPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (orderDetails['totalPrice'] as num?)?.toDouble() ?? 0.0,
      userNote: orderDetails['userNote'],
      status: 'pending_accept', // 默认状态：待接单
      paidAt: DateTime.now(), // 刚支付完成
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      // 关联数据
      companion: orderDetails['companion'] != null
          ? Companion(
              id: orderDetails['companion']['id'] ?? 0,
              name: orderDetails['companion']['name'] ?? '',
              avatarUrl: orderDetails['companion']['avatarUrl'],
              gender: 'female',
              rating: 5.0,
            )
          : null,
      patient: orderDetails['patient'] != null
          ? Patient(
              id: orderDetails['patient']['id'] ?? 0,
              userId: 0,
              name: orderDetails['patient']['name'] ?? '',
              gender: orderDetails['patient']['gender'] ?? 'unknown',
              phone: orderDetails['patient']['phone'],
              relationship: orderDetails['patient']['relationship'] ?? 'self',
            )
          : null,
    );

    // 跳转到订单详情页
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(order: order),
      ),
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(AiChatMessage message) {
    final isUser = message.role == 'user';

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(isUser: false),
            SizedBox(width: 12.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppTheme.primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: message.isLoading == true
                      ? _buildLoadingIndicator()
                      : Text(
                          message.content,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isUser ? Colors.white : AppTheme.textPrimary,
                            height: 1.5,
                          ),
                        ),
                ),
                // 推荐卡片
                if (message.recommendations != null &&
                    message.recommendations!.isNotEmpty)
                  _buildRecommendations(message.recommendations!),
              ],
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 12.w),
            _buildAvatar(isUser: true),
          ],
        ],
      ),
    );
  }

  /// 构建头像
  Widget _buildAvatar({required bool isUser}) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: isUser ? AppTheme.primaryColor : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: isUser ? Colors.white : Colors.grey[700],
        size: 20.w,
      ),
    );
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textSecondary),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '正在思考...',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  /// 构建推荐卡片
  Widget _buildRecommendations(List<dynamic> recommendations) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '推荐陪诊师',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          ...recommendations.take(3).map((item) {
            // 将 dynamic 转换为 Companion 对象
            final companion = item is Companion
                ? item
                : Companion.fromJson(item as Map<String, dynamic>);

            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppTheme.dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 24.w,
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
                            color: AppTheme.primaryColor,
                            size: 24.w,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),

                  // 信息区域
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 姓名和认证标识
                        Row(
                          children: [
                            Text(
                              companion.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (companion.isVerified) ...[
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.verified,
                                size: 14.w,
                                color: AppTheme.primaryColor,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // 评分和服务次数
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.w,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              companion.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${companion.completedOrders}单',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // 服务年限和特长
                        Row(
                          children: [
                            if (companion.serviceYears != null) ...[
                              Icon(
                                Icons.workspace_premium,
                                size: 12.w,
                                color: AppTheme.textSecondary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '${companion.serviceYears}年经验',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                            if (companion.hasCar) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.directions_car,
                                size: 12.w,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '有车',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // 预约按钮
                  ElevatedButton(
                    onPressed: () {
                      // 从 AI 控制器获取收集的信息
                      final collectedInfo = ref.read(aiChatControllerProvider.notifier).latestCollectedInfo;

                      debugPrint('预约按钮点击 - 从AI收集到的信息: $collectedInfo');

                      // 跳转到订单创建页面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateOrderPage(
                            companion: companion,
                            aiContext: collectedInfo ?? {
                              // 默认值（如果 AI 没有收集到信息）
                              'hospital': '北京协和医院',
                              'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
                              'time': '09:30',
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(64.w, 32.h),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      '预约',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppTheme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppTheme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppTheme.primaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
