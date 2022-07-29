import 'package:cloud_firestore/cloud_firestore.dart';

class AddingModel {
  final String listName;
  final String productName;

  AddingModel({  
    required this.listName,
    required this.productName,  
  });


  Map<String,dynamic> toMap(){
    return {
      'listName' : listName,
      'productName' : productName,
    };
  }

 AddingModel.fromFirestore(Map<String, dynamic> firestore)
      : listName = firestore['listName'],
        productName = firestore['productName'];
}

class DynamicList{
  List<String> _list = [];
  DynamicList(this._list);
  List get list => _list;
}

