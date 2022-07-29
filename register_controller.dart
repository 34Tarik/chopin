import 'package:chopin_app/data/services/register/model/register_request_model.dart';
import 'package:chopin_app/data/services/register/model/register_response_model.dart';
import 'package:chopin_app/data/services/register/register_service.dart';
import 'package:chopin_app/views/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController createPasswordController =
      TextEditingController();
  final TextEditingController verifyPasswordController =
      TextEditingController();

  final Rx<bool> isLoading = RxBool(false);
  final Rx<dynamic> error = Rxn<dynamic>();
  final Rx<bool> isRegister = RxBool(false);

  final Rxn<RegisterResponseModel> user = Rxn();

  final RegisterService _registerService;

  RegisterController(this._registerService);
  FirebaseAuth auth = FirebaseAuth.instance;

  Future callingRegisterServiceAsync(
      final String email, final String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Get.offNamed(HomePage.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    isLoading.call(true);
    // _registerService.register(users).then((user) {
    //   isRegister.call(true);
    // })
    // .catchError((dynamic error) {
    //   this.error.trigger(error);
    // })
    // .whenComplete((){
    //   isLoading.call(false);
    // });
  }
}
