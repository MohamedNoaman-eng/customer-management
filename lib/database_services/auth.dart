import 'package:dcache/dcache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/models/user.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDetails _userFromFirebaseUser(User user) {
    return user != null ? UserDetails(uid: user.uid) : null;
  }

  // Stream<Admin> currentUSer() {
  //   return Stream.fromFuture(_auth.currentUser()).map(_userFromFirebaseUser);
  // }

  Stream<UserDetails> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = (await _auth.signInAnonymously());
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = (await _auth.signInWithEmailAndPassword(
          email: email, password: password));
      User user = result.user;
      userDetailId = result.user.uid;
      print("id is$userDetailId}");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result);
      User user = result.user;
      return user.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getCurrentUser() async {
    var userData = await _auth.currentUser;
    String uid = userData.uid.toString();
    return uid;
  }
}
