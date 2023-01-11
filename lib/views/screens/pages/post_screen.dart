import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  late String caption;

  //FUNCTION TO PICK IMAGE FROM Gallery
  postImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('Oh no ! No image picked');
    }
  }

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List im = await postImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  _uploadImageToStorage(Uint8List? image) async {
    Reference ref = _storage.ref().child('profileImages').child(Uuid().v4());

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  // postData() async {
  //   String postImageUrl = await _uploadImageToStorage(_image);

  //   await _firestore.collection('posts').doc(Uuid().v4()).set({
  //     'postImageUrl': postImageUrl,
  //     'caption': caption,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Create a Post',
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: _image != null
                            ? Image.memory(
                                _image!,
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                              )
                            : Center(
                                child: IconButton(
                                onPressed: () {
                                  selectGalleryImage();
                                },
                                icon: Icon(Icons.add),
                              )),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          caption = value;
                        },
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return 'Caption most not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Caption',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          EasyLoading.show(status: 'UPLOADING POST');
                          String postImageUrl =
                              await _uploadImageToStorage(_image);

                          await _firestore
                              .collection('posts')
                              .doc(Uuid().v4())
                              .set({
                            'postImageUrl': postImageUrl,
                            'caption': caption,
                            'fullName': data['fullName'],
                            'photoUrl': data['image'],
                            'userId': FirebaseAuth.instance.currentUser!.uid,
                          }).whenComplete(() {
                            EasyLoading.dismiss();

                            setState(() {
                              _image = null;
                              _formkey.currentState!.reset();
                            });
                          });
                        },
                        child: Text(
                          'ADD',
                          style: TextStyle(
                            letterSpacing: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
