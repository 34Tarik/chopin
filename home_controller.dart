import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:chopin_app/data/services/home/home_service.dart';

class HomeController extends GetxController {
  final RxMap<String, List<String>> anaMap = Map<String, List<String>>().obs;
  final RxMap<String, List<String>> sharedWithMeList =
      Map<String, List<String>>().obs;
  final RxMap<String, List<String>> sharedWithMeListItems =
      Map<String, List<String>>().obs;

  final HomeService _homeService;
  final RxBool isAppearing = RxBool(false);
  final RxMap<String, String> shareableList = Map<String, String>().obs;

  HomeController(this._homeService);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() async {
    await getDataAsync();
    isAppearing(true);
    super.onInit();
  }

  Future deleteProductAsync(String listName, String productName) async {
    log("silinecek $listName " + " $productName");
    var mevcutListe = anaMap[listName];
    var isExisting = mevcutListe!.contains(productName);
    if (isExisting) {
      mevcutListe.remove(productName);
      anaMap[listName] = mevcutListe;
    }
    log("data =>  $anaMap");
    await syncDataAsync();
  }

  Future deleteFromShareableListAsync(String key) async{
    var user = await auth.currentUser;
    final userId = user!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sharedList")
        .doc(key)
        .delete();

  }



  Future syncDataAsync() async {
    var user = await auth.currentUser;
    final userId = user!.uid;
    await FirebaseFirestore.instance
        .collection('lists')
        .doc(userId)
        .set(anaMap, SetOptions(merge: true));
  }

  List list = [];
  Future getDataAsync() async {
    var user = await auth.currentUser;
    final userId = user!.uid;

    var snapshot =
        await FirebaseFirestore.instance.collection('lists').doc(userId).get();
    var data = snapshot.data();

    anaMap.value = data!.map(
      (k, v) => MapEntry(
        k,
        (v as List<dynamic>).cast<String>(),
      ),
    );

    final listsMap = [];
    var sharedWithMeSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sharedWithMeLists")
        .get();
    var sharedWithMeData = sharedWithMeSnapshot.docs;
    for (var sharedDoc in sharedWithMeData) {
      var data = sharedDoc.data();
      for (var dataKey in data.values) {
        listsMap.add(dataKey);
      }

      //  shareableList.value = data.map(
      //  (k, v) => MapEntry(
      //    v.split("/").last,
      //    (v as String),
      //  ),

    }

    final map = new Map<String, List<String>>();
    for (String sharedListLink in listsMap) {
      var keys = sharedListLink.split("/");
      var snapshot = await FirebaseFirestore.instance
          .collection(keys[0])
          .doc(keys[1])
          .get();
      var thisData = snapshot
          .data()!
          .entries
          .firstWhere((element) => element.key == keys[2]);
      map[thisData.key] =
          (thisData.value as List<dynamic>).cast<String>().toList();
    }
    sharedWithMeListItems.value = map;

    anaMap.value = data!.map(
      (k, v) => MapEntry(
        k,
        (v as List<dynamic>).cast<String>(),
      ),
    );

    final mapForQR = new Map<String, String>();
    var sharedSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sharedList")
        .get();
    var sharedData = sharedSnapshot.docs;

    for (var sharedDoc in sharedData) {
      var data = sharedDoc.data();

      var link = data.values.toList().first;
      var key = link.split("/").last;
      List<String> links = link.split("/").toList();
      var entry = {
        "key": links,
      };
      mapForQR.update(
        key,
        (existingValue) => link,
        ifAbsent: () => link,
      );

      var b = 8;
      // mapForQR.addEntries(data[0].) = data.map(
      // (k, v) => MapEntry(
      //   v,
      //   (v as String),
      // ),

    }
    shareableList.value = mapForQR!.map(
      (k, v) => MapEntry(
        k,
        v,
      ),
    );

    var t = 7;
    // var data = snapshot.data as Map<String, dynamic>;
  }

  Future removeListFromSharedWithMeAsync(String Key) async{
    var user = await auth.currentUser;
    String userId = user!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sharedWithMeLists")
        .doc(Key)
        .delete();
  }

  Future shareListAsync(String Key) async {
    String key = CreateSharebleListKey(Key);
    print(key);

    var user = await auth.currentUser;
    String userId = user!.uid;

    String shareableId = Key;

    var shareableList = {
      "id": key,
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sharedList")
        .doc(shareableId)
        .set(shareableList);

    Clipboard.setData(ClipboardData(text: shareableId));
  }

  Future addSharedListAsync(String Key) async {
    if (Key == null) return;

    var user = await auth.currentUser;
    String userId = user!.uid;

    var id = Key.split("/").last;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sharedWithMeLists")
        .doc(id)
        .set({"link": Key});
  }

  String CreateSharebleListKey(String Key) {
    var user = auth.currentUser;
    if (user == null) throw Exception("List is null");
    String userId = user.uid;
    String key = "lists/" + userId + "/" + Key;
    return key;
  }
}
