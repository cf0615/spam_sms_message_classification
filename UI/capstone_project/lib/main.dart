import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      chatItems.add(_ChatItem(sender: key, messages: value));
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
                // Add your edit button functionality here
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Handle item 1 click
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Handle item 2 click
                },
              ),
              // Add more ListTile widgets for additional menu items
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: chatItems.isNotEmpty
              ? _ChatListView(
                  chatItems: chatItems,
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
  final String? sender; // Change the type to String?

  List<SmsMessage> messages;

  _ChatItem({required this.sender, required this.messages});
}

class _ChatListView extends StatelessWidget {
  const _ChatListView({
    Key? key,
    required this.chatItems,
  }) : super(key: key);

  final List<_ChatItem> chatItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chatItems.length,
      itemBuilder: (BuildContext context, int i) {
        var chatItem = chatItems[i];
        var latestMessage = chatItem.messages.last;

        return ListTile(
          leading: const CircleAvatar(
            // Add your profile icon logic here, such as fetching and displaying the sender's profile image
            child: Icon(Icons.person),
          ),
          title: Text('${chatItem.sender}'),
          subtitle: Row(
            children: [
              Text('${latestMessage.body}'),
              const SizedBox(width: 8),
              Text(
                _formatDateTime(latestMessage.date!),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('${chatItem.sender}'),
                  content: Column(
                    children: chatItem.messages.map((message) {
                      return ListTile(
                        title: Text('${message.date!}'),
                        subtitle: Text('${message.body}'),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      // Implement your formatting logic here to display the datetime in your desired format
      // You can use the intl package or other date formatting libraries
      return '${dateTime.hour}:${dateTime.minute}';
    } else {
      return '';
    }
  }
}
