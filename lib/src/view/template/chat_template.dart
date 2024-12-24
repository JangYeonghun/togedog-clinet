import 'dart:convert';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:dog/src/model/chat_local_model.dart';
import 'package:dog/src/model/user_account.dart';
import 'package:dog/src/repository/chat_repository.dart';
import 'package:dog/src/repository/sqlite_chat_repository.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:dog/src/view/component/chat/chat_message_item.dart';
import 'package:dog/src/view/component/chat/chat_separator.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatTemplate extends StatefulWidget {
  final int roomId;
  final String roomTitle;
  final String profileImage;
  const ChatTemplate({super.key, required this.roomId, required this.roomTitle, required this.profileImage});

  @override
  State<ChatTemplate> createState() => _ChatTemplateState();
}

class _ChatTemplateState extends State<ChatTemplate> with SingleTickerProviderStateMixin {
  final TextEditingController chatController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final SQLiteChatRepository sqLiteChatRepository = SQLiteChatRepository();
  late final StompClient client;
  XFile? imageFile;
  final UserAccount userAccount = UserAccount();
  bool isExpand = false;
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  bool isHandlingPop = false;

  List<ChatMessageDTO> chats = [];
  List<ChatMessageDTO> rList = [];

  Future<void> connect() async {
    final String? accessToken = await storage.read(key: 'accessToken');

    client = StompClient(
        config: StompConfig.sockJS(
            url: "https://www.walktogedog.life/ws",
            onConnect: onConnectCallback,
            stompConnectHeaders: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            },
            webSocketConnectHeaders: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            },
            onWebSocketError: (dynamic error) => debugPrint('SOCKET_ERR: $error'),
            onStompError: (dynamic error) => debugPrint('STOMP_ERR: $error'),
            onDisconnect: (StompFrame frame) => debugPrint('DISCONN: ${frame.headers}\n${frame.body}')
        )
    );
    debugPrint('Connecting...');
    client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    debugPrint('callback');
    debugPrint('Connection: ${client.connected}, ${client.isActive}');

    try {
      client.subscribe(
          destination: '/sub/chat/room/${widget.roomId}',
          callback: (stompFrame) {
            debugPrint('Message received');
            debugPrint(stompFrame.body);
            if (stompFrame.body == null) return;

            final Map<String, dynamic> body = jsonDecode(stompFrame.body!);
            handleMessage(dto: ChatMessageDTO.fromJson(body));

            saveMessageToLocalDb(body);
          }
      );
    } catch(e) {
      debugPrint('CHAT_SUB_ERR: $e');
    }
  }

  void send() async {
    if (imageFile == null && chatController.text.isEmpty) return;

    String imageUrl = '';
    if (imageFile != null) {
      final Response response = await ChatRepository().uploadImage(image: imageFile!);
      if (response.statusCode ~/ 100 == 2) {
        imageUrl = response.body;
      }
    }

    final Map<String, dynamic> message = {
      'roomId': widget.roomId,
      'userId': userAccount.getUUID(),
      'content': chatController.text,
      'lastTime': DateTime.now().toUtc().toString(),
      'image': imageUrl
    };

    try {
      final String? accessToken = await storage.read(key: 'accessToken');

      client.send(
          headers: <String, String>{
            'Content-type' : 'application/json',
            'Authorization' : 'Bearer $accessToken'
          },
          destination: '/pub/chat',
          body: jsonEncode(message)
      );
    } catch(e) {
      debugPrint('CHAT_ERR: $e');
    }

    debugPrint('Send message');
    debugPrint(message.toString());
  }

  Future<void> saveMessageToLocalDb(Map<String, dynamic> message) async {
    try {
      final model = ChatLocalModel(
        roomId: message['roomId'],
        userId: message['userId'],
        content: message['content'],
        image: message['image'],
        timeStamp: message['lastTime'],
      );

      await sqLiteChatRepository.insertChat(model);
    } catch (e) {
      debugPrint('saveMessageToLocalDb() exception: $e');
    }
  }

  Future<void> chatContents() async {
    chats = await sqLiteChatRepository.selectChats(roomId: widget.roomId);
    setState(() {
      rList = chats;
    });
  }

  @override
  void dispose() {
    client.deactivate();
    scrollController.dispose();
    chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ChatRepository().unreadMessage(roomId: widget.roomId, lastTime: '2024-09-08 11:49:53.372360Z'/*DateTime.now().toString()*/);
    connect();
    chatContents();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  Widget msgList() {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isExpand = false;
            controller.reverse();
          });
        },
        child: Container(
          color: const Color(0xFFF2F2F2),
          alignment: Alignment.topCenter,
          child: ListView.separated(
            reverse: true,
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            padding: EdgeInsets.only(top: 10.h, left: 14.w, right: 14.w),
            itemCount: rList.length,
            itemBuilder: (context, index) {
              final ChatMessageDTO currentMessage = rList[index];
              final bool isFirst = index == rList.length - 1;

              return ChatMessageItem(
                isMine: currentMessage.userId == userAccount.getUUID(),
                currentMessage: currentMessage,
                previousMessage: isFirst ? null : rList[index + 1],
                nextMessage: index == 0 ? null : rList[index - 1],
                isFirst: isFirst,
                profileImage: widget.profileImage,
              );
            },
            separatorBuilder: (context, index) {
              final ChatMessageDTO currentMessage = rList[index];
              final ChatMessageDTO? nextMessage = rList.length - 1 != index ? rList[index + 1] : null;
              return ChatSeparator(
                currentMessage: currentMessage,
                nextMessage: nextMessage,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget inputBoxExtend() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: isExpand ? 290 : 0,
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 28.h, bottom: 28.h),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      imageFile = await ImageUtil().getImage(
                          context: context,
                          imageSource: ImageSource.gallery
                      );
                      send();
                    },
                    child: Image.asset('assets/images/photo_icon.png', width: 50.w)
                ),
                SizedBox(height: 6.h),
                Text(
                    '사진',
                    style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    )
                )
              ],
            ),
            SizedBox(width: 24.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      imageFile = await ImageUtil().getImage(
                          context: context,
                          imageSource: ImageSource.camera
                      );
                      send();
                    },
                    child: Image.asset('assets/images/camera_icon.png', width: 50.w)
                ),
                SizedBox(height: 6.h),
                Text(
                    '카메라',
                    style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  late final AnimationController controller;

  Widget inputBoxMain() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.fromLTRB(14.w, isExpand ? 12.h : 20.h, 14.w, isExpand ? 8.h : 20.h),
      color: const Color(0xFFF2F2F2),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  if (isExpand) {
                    isExpand = false;
                    controller.reverse();
                    return;
                  }

                  isExpand = true;
                  controller.forward();

                });
              },
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Transform.rotate(
                          angle: controller.value * 0.785398,
                          child: Icon(Icons.add_rounded, color: Palette.green6, size: 30.w)
                      );
                    }
                ),
              )
          ),
          SizedBox(width: 10.w),
          Flexible(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: RawScrollbar(
                  controller: scrollController,
                  radius: const Radius.circular(10),
                  thickness: 2,
                  thumbVisibility: true,
                  padding: EdgeInsets.only(top: 6.h, right: 3.w, bottom: -16.h),
                  child: TextField(
                    scrollController: scrollController,
                    controller: chatController,
                    minLines: 1,
                    maxLines: 5,
                    onTap: () {
                      setState(() {
                        isExpand = false;
                        controller.reverse();
                      });
                    },
                    decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(left: 10.w, right: 10.w, top: 11.h, bottom: 11.h),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide.none
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none
                        )
                    ),
                    cursorColor: Palette.green6,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              )
          ),
          SizedBox(width: 10.w),
          GestureDetector(
              onTap: () {
                send();
              },
              child: Image.asset('assets/images/send_button.png', width: 36.w)
          ),
        ],
      ),
    );
  }

  void handleMessage({
    required ChatMessageDTO dto
  }) {
    chats.insert(0, dto);

    rList = chats.toList();

    if (dto.userId == userAccount.getUUID()) chatController.text = '';

    setState(() {
      isExpand = false;
      controller.reverse();
    });
  }

  Widget inputBox() {

    return Column(
      children: [
        inputBoxMain(),
        inputBoxExtend()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
        appBar: PopHeader(title: widget.roomTitle, useBackButton: true),
        body: PopScope(
          canPop: false,
          onPopInvoked: (pop) {
            if (isHandlingPop) return;
            isHandlingPop = true;

            if (isExpand) {
              setState(() {
                isExpand = false;
                controller.reverse();
              });
              isHandlingPop = false;
              return;
            }

            Navigator.pop(context);
          },
          child: Column(
            children: [
              msgList(),
              inputBox()
            ],
          ),
        )
    );
  }
}