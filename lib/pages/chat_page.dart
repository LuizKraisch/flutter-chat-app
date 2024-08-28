import 'package:chat_app/components/chat_text_field.dart';
import 'package:chat_app/helpers/date_helper.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final DateHelper _dateHelper = DateHelper();

  FocusNode chatFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    chatFocusNode.addListener(() {
      if (chatFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    chatFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        title: Text(
          widget.receiverEmail,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: _buildMessageList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 30.0),
            child: _buildUserInput(context),
          )
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading...");
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 0.0),
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(context, doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isCurrentUser
                ? Theme.of(context).colorScheme.tertiary.withOpacity(0.3)
                : Theme.of(context).colorScheme.secondary,
          ),
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                data["message"],
                textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                _dateHelper.formatDatetime(data["timestamp"].toDate()),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: isCurrentUser
                        ? Theme.of(context).colorScheme.tertiaryContainer
                        : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChatTextField(
            controller: _messageController,
            hintText: "type a message",
            obscureText: false,
            focusNode: chatFocusNode,
          ),
        ),
        const SizedBox(width: 5.0),
        IconButton(
          onPressed: sendMessage,
          icon: Icon(
            Icons.arrow_upward,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
