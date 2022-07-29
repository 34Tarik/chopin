import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:flutter/material.dart';
import 'package:chopin_app/views/home/home_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:group_list_view/group_list_view.dart';

class CreateListFromQR extends GetWidget<HomeController> {
  const CreateListFromQR({Key? key}) : super(key: key);
  static const String routeName =
      '/views/create_list_fromQR/create_list_fromQR_page';

  @override
  Widget build(BuildContext context) {
    controller.isAppearing.listen((isAppearing) {
      print(isAppearing);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qr Kodu İle Liste Ekle"),
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
          _buildSpace(),
          Flexible(child: _buildWithCodeButton(), flex: 1),
          Flexible(child: _buildInfinitySpace(), flex: 1),
          Flexible(
            child: Container(
              child: _buildButton(),
              color: Colors.white,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    const double size = 50;
    return SizedBox(
      width: double.infinity,
      height: size,
      child: ElevatedButton(
          onPressed: () {},
          child: const Text("QR ile Liste Ekle"),
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
          )),
    );
  }

  Widget _buildWithCodeButton() {
    const double size = 50;
    return SizedBox(
      width: double.infinity,
      height: size,
      child: ElevatedButton(
          onPressed: () async {
            var data = await Clipboard.getData('text/plain');
            var key = data!.text;
            controller.addSharedListAsync(key!);
          },
          child: const Text("Kod ile Liste Ekle"),
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

  Widget _buildInfinitySpace() {
    return const SizedBox(
      height: double.infinity,
    );
  }

  Widget _buildGroupedList() {
    return Container(
      child: Obx(
        () => GroupListView(
          shrinkWrap: true,
          sectionsCount:
              controller.sharedWithMeListItems.value.keys.toList().length,
          countOfItemInSection: (int section) {
            return controller.sharedWithMeListItems.value.values
                .toList()[section]
                .length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            String listName = controller.sharedWithMeListItems.value.keys
                .toList()[index.section];
            String productName = controller.sharedWithMeListItems.value.values
                .toList()[index.section][index.index];
            return ListTile(
              title: Text(
                productName,
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                //iteme tıklanıldığında çalışır
              },
            );
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            String listName =
                controller.sharedWithMeListItems.value.keys.toList()[section];
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  color: buttonColor,
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          listName,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await controller
                              .removeListFromSharedWithMeAsync(listName);
                          await controller.getDataAsync();
                          controller.sharedWithMeListItems.refresh();
                          //   _onDeleteItemPressed(index);
                        },
                      ),
                    ],
                  )),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
            height: 1,
          ),
          sectionSeparatorBuilder: (context, section) => SizedBox(),
        ),
      ),
    );
  }
}
