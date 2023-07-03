// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class StarredPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StarredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Set the key for the scaffold
      appBar: AppBar(
        title:
            const Text('Starred Page', style: TextStyle(color: Colors.white)),
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.star,
                    ),
                    title: const Text('Starred'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      // Handle starred item click here
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: const Text('Spam'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      // Handle spam item click here
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Bin'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      // Handle bin item click here
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text('Block'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      // Handle block item click here
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle settings item click here
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Starred Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
