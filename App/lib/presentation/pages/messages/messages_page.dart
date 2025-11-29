import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:characters/characters.dart';
import '../../../app/theme.dart';
import '../../../data/models/message.dart';
import '../../controllers/chat_controller.dart';
import 'chat_detail_page.dart';

/// 消息列表页
class MessagesPage extends ConsumerWidget {
  final VoidCallback onMenuTap;

  const MessagesPage({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('消息'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuTap,
          tooltip: '菜单',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(chatListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(chatListProvider.notifier).refresh(),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(message: e.toString()),
          data: (list) {
            if (list.isEmpty) {
              return const _EmptyView();
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemBuilder: (context, index) {
                final conv = list[index];
                final title = conv.otherParty?.name ?? conv.title ?? '会话';
                final subtitle = conv.lastMessage ?? '暂无消息';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(title.characters.take(1).toString()),
                  ),
                  title: Text(title),
                  subtitle: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: conv.unreadCount > 0
                      ? CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            conv.unreadCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatDetailPage(conversation: conv),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => Divider(height: 1.h),
              itemCount: list.length,
            );
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64.w, color: AppTheme.primaryColor),
          SizedBox(height: 12.h),
          Text(
            '还没有消息',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          SizedBox(height: 8.h),
          Text(message, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14.sp)),
        ],
      ),
    );
  }
}
