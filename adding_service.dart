
abstract class AddingService {
  Future getAdding();
  Future deleteAdding();
  Future addAdding();
}

class AddingServiceImp extends AddingService {
  @override
  Future getAdding() async {
    const String collectionPath = "users/"+"123456789/"+"lists";

    //await FirebaseFirestore.instance.collection(collectionPath).set({"profileName": "Tarık",});
  }

  @override
  Future deleteAdding() async {
    const String collectionPath = "users/"+"123456789/"+"lists";

    //await FirebaseFirestore.instance.collection(collectionPath).set({"profileName": "Tarık",});
 
  }

  @override
  Future addAdding() async {
    
    const String collectionPath = "users/"+"123456789/"+"lists";

    //await FirebaseFirestore.instance.collection(collectionPath).set({"profileName": "Tarık",});

  }
}
