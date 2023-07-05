import 'package:flutter/material.dart';
import 'package:capstone_project/block_page.dart';

class BinPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add the key to the Scaffold
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
                      Navigator.of(_scaffoldKey.currentContext!)
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
      body: Center(
        child: Text(
          'This is the Bin page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
