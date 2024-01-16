import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: buildAppBar(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => debugPrint('Tao yeu cau'),
        icon: const Icon(Icons.add),
        label: Text('Tạo yêu cầu'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ), 
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Favorites'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Comments'),
              leading: const Icon(Icons.comment),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text('Trang chủ'),
      foregroundColor: Colors.white,
      // leading: Builder(
      //   builder: (context) => IconButton(
      //     icon: Icon(Icons.menu),
      //     onPressed: (){
      //       Scaffold.of(context).openDrawer();
      //     },
      //     color: Colors.white,
      //   )
      // ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => _key.currentState?.openDrawer(), 
      ),
    );
  }
}