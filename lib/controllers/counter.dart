import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier{
  int _counter = 0;
  int get counter => _counter;

  
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> increamentPostCount(String userId)async{
      try{
        DocumentReference userDoc = _firestore.collection('users').doc(userId);

        await FirebaseFirestore.instance.runTransaction((transaction) async{
          DocumentSnapshot snapshot = await transaction.get(userDoc);

          if(!snapshot.exists){
            throw Exception("User does not exist");
          }
          _counter  = snapshot['postCount'] ?? 0;

          transaction.update(userDoc, {'postCount':_counter + 1});
          notifyListeners();
        });

      } catch (e){
        print("Failed to update post count:$e");

      }
    }

    Future<void> decrementPostCount(String userId)async{
      try{
        DocumentReference userDoc  = _firestore.collection("users").doc(userId);

        await FirebaseFirestore.instance.runTransaction((transaction) async{
          DocumentSnapshot snapshot = await transaction.get(userDoc);
          if(!snapshot.exists){
            throw Exception('User does not exist');

          }
          _counter = snapshot['postCount'] ?? 0;

          transaction.update(userDoc, {'postCount':_counter - 1});

          notifyListeners();

        });
      } catch (e){
        print("Failed to update post count -");

      }
    }


    Future<void> refresh()async{
      await Future.delayed(Duration(seconds: 1));
      notifyListeners();
    }
  
}