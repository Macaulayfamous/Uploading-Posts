import 'package:chat_app_course/views/screens/pages/post_screen.dart';
import 'package:chat_app_course/views/screens/widgets/stories.dart';
import 'package:flutter/material.dart';

import '../widgets/users_post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Maclay Chat',
            ),
            Icon(Icons.add),
            Icon(Icons.favorite),
            Icon(Icons.share),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stories(),
            UserPosts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PostScreen();
          }));
        },
        child: Text(
          'POST',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
