import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/storage_service.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/layouts/main_layout.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/pages/payment/payment_success_page.dart';
import 'presentation/pages/payment/booking_success_page.dart';
import 'presentation/pages/profile/patients_page.dart';
import 'presentation/pages/profile/favorites_page.dart';
import 'presentation/pages/profile/help_page.dart';
import 'presentation/pages/profile/about_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await StorageService().init();

  runApp(
    const ProviderScope(
      child: CareLinkApp(),
    ),
  );
}

class CareLinkApp extends StatelessWidget {
  const CareLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X 设计稿尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appNameCN,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const MainLayout(),
            '/patients': (context) => const PatientsPage(),
            '/favorites': (context) => const FavoritesPage(),
            '/help': (context) => const HelpPage(),
            '/about': (context) => const AboutPage(),
          },
          onGenerateRoute: (settings) {
            // 处理带参数的路由
            if (settings.name == '/') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => AppInitializer(orderCardData: args),
              );
            }
            if (settings.name == '/payment-success') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => PaymentSuccessPage(
                  orderNo: args?['orderNo'] ?? '',
                  amount: args?['amount'] ?? 0.0,
                  paymentMethod: args?['paymentMethod'] ?? 'wechat',
                  orderDetails: args?['orderDetails'] as Map<String, dynamic>?,
                ),
              );
            }
            if (settings.name == '/booking-success') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => BookingSuccessPage(
                  orderId: args?['orderId'] as int?,
                  orderNo: args?['orderNo'] ?? '',
                  amount: args?['amount'] ?? 0.0,
                  orderDetails: args?['orderDetails'] as Map<String, dynamic>?,
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}

/// 应用初始化器 - 检查登录状态
class AppInitializer extends ConsumerWidget {
  final Map<String, dynamic>? orderCardData;

  const AppInitializer({super.key, this.orderCardData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // 已登录，显示主页，传递订单卡片数据
          return MainLayout(arguments: orderCardData);
        } else {
          // 未登录，显示登录页
          return const LoginPage();
        }
      },
      loading: () => const SplashScreen(),
      error: (error, stack) => const LoginPage(),
    );
  }
}

/// 启动页 - 临时占位
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo 占位
              Icon(
                Icons.medical_services_rounded,
                size: 100.w,
                color: Colors.white,
              ),
              SizedBox(height: 24.h),
              Text(
                AppConstants.appNameCN,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '智能陪诊，贴心服务',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
