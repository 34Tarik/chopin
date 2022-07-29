import 'dart:developer';

import 'package:chopin_app/data/services/home/home_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ShareableListController extends GetxController {

  final RxMap<String, List<String>> anaMap = Map<String, List<String>>().obs;
  final HomeService _homeService;
  final RxBool isAppearing = RxBool(false);
  
  
  ShareableListController(this._homeService);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() async{
    await getDataAsync();
    isAppearing(true);
    super.onInit();
  }

  Future deleteProductAsync (String listName, String productName) async{
    log("silinecek $listName " + " $productName");
    var mevcutListe = anaMap[listName];
    var isExisting = mevcutListe!.contains(productName);
    if (isExisting) {
      mevcutListe.remove(productName);
      anaMap[listName] = mevcutListe;
    }
    log("data =>  $anaMap");
    await  syncDataAsync();
  }

  Future syncDataAsync() async {
    var user = await auth.currentUser;
    final userId = user!.uid;
    await FirebaseFirestore.instance
        .collection('lists')
        .doc(userId)
        .set(anaMap, SetOptions(merge: true));
  }
  
  Future getDataAsync() async {
    var user = await auth.currentUser;
    final userId = user!.uid;

    var snapshot = await FirebaseFirestore.instance.collection('lists').doc(userId).get();
    var data = snapshot.data();
    
    anaMap.value = data!.map(
      (k, v) => MapEntry(
        k,
        (v as List<dynamic>).cast<String>(),
      ),
    );
    // var data = snapshot.data as Map<String, dynamic>;
  }

  Future shareListAsync(String Key) async {
     var user =  auth.currentUser;
     if(user == null) return;
     String userId = user.uid;
     String key = "lists/"+userId+"/"+Key;
     print(key);
     String shareableId = UniqueKey().hashCode.toString();

    var shareableList = {
      "id": key,
    };

    await FirebaseFirestore.instance
        .collection('shareableLists')
        .doc(shareableId)
        .set(shareableList);

    Clipboard.setData(ClipboardData(text: shareableId));

  }

  String CreateSharebleListKey(String Key) {
        var user =  auth.currentUser;
        if(user == null) throw Exception("List is null");
        String userId = user.uid;
        String key = "lists/"+userId+"/"+Key;
        return key;
  }

}