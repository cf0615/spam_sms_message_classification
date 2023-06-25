// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, unused_element, unused_local_variable, sized_box_for_whitespace

import 'bin.dart';
import 'block.dart';
import 'messages.dart';
import 'package:flutter/material.dart';

import 'spam.dart';
import 'starred.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat App',
      home: Scaffold(
        body: SafeArea(
          child: MyHomePage(
            title: 'Messages',
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChatPreview> _chatPreviews = [
    ChatPreview(
      contactName: 'John Doe',
      message: 'Hello there!',
      time: '9:30 AM',
      unreadCount: 2,
      isStarred: false,
    ),
    // Add more chat previews
    ChatPreview(
      contactName: 'Jane Smith',
      message: 'How are you?',
      time: 'Yesterday',
      unreadCount: 1,
      isStarred: true,
    ),
    ChatPreview(
      contactName: 'Alex Johnson',
      message: 'See you later!',
      time: 'Monday',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Mike Wilson',
      message: 'Are you coming tonight?',
      time: 'Tuesday',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Jun Yong',
      message: 'Are you coming tonight?',
      time: 'Tuesday',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Sarah Davis',
      message: 'Just got back from vacation!',
      time: '2:15 PM',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'David Thompson',
      message: 'Have a great day!',
      time: '8:00 AM',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Olivia Taylor',
      message: 'Happy birthday!',
      time: 'Yesterday',
      unreadCount: 1,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Daniel Moore',
      message: 'Can you send me the file?',
      time: 'Wednesday',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Sophia Lewis',
      message: 'See you soon!',
      time: '3:30 PM',
      unreadCount: 0,
      isStarred: false,
    ),
    ChatPreview(
      contactName: 'Lewis',
      message: 'See you soon!',
      time: '4:30 PM',
      unreadCount: 0,
      isStarred: false,
    )
  ];

  List<bool> _selectedChats = [];

  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    _sortChatPreviews();
    _initSelectedChats();
  }

  void _sortChatPreviews() {
    _chatPreviews.sort((a, b) {
      final aTime = _parseTime(a.time);
      final bTime = _parseTime(b.time);
      return bTime.compareTo(aTime);
    });
  }

  DateTime _parseTime(String timeString) {
    final now = DateTime.now();

    if (timeString == 'Yesterday') {
      return DateTime(now.year, now.month, now.day - 1);
    } else if (timeString == 'Today') {
      return DateTime(now.year, now.month, now.day);
    } else if (timeString.contains(':')) {
      final parts = timeString.split(' ');
      final timeParts = parts[0].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = parts[1];

      var time = DateTime(now.year, now.month, now.day, hour, minute);
      if (period == 'PM') {
        time = time.add(const Duration(hours: 12));
      }

      return time;
    }

    // Handle other time formats (e.g., Monday)
    // Set the time to be in the past
    return DateTime(now.year, now.month, now.day - 7);
  }

  void _initSelectedChats() {
    _selectedChats = List<bool>.generate(_chatPreviews.length, (_) => false);
  }

  void _toggleChatSelection(int index) {
    if (!_isMenuOpen) {
      return;
    }

    setState(() {
      _selectedChats[index] = !_selectedChats[index];
    });
  }

  void _toggleChatStarred(int index) {
    setState(() {
      _chatPreviews[index] = _chatPreviews[index].copyWith(
        isStarred: !_chatPreviews[index].isStarred,
      );
    });
  }

  void _deleteSelectedChats() {
    setState(() {
      int i = _selectedChats.length - 1;
      while (i >= 0) {
        if (_selectedChats[i]) {
          _chatPreviews.removeAt(i);
          _selectedChats.removeAt(i);
        }
        i--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String pageTitle = widget.title ?? 'Messages';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF69dbe4),
        actions: [
          IconButton(
            icon: Icon(
              _isMenuOpen ? Icons.done : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 80, // Adjust the height as desired
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF69dbe4),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.message),
                    title: const Text('All Messages'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: 'All Messages')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Starred'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StarredPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: const Text('Spam'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SpamPage(), // Navigate to SpamPage
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Bin'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BinPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text('Block'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlockPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle 'Settings' menu item
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _chatPreviews.length,
        itemBuilder: (context, index) {
          final chat = _chatPreviews[index];
          final isSelected = _selectedChats[index];

          return InkWell(
            onTap: () {
              if (_isMenuOpen) {
                _toggleChatSelection(index);
              } else {
                // Handle tapping on a chat
              }
            },
            onLongPress: () {
              if (!_isMenuOpen) {
                setState(() {
                  _isMenuOpen = true;
                  _selectedChats[index] = true;
                });
              }
            },
            child: ChatPreviewTile(
              chat: chat,
              isSelected: isSelected,
              isMenuOpen: _isMenuOpen,
              onStarPressed: () {
                _toggleChatStarred(index);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _isMenuOpen
          ? BottomAppBar(
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _deleteSelectedChats,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
