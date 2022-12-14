import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/images.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:chopin_app/views/home/home_page.dart';
import 'package:chopin_app/views/login/login_controller.dart';
import 'package:chopin_app/views/register/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends GetWidget<LoginController> {
  static const String routeName = '/views/login/login_page';

  LoginPage({Key? key}) : super(key: key);
  @override
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FocusNode _uidFocusNode = FocusNode();
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    controller.error.listen((error) => _errorDialog);
    controller.isLogin.listen((isLogin) {
      if (isLogin) _goToHomePage();
    });
    controller.errorTexts.listen((errorTexts) {
      if (errorTexts != null) _errorTextsDialog(errorTexts);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(loginAppBarText),
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
            _buildImage(),
            _buildMaxSpace(),
            _buildSpace(),
            _buildUsernameTextField(),
            _buildSpace(),
            _buildPasswordTextField(),
            _buildSpace(),
            _buildButton(),
            _buildSpace(),
            _buildRegisterText(),
            _buildSpace(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      chopinLogo,
      height: Get.height * .3,
    );
  }

  Widget _buildUsernameTextField() {
    return Material(
      elevation: 10,
      color: textFieldColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(300),
          bottomLeft: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 8, 2),
        child: TextField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: usernameText,
          ),
          controller: controller.usernameController,
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Material(
      elevation: 10,
      color: textFieldColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(300),
          topLeft: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 8, 2),
        child: TextField(
          obscureText: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: passwordText,
          ),
          controller: controller.passwordController,
        ),
      ),
    );
  }

  Widget _buildButton() {
    const double size = 40;
    return SizedBox(
      height: size,
      child: ElevatedButton(
          onPressed: ()async {
            await controller.callingLoginServiceAsync(
              controller.usernameController.text,
              controller.passwordController.text,
            );
          },
          child: const Text(loginButton),
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
          )),
    );
  }

  Widget _buildSpace() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _buildMaxSpace() {
    return const SizedBox(
      height: 40,
    );
  }

  Widget _buildRegisterText() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: registerQuestionText,
            style: TextStyle(
                fontWeight: FontWeight.w400, color: registerQuestionTextColor),
          ),
          TextSpan(
              text: registerButtonText,
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: registerButtonTextColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.offNamed(RegisterPage.routeName);
                }),
        ],
      ),
    );
  }
}

void _goToHomePage() {
  Get.offAndToNamed(HomePage.routeName);
}

void _errorDialog() {
  Get.snackbar(
    errorTitle,
    errorDescription,
    colorText: buttonColor,
    backgroundColor: errorColor,
  );
}

void _emptyDialog() {
  Get.snackbar(
    errorTitle,
    emptyText,
    colorText: buttonColor,
    backgroundColor: errorColor,
  );
}

void _errorTextsDialog(String description) {
  Get.snackbar(
    errorTitle,
    description,
    colorText: buttonColor,
    backgroundColor: errorColor,
  );
}
