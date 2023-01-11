import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  _uploadImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('profileImages').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  //FUNCTION TO PICK IMAGE FROM Gallery

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('Oh no ! No image picked');
    }
  }

  Future<String> signUpUSers(
      String email, String fullName, String password, Uint8List? image) async {
    String res = 'some error occured';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // / CREATING  IN FIREBASE AUTH USER
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profileImage = await _uploadImageToStorage(image);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'emailAdress': email,
          'fullName': fullName,
          'buyerUid': cred.user!.uid,
          'address': '',
          'image': profileImage
        });
        res = 'success';

        print(cred.user!.email);
      } else {
        res = 'please fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> loginUsers(String email, String password) async {
    String res = 'some error occured';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        //LOGGING IN THE CURRENT USER

        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'logged in';
      } else {
        res = 'Please Fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // logout() async {
  //   await _auth.signOut();
  // }
}
