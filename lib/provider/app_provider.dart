import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_app/models/data_model.dart';
import 'package:sample_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService apiService = ApiService();
  String _errorMessage = "";
  bool isPosted = false;
  String get errorMessage => _errorMessage;

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = "The password provided is too weak.";
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = "The account already exists for that email.";
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      _errorMessage = "Error during registration: $e";
      notifyListeners();
      print("Error during registration: $e");
      return null;
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(userCredential.user.toString());
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = "No user found for that email.";
        notifyListeners();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _errorMessage = "Wrong password provided for that user.";
        notifyListeners();
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      _errorMessage = "Error during login: $e";
      notifyListeners();
      print("Error during login: $e");
      return null;
    }
    return null;
  }

  // void signOut() async {
  //   await _auth.signOut();
  // }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true; // Sign out successful
    } catch (e) {
      _errorMessage = "Error during sign out: $e";
      notifyListeners();
      print("Error during sign out: $e");
      return false; // Sign out failed
    }
  }

  Future<bool> isLogged() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  List<DataModel> _dataList = [];

  List<DataModel> get dataList => _dataList;

  List<DataModel> _postList = [];

  List<DataModel> get postList => _postList;

  Future<void> getData() async {
    try {
      final List<dynamic> jsonData = await apiService
          .fetchData('posts'); // Replace 'posts' with your API endpoint

      _dataList = jsonData.map((item) => DataModel.fromJson(item)).toList();
      notifyListeners();
      _cacheData(jsonData);
    } catch (e) {
      _errorMessage = "Error fetching data: $e";
      notifyListeners();
      print('Error fetching data: $e');
      _loadCachedData();
    }
  }

// Future<void>getPostData(data)async{
// _dataList=await apiService.createPost(data: data);
// notifyListeners();
// }

  Future<void> _cacheData(List<dynamic> jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedData', jsonEncode(jsonData));
  }

  Future<void> _loadCachedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('cachedData');
    if (cachedData != null) {
      _dataList = jsonDecode(cachedData)
          .map((item) => DataModel.fromJson(item))
          .toList();
      notifyListeners();
    }
  }
}
