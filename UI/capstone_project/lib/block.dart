import 'package:flutter/material.dart';

class BlockPage extends StatelessWidget {
  const BlockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block Page'),
        backgroundColor: const Color(0xFF69dbe4),
        centerTitle: true,
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const BlockPage(),
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
      body: const Center(
        child: Text('This is the block page'),
      ),
    );
  }
}
