import 'dart:ui';

import 'package:chopin_app/views/home/home_controller.dart';
import 'package:chopin_app/views/shareable_List/shareable_list_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareableList extends GetWidget<HomeController> {
  const ShareableList({Key? key}) : super(key: key);
  static double pageHeight = -1;
  static const String routeName = '/views/shareable_List/shareable_list';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    pageHeight = MediaQuery.of(context).size.height;
    controller.isAppearing.listen((isAppearing) {
      print(isAppearing);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(infoText),
        backgroundColor: mainColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: _buildGroupedList(),
            flex: 7,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList() {
    return Container(
      child: Obx(
        () => ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: controller.shareableList.value.keys.toList().length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = controller.shareableList.value.keys.toList()[index];

            return GestureDetector(
              child: Container(
                  height: pageHeight,
                  child: Column(
                    children: [
                      SizedBox(
                        height: pageHeight * 0.25,
                      ),
                      Text(item),
                      QrImage(
                        data: controller.CreateSharebleListKey(item),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await controller.deleteFromShareableListAsync(item);
                          await controller.getDataAsync();
                          controller.shareableList.refresh();
                          //   _onDeleteItemPressed(index);
                        },
                      ),
                      SizedBox(
                        height: pageHeight * 0.25,
                      ),
                    ],
                  )),
              onTap: () {
                Clipboard.setData(ClipboardData(
                    text: controller.CreateSharebleListKey(item)));
                _showMessage(item + " " + "listesi kopyalandı", "Tebrikler!");
              },
            );
          },
        ),
      ),
    );
  }

  _showMessage(String value, String title) {
    Get.snackbar(
      title,
      value,
      colorText: textFieldColor,
      backgroundColor: registerButtonTextColor,
    );
  }

  Widget _buildSpace() {
    return const SizedBox(
      height: 20,
    );
  }
}
