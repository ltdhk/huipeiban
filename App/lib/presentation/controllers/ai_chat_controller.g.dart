// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiChatControllerHash() => r'16b4b73231c40f748526c3d56baefa893b2a354a';

/// AI 聊天控制器
///
/// Copied from [AiChatController].
@ProviderFor(AiChatController)
final aiChatControllerProvider = AutoDisposeAsyncNotifierProvider<
    AiChatController, List<AiChatMessage>>.internal(
  AiChatController.new,
  name: r'aiChatControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiChatControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiChatController = AutoDisposeAsyncNotifier<List<AiChatMessage>>;
String _$aiSessionsControllerHash() =>
    r'6e0d77ef82c0c2d6de682245c50a1a1ff1ce6bf9';

/// AI 会话控制器
///
/// Copied from [AiSessionsController].
@ProviderFor(AiSessionsController)
final aiSessionsControllerProvider = AutoDisposeAsyncNotifierProvider<
    AiSessionsController, List<AiSession>>.internal(
  AiSessionsController.new,
  name: r'aiSessionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiSessionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiSessionsController = AutoDisposeAsyncNotifier<List<AiSession>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
