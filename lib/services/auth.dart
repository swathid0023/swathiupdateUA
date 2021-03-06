import 'package:firebase_auth/firebase_auth.dart';
import 'package:secure/models/user.dart';
import 'package:secure/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user obj based on FirebaseUser
  User _userFromFirbaseUser(FirebaseUser user){
    return user!=null ? User(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirbaseUser);
  }

  // Sign in Anon
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirbaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign in with Email & Password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirbaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Register with Email & Password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // Create a new user document
      await DatabaseService(uid: user.uid).updateUserData('first', 'last');
      return _userFromFirbaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}