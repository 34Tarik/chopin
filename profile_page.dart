import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:chopin_app/views/profile/profile_controller.dart';

class ProfilePage extends GetWidget<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/views/profile/profile_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(profileAppBarText),
        backgroundColor: mainColor,
      ),
      body: const Center(
        child: Text('Profil sayfası'),
      ),
    );
  }
}