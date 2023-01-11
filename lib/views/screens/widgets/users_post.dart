import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _posts =
        FirebaseFirestore.instance.collection('posts').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _posts,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 400,
            child: ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                final postsData = snapshot.data!.docs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(postsData['photoUrl']),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          postsData['fullName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: Image.network(
                        postsData['postImageUrl'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.chat_bubble_outline,
                              ),
                            ),
                            Icon(Icons.share),
                          ],
                        ),
                        Icon(
                          Icons.bookmark,
                          color: Colors.yellow,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        postsData['caption'],
                        style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 7,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
