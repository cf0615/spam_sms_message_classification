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

  @override
  Widget build(BuildContext context) {
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
              // Add your menu button functionality here
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
                  messages: _messages,
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button few time...',
                    style: Theme.of(context).textTheme.headlineSmall,
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

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return ListTile(
          title: Text('${message.sender} [${message.date}]'),
          subtitle: Text('${message.body}'),
        );
      },
    );
  }
}
