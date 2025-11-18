import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

/// 应用主题配置
class AppTheme {
  AppTheme._();

  /// 主色调
  static const Color primaryColor = Color(AppConstants.primaryColorValue);

  /// 渐变色起始
  static const Color gradientStart = Color(AppConstants.gradientStartColor);

  /// 渐变色结束
  static const Color gradientEnd = Color(AppConstants.gradientEndColor);

  /// 背景色
  static const Color backgroundColor = Color(0xFFF5F5F5);

  /// 卡片背景色
  static const Color cardColor = Colors.white;

  /// 文本颜色 - 主要
  static const Color textPrimary = Color(0xFF333333);

  /// 文本颜色 - 次要
  static const Color textSecondary = Color(0xFF666666);

  /// 文本颜色 - 提示
  static const Color textHint = Color(0xFF999999);

  /// 分割线颜色
  static const Color dividerColor = Color(0xFFE0E0E0);

  /// 成功色
  static const Color successColor = Color(0xFF43E97B);

  /// 警告色
  static const Color warningColor = Color(0xFFFFA940);

  /// 错误色
  static const Color errorColor = Color(0xFFFF4D4F);

  /// 信息色
  static const Color infoColor = Color(0xFF4FACFE);

  /// 主题数据
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,

      // ColorScheme
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: gradientEnd,
        surface: cardColor,
        error: errorColor,
      ),

      // AppBar 主题
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card 主题
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        hintStyle: const TextStyle(color: textHint, fontSize: 14),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // 文本按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // 底部导航栏主题 (虽然用侧边栏，但保留配置)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // 文本主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
        headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, color: textSecondary),
        labelLarge: TextStyle(fontSize: 14, color: textHint),
        labelMedium: TextStyle(fontSize: 12, color: textHint),
        labelSmall: TextStyle(fontSize: 10, color: textHint),
      ),
    );
  }

  /// 主色渐变
  static LinearGradient get primaryGradient {
    return const LinearGradient(
      colors: [gradientStart, gradientEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// 获取状态颜色
  static Color getStatusColor(String status) {
    switch (status) {
      case AppConstants.orderStatusPendingPayment:
        return warningColor;
      case AppConstants.orderStatusPendingAccept:
      case AppConstants.orderStatusPendingService:
        return infoColor;
      case AppConstants.orderStatusInService:
        return primaryColor;
      case AppConstants.orderStatusCompleted:
        return successColor;
      case AppConstants.orderStatusCancelled:
        return textSecondary;
      default:
        return textSecondary;
    }
  }

  /// 获取状态文本
  static String getStatusText(String status) {
    switch (status) {
      case AppConstants.orderStatusPendingPayment:
        return '待支付';
      case AppConstants.orderStatusPendingAccept:
        return '待接单';
      case AppConstants.orderStatusPendingService:
        return '待服务';
      case AppConstants.orderStatusInService:
        return '服务中';
      case AppConstants.orderStatusCompleted:
        return '已完成';
      case AppConstants.orderStatusCancelled:
        return '已取消';
      default:
        return '未知';
    }
  }
}
