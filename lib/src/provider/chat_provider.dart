import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProvider extends StateNotifier<List<ChatMessageDTO>> {
  ChatProvider() : super([]);

  void add({required ChatMessageDTO dto}) {
    state.insert(0, dto);
  }
}

final chatProvider = StateNotifierProvider<ChatProvider, List<ChatMessageDTO>>((ref) {
  return ChatProvider();
});