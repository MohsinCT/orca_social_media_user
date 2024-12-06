
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:orca_social_media/models/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProviderState extends ChangeNotifier {
 
 final AuthRepository authRepository;
   
   User? _user;
   User? get user => _user;

  AuthProviderState({required this.authRepository}){
    authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> signInWithEmailAndPassword(String email , String password) async {
    try{
      _user = await authRepository.signInWithEmailAndPassword(email, password);
      notifyListeners();
    } catch (e){
      rethrow;
    }
  }

  Future<void> signOut() async{
  await authRepository.signOut();
  _user = null;
  notifyListeners();
}


 sharedpref(bool val)async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', val);

 }
void _onAuthStateChanged(User? user){
  _user = user;
  notifyListeners();
}

Future<Map<String , dynamic>?> getUserDetails() async{
  if(_user == null){
    return {};
  }
  return await authRepository.getUserDetails(_user!.uid);
}
}





//  String? _uid, _email;
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<bool> signInUserAccount(String email, String password) async {
//     bool success = false;
//     try {
//       UserCredential userCredential = await _auth
//           .signInWithEmailAndPassword(email: email, password: password);
//       if (userCredential != null) {
//         _uid = userCredential.user!.uid;
//         _email = userCredential.user!.email;
//         return success = true;
//       }
//     } catch (e) {
//       log('failed $e');
//     }
//     return success;
//   }

//   void signOut()async{
//      await _auth.signOut();
//   }
