import 'package:chopin_app/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:chopin_app/data/services/login/login_service.dart';
import 'package:chopin_app/data/services/login/model/login_request_model.dart';
import 'package:chopin_app/data/services/login/model/login_response_model.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Rx<bool> isLoading = RxBool(false);
  final Rxn<dynamic> error = Rxn<dynamic>();
  final RxBool isLogin = RxBool(true);
  final RxnString errorTexts = RxnString();

  final Rxn<LoginResponseModel> user = Rxn();

  final LoginService _loginService;

  LoginController(this._loginService);
  FirebaseAuth auth = FirebaseAuth.instance;

  Future callingLoginServiceAsync(String email, String password) async {
    //final LoginRequestModel requestModel =LoginRequestModel(username: mail, password: password);
    // if(username == "Tarik" && password == "123456"){
    //
    // }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      
      Get.offNamed(HomePage.routeName);
    } catch (e) {
      Get.snackbar(
        "Kullanıcı Hakkında",
        "Kullanıcı Mesajı",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Giriş yapılamadı.",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(e.toString(), style: TextStyle(color: Colors.white)),
      );
    }
  }
}

// late Rx<User?> _user;
// FirebaseAuth auth = FirebaseAuth.instance;

// void login(String email, password) async {}

// isLoading.call(true);
// _loginService.login(requestModel).then((user) {
//   if (user.statu == 2) isLogin.call(true);
//   if (user.statu == 1) errorTexts.value = wrongPasswordText;
//   if (user.statu == 0) errorTexts.value = noUserText;
// }).catchError((dynamic error) {
//   this.error.trigger(error);
// }).whenComplete(() {
//   isLoading.call(false);
// });

/*
import 'package:chopin_app/views/home/home_page.dart';
import 'package:chopin_app/views/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:chopin_app/data/services/login/login_service.dart';
import 'package:chopin_app/data/services/login/model/login_request_model.dart';
import 'package:chopin_app/data/services/login/model/login_response_model.dart';
import 'package:chopin_app/data/src/strings.dart';

class LoginController extends GetxController {

  static LoginController instance = Get.find();


  @override
  void onReady(){
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
  ever(_user, _initialScreen);


  }

  _initialScreen(User? user){
    if(user == null){
      print("Giriş Sayfası");
      Get.offAll(()=>LoginPage());
    }
    else{
      Get.offAll(()=>HomePage());
    }
  }

  void register(String email, password) async {




  void callingLoginService(String username, String password) {
    final LoginRequestModel requestModel =
        LoginRequestModel(username: username, password: password);
        if(username == "Tarik" && password == "123456"){
          Get.offNamed(HomePage.routeName);
        }
  }
}
 */

// isLoading.call(true);
// _loginService.login(requestModel).then((user) {
//   if (user.statu == 2) isLogin.call(true);
//   if (user.statu == 1) errorTexts.value = wrongPasswordText;
//   if (user.statu == 0) errorTexts.value = noUserText;
// }).catchError((dynamic error) {
//   this.error.trigger(error);
// }).whenComplete(() {
//   isLoading.call(false);
// });
