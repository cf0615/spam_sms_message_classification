import 'package:flutter/material.dart';

class BlockPage extends StatefulWidget {
  final List<String> blockedUsers;
  final Function(String, bool) updateBlockedUsers;

  const BlockPage({
    Key? key,
    required this.blockedUsers,
    required this.updateBlockedUsers,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Blocked Users'),
        backgroundColor: const Color(0xFF69dbe4),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
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
                    leading: const Icon(Icons.block),
                    title: const Text('Block'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => BlockPage(
                            blockedUsers: widget.blockedUsers,
                            updateBlockedUsers: widget.updateBlockedUsers,
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
        itemCount: widget.blockedUsers.length,
        itemBuilder: (BuildContext context, int index) {
          String blockedUser = widget.blockedUsers[index];
          return ListTile(
            title: Text(blockedUser),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.updateBlockedUsers(blockedUser, false);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
