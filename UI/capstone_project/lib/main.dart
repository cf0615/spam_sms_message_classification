// ignore_for_file: library_private_types_in_public_api, unnecessary_string_interpolations, sized_box_for_whitespace, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'starred.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  bool _editMode = false;

  // Define a GlobalKey for the Scaffold to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _requestPermission() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasRequestedPermission =
        prefs.getBool('hasRequestedPermission') ?? false;

    if (!hasRequestedPermission) {
      final PermissionStatus permissionStatus = await Permission.sms.request();
      if (permissionStatus.isGranted) {
        prefs.setBool('hasRequestedPermission', true);
        // Permission granted, perform the necessary operations
        final messages = await _query.querySms(
          kinds: [
            SmsQueryKind.inbox,
            SmsQueryKind.sent,
          ],
          count: 30,
        );
        setState(() => _messages = messages);
      } else {
        // Permission denied, handle the case accordingly
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  List<_ChatItem> _groupMessagesBySender(List<SmsMessage> messages) {
    Map<String, List<SmsMessage>> groupedMessages = {};

    for (var message in messages) {
      var sender = message.sender ?? "Unknown";

      if (groupedMessages.containsKey(sender)) {
        groupedMessages[sender]!.add(message);
      } else {
        groupedMessages[sender] = [message];
      }
    }

    List<_ChatItem> chatItems = [];

    groupedMessages.forEach((key, value) {
      chatItems.add(_ChatItem(sender: key, messages: value, profileIcon: ''));
    });

    return chatItems;
  }

  @override
  Widget build(BuildContext context) {
    List<_ChatItem> chatItems = _groupMessagesBySender(_messages);

    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF69dbe4,
          <int, Color>{
            50: Color(0xFFE0F2F1),
            100: Color(0xFFB2DFDB),
            200: Color(0xFF80CBC4),
            300: Color(0xFF4DB6AC),
            400: Color(0xFF26A69A),
            500: Color(0xFF009688),
            600: Color(0xFF00897B),
            700: Color(0xFF00796B),
            800: Color(0xFF00695C),
            900: Color(0xFF004D40),
          },
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
        appBar: AppBar(
          title: const Text(
            'Messages',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              // Open the drawer when the menu icon is pressed
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _editMode = !_editMode;
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF69dbe4),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.mail),
                      title: const Text('All Messages'),
                      onTap: () {
                        Navigator.of(_scaffoldKey.currentContext!)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.star),
                      title: const Text('Starred'),
                      onTap: () {
                        Navigator.push(
                          _scaffoldKey
                              .currentContext!, // Add the non-null assertion operator (!)
                          MaterialPageRoute(builder: (context) {
                            return StarredPage();
                          }),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.report),
                      title: const Text('Spam'),
                      onTap: () {
                        // Handle Spam item click
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Bin'),
                      onTap: () {
                        // Handle Bin item click
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.block),
                      title: const Text('Block'),
                      onTap: () {
                        // Handle Block item click
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle Settings item click
                },
              ),
            ],
          ),
        ),

        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: chatItems.isNotEmpty
              ? _ChatListView(
                  chatItems: chatItems,
                  editMode: _editMode, // Pass the edit mode state
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button few times...',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  SmsQueryKind.sent,
                ],
                count: 30,
              );
              debugPrint('sms inbox messages: ${messages.length}');

              setState(() {
                _messages = messages;
              });
            } else {
              await Permission.sms.request();
            }
          },
          backgroundColor: const Color(0xFF69dbe4),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _ChatItem {
  final String? sender;
  final String? profileIcon;
  List<SmsMessage> messages;
  late DateTime latestMessageDate;

  _ChatItem({
    required this.sender,
    required this.profileIcon,
    required this.messages,
  }) {
    // Find the latest message date
    latestMessageDate = messages
        .map((message) => message.date ?? DateTime(0))
        .reduce((value, element) => value.isAfter(element) ? value : element);
  }
}

class _ChatListView extends StatefulWidget {
  const _ChatListView({
    Key? key,
    required this.chatItems,
    required this.editMode,
  }) : super(key: key);

  final List<_ChatItem> chatItems;
  final bool editMode;

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<_ChatListView> {
  List<bool> starredList = [];

  @override
  void initState() {
    super.initState();
    starredList = List<bool>.filled(widget.chatItems.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.chatItems.length,
      itemBuilder: (BuildContext context, int i) {
        var chatItem = widget.chatItems[i];
        var latestMessage = chatItem.messages.last;

        return ListTile(
          leading: const CircleAvatar(
            child: Icon(
              Icons.people,
              color: Colors.white,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${chatItem.sender}'),
              GestureDetector(
                onTap: () {
                  setState(() {
                    starredList[i] = !starredList[i];
                  });
                },
                child: Icon(
                  Icons.star,
                  color: starredList[i] ? Colors.grey : Colors.transparent,
                ),
              ),
              Text(
                _formatDateTime(latestMessage.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${latestMessage.body}',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ConversationPage(chatItem: chatItem),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      final formatter = DateFormat('HH:mm, MMM d');
      return formatter.format(dateTime);
    } else {
      return '';
    }
  }
}

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key, required this.chatItem}) : super(key: key);

  final _ChatItem chatItem;

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  bool isStarred = false;

  @override
  Widget build(BuildContext context) {
    final _ChatItem chatItem = widget.chatItem; // Access chatItem from widget

    return Scaffold(
      appBar: AppBar(
        title: Text(chatItem.sender ?? 'Unknown'),
        actions: [
          IconButton(
            icon: Icon(
              isStarred ? Icons.star : Icons.star_border,
              color: isStarred ? Colors.white : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isStarred = !isStarred;
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.block,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle block icon button press
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatItem.messages.length,
        itemBuilder: (BuildContext context, int index) {
          var message = chatItem.messages[index];
          bool isUserMessage = message.sender == chatItem.sender;

          return ListTile(
            title: Align(
              alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x289E9E9E), // Set the bubble color here
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${message.body ?? ''}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            subtitle: Align(
              alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                DateFormat('HH:mm').format(message.date ?? DateTime.now()),
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
