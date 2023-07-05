// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:capstone_project/block_page.dart';

class Message {
  final String content;
  bool isDeleted;

  Message(this.content, this.isDeleted);

  void setDeleted(bool value) {
    isDeleted = value;
  }
}

class BinPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BinPage({Key? key}) : super(key: key);

  @override
  _BinPageState createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  List<Message> messages = [
    Message('Message 1', false),
    Message('Message 2', false),
    Message('Message 3', false),
    Message('Message 4', false),
  ];

  List<Message> get allMessages =>
      messages.where((message) => !message.isDeleted).toList();
  List<Message> get binMessages =>
      messages.where((message) => message.isDeleted).toList();

  void moveToBin(Message message) {
    setState(() {
      message.isDeleted = true;
    });
  }

  void restoreFromBin(Message message) {
    setState(() {
      message.isDeleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey, // Add the key to the Scaffold
      appBar: AppBar(
        title: const Text('Bin'),
        backgroundColor: const Color(0xFF69dbe4),
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
                      Navigator.of(widget._scaffoldKey.currentContext!)
                          .popUntil((route) => route.isFirst);
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
                    leading: const Icon(Icons.delete),
                    title: const Text('Block'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => BlockPage(
                            updateBlockedUsers: (String, bool) {},
                            blockedUsers: [],
                          ),
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
                // Handle Settings item click
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: binMessages.length,
        itemBuilder: (context, index) {
          final message = binMessages[index];
          return ListTile(
            title: Text(message.content),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: () => restoreFromBin(message),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteMessage(message),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void deleteMessage(Message message) {
    setState(() {
      messages.remove(message);
    });
  }
}
