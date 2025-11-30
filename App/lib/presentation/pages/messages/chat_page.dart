import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/theme.dart';
import '../../../core/services/voice_service.dart';

/// 聊天详情页面
class ChatPage extends StatefulWidget {
  final String conversationId;
  final String title;
  final String? avatarUrl;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.title,
    this.avatarUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final VoiceService _voiceService = VoiceService();
  
  bool _isRecording = false;
  bool _isVoiceInputMode = false; // 是否切换到语音输入模式

  // 模拟聊天记录
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'isUser': false,
      'content': '您好，我是王陪诊师，很高兴为您服务。请问有什么可以帮您的吗？',
      'time': '下午 2:28',
      'type': 'text',
    },
    {
      'id': '2',
      'isUser': true,
      'content': '你好，王师傅。我想确认一下明天的陪诊时间和地点。',
      'time': '下午 2:29',
      'type': 'text',
    },
    {
      'id': '3',
      'isUser': false,
      'content': '好的，明天上午9点在医院门口见。',
      'time': '下午 2:30',
      'type': 'text',
    },
    {
      'id': '4',
      'isUser': true,
      'content': '',
      'time': '下午 2:31',
      'type': 'image',
      'imageUrl': 'https://via.placeholder.com/300x200.png?text=Map', // 模拟地图图片
    },
    {
      'id': '5',
      'isUser': true,
      'content': '是这个门口吗？',
      'time': '下午 2:31',
      'type': 'text',
    },
  ];

  @override
  void initState() {
    super.initState();
    // 初始化语音服务
    _voiceService.init();
    
    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _voiceService.cancel();
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

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'isUser': true,
        'content': content,
        'time': _formatTime(DateTime.now()),
        'type': 'text',
      });
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? '下午' : '上午';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period $hour:$minute';
  }

  // 开始录音
  Future<void> _startRecording() async {
    final hasPermission = await Permission.microphone.isGranted;
    if (!hasPermission) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('需要麦克风权限才能使用语音输入')),
          );
        }
        return;
      }
    }

    setState(() {
      _isRecording = true;
    });

    await _voiceService.startListening(
      onResult: (text) {
        if (mounted) {
          _messageController.text = text;
          // 光标移动到末尾
          _messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
        }
      },
    );
  }

  // 停止录音
  Future<void> _stopRecording() async {
    await _voiceService.stopListening();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.avatarUrl != null)
              CircleAvatar(
                radius: 16.w,
                backgroundImage: NetworkImage(widget.avatarUrl!),
              )
            else
              CircleAvatar(
                radius: 16.w,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                child: Text(
                  widget.title.substring(0, 1),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            SizedBox(width: 12.w),
            Text(widget.title),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // 录音状态提示
          if (_isRecording)
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              color: Colors.red.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic, color: Colors.red, size: 20),
                  SizedBox(width: 8.w),
                  const Text(
                    '正在听...',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),

          // 输入区域
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final showTime = true; // 简化逻辑，总是显示时间

    return Column(
      children: [
        if (showTime)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              message['time'],
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 18.w,
                  backgroundImage: widget.avatarUrl != null
                      ? NetworkImage(widget.avatarUrl!)
                      : null,
                  child: widget.avatarUrl == null
                      ? Text(widget.title.substring(0, 1))
                      : null,
                ),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (message['type'] == 'text')
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? AppTheme.primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message['content'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isUser ? Colors.white : AppTheme.textPrimary,
                          ),
                        ),
                      )
                    else if (message['type'] == 'image')
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            message['imageUrl'],
                            width: 200.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 200.w,
                              height: 150.h,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isUser) ...[
                SizedBox(width: 8.w),
                CircleAvatar(
                  radius: 18.w,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

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
            // 语音切换按钮
            IconButton(
              icon: Icon(
                _isVoiceInputMode ? Icons.keyboard : Icons.mic_none,
                color: AppTheme.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isVoiceInputMode = !_isVoiceInputMode;
                  if (_isVoiceInputMode) {
                    FocusScope.of(context).unfocus(); // 收起键盘
                  } else {
                    // 切换回键盘模式，自动聚焦输入框
                    Future.delayed(const Duration(milliseconds: 100), () {
                       FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                });
              },
            ),
            SizedBox(width: 8.w),

            // 输入框或按住说话按钮
            Expanded(
              child: _isVoiceInputMode
                  ? GestureDetector(
                      onLongPressStart: (_) => _startRecording(),
                      onLongPressEnd: (_) => _stopRecording(),
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? Colors.grey[300]
                              : AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: AppTheme.dividerColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _isRecording ? '松开 发送' : '按住 说话',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    )
                  : TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '输入消息...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(color: AppTheme.dividerColor),
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
            SizedBox(width: 8.w),

            // 表情按钮
            IconButton(
              icon: Icon(
                Icons.sentiment_satisfied_alt,
                color: AppTheme.textSecondary,
              ),
              onPressed: () {},
            ),

            // 发送/更多按钮
            if (_messageController.text.isNotEmpty || !_isVoiceInputMode)
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.textSecondary,
                ),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    _sendMessage();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
