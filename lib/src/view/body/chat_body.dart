import 'dart:convert';

import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_room_dto.dart';
import 'package:dog/src/repository/chat_repository.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/view/component/chat/chat_room_list_item.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final ChatRepository chatRepository = ChatRepository();
  late final Future<List<ChatRoomDto>> fetchChatList;

  Future<List<ChatRoomDto>> getChatList() async {
    final Response response = await chatRepository.chatList();
    final List<dynamic> list = jsonDecode(response.body);
    return list.map((e) => ChatRoomDto.fromJson(e)).toList();
  }

  @override
  void initState() {
    fetchChatList = getChatList();
    super.initState();
  }

  Widget emptyChat() {
    return Center(
      child: Text(
        '아직 받은 메시지가 없어요',
        style: TextStyle(
            color: Palette.darkFont2,
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget chatListBuilder() {
    return FutureBuilder(
      future: fetchChatList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingUtil();
        }

        if (!snapshot.hasData || snapshot.data.isEmpty) {
          return emptyChat();
        }

        final List<ChatRoomDto> chatListData = snapshot.data;

        return ListView.builder(
            itemCount: chatListData.length,
            itemBuilder: (context, index) {
              return ChatRoomListItem(chatRoomDto: chatListData[index]);
            }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '채팅', useBackButton: true),
      body: chatListBuilder()
    );
  }
}
