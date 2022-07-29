import 'dart:developer';
import 'package:chopin_app/data/services/adding/adding_service.dart';
import 'package:chopin_app/data/services/adding/model/adding_model.dart';
import 'package:chopin_app/data/services/home/home_service.dart';
import 'package:chopin_app/main.dart';
import 'package:chopin_app/views/home/home_controller.dart';
import 'package:chopin_app/views/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddingController extends GetxController {
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final RxMap<String, List<String>> anaMap = Map<String, List<String>>().obs;

  final RxBool isSave = RxBool(false);
  final AddingService _addingService;
  final RxString infoMessage = RxString("");
  final RxBool isSynced = RxBool(false);


  AddingController(this._addingService);

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() async {
    await getDataAsync();
    super.onInit();
  }

  @override
  void onClose() {
    Get.lazyPut(()=>HomePage());
    
    Get.find<HomeController>().update();
    super.onInit();
  }

  void callingAddingService(String listName, String productName) {
    final AddingModel addingRequestModel = AddingModel(
      listName: listName,
      productName: productName,
    );

    if(listName=="" || productName == "") return;

    if (anaMap.isNotEmpty) {
      var mevcutListe = anaMap[listName];
      if (mevcutListe == null) {
        // eğer bu ada sahip bir liste yoksa
        createNewList(listName, productName);
        isSave.call(true);
      } else {
        //Eğer bu ada sahip bir liste varsa
        var isExisting = mevcutListe.contains(productName);
        if (!isExisting) {
          mevcutListe.add(productName);
          anaMap[listName] = mevcutListe;
          isSave.call(true);
        } else {
          infoMessage.value="Bu ürün zaten var."; 
          isSave.call(false);
          
        }
      }
    } else {
      createNewList(listName, productName);
    }

    //bu ada sahip liste var mı?
    //varsa mevcut listeye ekle
    //yoksa yeni liste oluştur ve "lists"'e ekle

    //bu item bu listede var mı?
    //yoksa ekle
    //varsa hiç bir şey yapma

    // isLoading.call(true);
    // _addingService.adding(addingRequestModel).then(
    //   (note) {
    //     if (note.statu) isSave.call(true);
    //   },
    // ).catchError((dynamic error) {
    //   this.error.trigger(error);
    // }).whenComplete(
    //   () {
    //     isLoading.call(false);
    //   },
    // );
    log("data =>  $anaMap");
    
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
    await syncDataAsync();
  }

  void createNewList(String listName, String productName) {
    List<String> miniliste = [];
    miniliste.add(productName);
    anaMap[listName] = miniliste;
  }

  Future syncDataAsync() async {
    var user = await auth.currentUser;
    final userId = user?.uid;
    await FirebaseFirestore.instance
        .collection('lists')
        .doc(userId)
        .set(anaMap, SetOptions(merge: true))
        .then((value) => isSynced.call(true))
        .catchError((value) { 
          infoMessage.value = value;
          isSynced.call(false);
          
        });
        
        
  }

  Future getDataAsync() async {
    var user = await auth.currentUser;
    final userId = user?.uid;

    var snapshot = await FirebaseFirestore.instance.collection('lists').doc(userId).get();
    var data = snapshot.data();
    
    if(data == null) return;

    anaMap.value = data.map(
      (k, v) => MapEntry(
        k,
        (v as List<dynamic>).cast<String>(),
      ),
    );





    // var data = snapshot.data as Map<String, dynamic>;
  }
}
