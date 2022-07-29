import 'package:chopin_app/data/services/home/home_service.dart';
import 'package:chopin_app/data/services/shareable/shareable_service.dart';
import 'package:chopin_app/views/home/home_page.dart';
import 'package:chopin_app/views/shareable_List/shareable_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:chopin_app/views/info/info_controller.dart';

class InfoPage extends GetWidget<InfoController> {
  const InfoPage({Key? key}) : super(key: key);

  static const String routeName = '/views/info/info_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      appBar: AppBar(
        title: const Text(infoAppBarText),
        backgroundColor: mainColor,
      ),
      body: const Center(
        child: Text('Paylaşılan Listeler'),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _goToShareableList(),
      child: const Icon(Icons.add),
      backgroundColor: mainColor,
    );
  }

  _goToShareableList() {
    
    Get.lazyPut<ShareableService>(() => ShareableServiceImp());
    Get.toNamed(ShareableList.routeName);

  }

}