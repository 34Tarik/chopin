import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:chopin_app/views/login/login_page.dart';
import 'package:chopin_app/views/register/register_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends GetWidget<RegisterController> {
  static const String routeName = '/views/register/register_page';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();


    controller.isRegister.listen((isRegister){
      if(isRegister) _goToLogin();
    });

    controller.error.listen((error)=> errorDialog());


    return Scaffold(
      appBar: AppBar(
        title: const Text(registerAppBarText),
        backgroundColor: mainColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSpace(),            
            _buildEmailTextField(),
            _buildSpace(),
            _buildCreatePasswordTextField(),
            _buildSpace(),
            _buildButton(),
            _buildSpace(),
            _goBackButton()
          ],
        ),
      ),
    );
  }

  

  Widget _buildEmailTextField() {
    return Material(
      elevation: 10,
      color: textFieldColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 8, 2),
        child: TextField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: emailText,
          ),
          controller: controller.emailController,
        ),
      ),
    );
  }

  Widget _buildCreatePasswordTextField() {
    return Material(
      elevation: 10,
      color: textFieldColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 8, 2),
        child: TextField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: createPasswordText,
          ),
          controller: controller.createPasswordController,
        ),
      ),
    );
  }

  

  Widget _buildButton() {
    const double size = 40;
    return GestureDetector(
      onTap: ()async {
        await controller.callingRegisterServiceAsync(controller.emailController.text, controller.createPasswordController.text);
      },
      child: SizedBox(
        height: size,
        child: ElevatedButton(
            onPressed: () => _onTap(),
            child: const Text(registerButton),
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
            )),
      ),
    );
  }

  Widget _goBackButton() {
    const double size = 40;
    return SizedBox(
      height: size,
      child: ElevatedButton(
          onPressed: () => _onTap(_goToLogin()),
            child: const Text(goBackButtonText),
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              
          )),
    );
  }

  void _onTap([void goToLogin]) {
    controller.callingRegisterServiceAsync(
        
        controller.emailController.text,
        controller.createPasswordController.text,
    );
  }

  Widget _buildSpace() {
    return const SizedBox(
      height: 25,
    );
  }

  void _goToLogin(){
    Get.toNamed(LoginPage.routeName);
  }

  void errorDialog(){
    Get.snackbar(errorTitle, errorDescription, colorText: buttonColor, backgroundColor: errorColor,);
  }

}


class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  FirebaseFirestore firestore = FirebaseFirestore.instance;


   final FocusNode _uidFocusNode = FocusNode();
   Future<FirebaseApp> _initializeFirebase() async{
     FirebaseApp firebaseApp = await Firebase.initializeApp();
     return firebaseApp;
   }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Ouch! Bir şeyler ters gitti");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Belge Bulunamadı");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return const Text("Yükleniyor");
      },
    );
  }
}
