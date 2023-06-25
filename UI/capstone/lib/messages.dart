import 'package:flutter/material.dart';

class ChatPreview {
  final String contactName;
  final String message;
  final String time;
  final int unreadCount;
  final bool isStarred;

  ChatPreview({
    required this.contactName,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.isStarred,
  });

  ChatPreview copyWith({
    String? contactName,
    String? message,
    String? time,
    int? unreadCount,
    bool? isStarred,
  }) {
    return ChatPreview(
      contactName: contactName ?? this.contactName,
      message: message ?? this.message,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

class ChatPreviewTile extends StatelessWidget {
  final ChatPreview chat;
  final bool isSelected;
  final bool isMenuOpen;
  final VoidCallback onStarPressed;

  const ChatPreviewTile({
    Key? key,
    required this.chat,
    required this.isSelected,
    required this.isMenuOpen,
    required this.onStarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? const Color.fromARGB(56, 0, 0, 0) : null,
      leading: CircleAvatar(
        child: Text(chat.contactName.substring(0, 1)),
      ),
      title: Text(chat.contactName),
      subtitle: Text(chat.message),
      trailing: isMenuOpen
          ? IconButton(
              icon: chat.isStarred
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              onPressed: onStarPressed,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.time),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10),
                        right: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
