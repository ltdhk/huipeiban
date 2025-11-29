import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

/// 语音服务
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool get isListening => _speechToText.isListening;

  /// 初始化语音服务
  Future<bool> init() async {
    if (_isInitialized) return true;

    try {
      // 请求麦克风权限
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          debugPrint('麦克风权限被拒绝');
          return false;
        }
      }

      _isInitialized = await _speechToText.initialize(
        onError: (error) => debugPrint('语音识别错误: $error'),
        onStatus: (status) => debugPrint('语音识别状态: $status'),
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('语音服务初始化失败: $e');
      return false;
    }
  }

  /// 开始监听
  Future<void> startListening({
    required Function(String) onResult,
    String localeId = 'zh_CN', // 默认中文
  }) async {
    if (!_isInitialized) {
      final initialized = await init();
      if (!initialized) return;
    }

    if (_speechToText.isListening) return;

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult || result.recognizedWords.isNotEmpty) {
          onResult(result.recognizedWords);
        }
      },
      localeId: localeId,
      cancelOnError: true,
      partialResults: true,
      listenMode: ListenMode.dictation,
    );
  }

  /// 停止监听
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  /// 取消监听
  Future<void> cancel() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
    }
  }
}
