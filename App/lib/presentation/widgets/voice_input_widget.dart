import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

/// 语音输入组件
///
/// 提供长按录音、实时显示录音状态、上滑取消等功能
class VoiceInputWidget extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;
  final bool isListening;
  final String recognizedText;

  const VoiceInputWidget({
    super.key,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
    this.isListening = false,
    this.recognizedText = '',
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressing = false;
  bool _isCancelling = false;
  double _dragOffset = 0;
  Timer? _durationTimer;
  int _recordingSeconds = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isPressing = true;
      _isCancelling = false;
      _dragOffset = 0;
      _recordingSeconds = 0;
    });

    widget.onStart();

    // 开始计时
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });

      // 60秒自动停止
      if (_recordingSeconds >= 60) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    _durationTimer?.cancel();

    if (_isCancelling) {
      widget.onCancel();
    } else {
      widget.onStop();
    }

    setState(() {
      _isPressing = false;
      _isCancelling = false;
      _dragOffset = 0;
      _recordingSeconds = 0;
    });
  }

  void _onVerticalDragUpdate(LongPressMoveUpdateDetails details) {
    setState(() {
      _dragOffset += details.offsetFromOrigin.dy;

      // 上滑超过 80 像素进入取消状态
      if (_dragOffset < -80) {
        _isCancelling = true;
      } else {
        _isCancelling = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopRecording(),
      onLongPressMoveUpdate: _onVerticalDragUpdate,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          gradient: _isPressing
              ? LinearGradient(
                  colors: [
                    Colors.red.shade400,
                    Colors.red.shade600,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (_isPressing ? Colors.red : Theme.of(context).primaryColor)
                  .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 动画波纹效果
            if (_isPressing)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    width: 48.w * (1 + _animationController.value * 0.5),
                    height: 48.w * (1 + _animationController.value * 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 1 - _animationController.value),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),

            // 麦克风图标
            Icon(
              _isPressing ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}

/// 录音状态覆盖层
///
/// 显示在屏幕中央,展示录音时长、识别文字和取消提示
class VoiceRecordingOverlay extends StatelessWidget {
  final bool isListening;
  final bool isCancelling;
  final int recordingSeconds;
  final String recognizedText;

  const VoiceRecordingOverlay({
    super.key,
    required this.isListening,
    this.isCancelling = false,
    this.recordingSeconds = 0,
    this.recognizedText = '',
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!isListening) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 280.w,
                margin: EdgeInsets.symmetric(vertical: 24.h),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 状态指示
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: isCancelling
                            ? Colors.red.shade100
                            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCancelling ? Icons.close : Icons.mic,
                        size: 40.w,
                        color: isCancelling ? Colors.red : Theme.of(context).primaryColor,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // 状态文字
                    Text(
                      isCancelling ? '松开取消发送' : '正在识别...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isCancelling ? Colors.red : Colors.black87,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // 录音时长
                    Text(
                      _formatDuration(recordingSeconds),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    // 识别的文字
                    if (recognizedText.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          recognizedText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],

                    SizedBox(height: 16.h),

                    // 提示文字
                    Text(
                      isCancelling ? '上滑取消' : '上滑可取消',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
