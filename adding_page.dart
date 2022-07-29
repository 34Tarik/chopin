import 'package:chopin_app/data/services/adding/adding_service.dart';
import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:chopin_app/views/adding/adding_controller.dart';
import 'package:chopin_app/views/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_list_view/group_list_view.dart';

class AddingPage extends GetWidget<AddingController> {
  static const String routeName = '/views/adding/adding_page';
  const AddingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // controller.isSave.listen((isSave){
    //   isSave ? _showMessage("Listeniz artık senkronize edilebilir.") : _showMessage(controller.infoMessage.value);
    // });
    // controller.isSynced.listen((isSynced){
    //   isSynced ? _goToHome() : _showMessage(controller.infoMessage.value);
    // });
    return Scaffold(
      appBar: AppBar(
        title: const Text(addingPageAppBarText),
        backgroundColor: mainColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Flexible(
            child: Container(child: _buildlistNameTextField()),
            flex: 1,
          ),
          _buildSpace(),
          Flexible(
            child: Container(child: _buildproductTextField()),
            flex: 1,
          ),
          _buildSpace(),
          Flexible(
            child: Container(child: _buildGroupedList()),
            flex: 6,
          ),
          _buildSpace(),
          Flexible(
            child: Container(
              child: _buildButton(),
              color: Colors.white,
            ),
            flex: 1,
          ),
          _buildSpace(),
          Flexible(
            child: Container(
              child: _syncButton(),
              color: Colors.white,
            ),
            flex: 1,
          ),

          // Flexible(child: _buildlistNameTextField(), flex: 1,),

          // Flexible(child: _buildproductTextField(), flex: 1,),

          //  Flexible(child: _buildGroupedList(), flex: 6,),

          // Flexible(child: _buildButton(), flex: 1,),

          // Flexible(child: _syncButton(), flex: 1,),
        ],
      ),
    );
  }

  Widget _buildSpace() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget _buildlistNameTextField() {
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
            hintText: "Liste Adı",
          ),
          controller: controller.listNameController,
        ),
      ),
    );
  }

  Widget _buildproductTextField() {
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
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Ürün Adı",
          ),
          controller: controller.productController,
        ),
      ),
    );
  }

  Widget _buildButton() {
    const double size = 40;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            controller.callingAddingService(
              controller.listNameController.text,
              controller.productController.text,
            );
            controller.anaMap.refresh();
            controller.isSave.value
                ? _showMessage("Listeniz artık senkronize edilebilir.")
                : _showMessage(controller.infoMessage.value);
          },
          child: const Text("Ürün Ekle"),
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
          )),
    );
  }

  Widget _syncButton() {
    const double size = 40;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            await controller.syncDataAsync();
            controller.isSynced.value
                ? _goToHome()
                : _showMessage(controller.infoMessage.value);
          },
          child: const Text("Senkronize Et"),
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
          )),
    );
  }

  Widget _buildGroupedList() {
    return Container(
      child: Obx(
        () => GroupListView(
          shrinkWrap: true,
          sectionsCount: controller.anaMap.value.keys.toList().length,
          countOfItemInSection: (int section) {
            return controller.anaMap.value.values.toList()[section].length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            String listName =
                controller.anaMap.value.keys.toList()[index.section];
            String productName = controller.anaMap.value.values
                .toList()[index.section][index.index];
            return ListTile(
              title: Text(
                productName,
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                //iteme tıklanıldığında çalışır
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await controller.deleteProductAsync(
                          listName, productName);
                      controller.anaMap.refresh();
                      //   _onDeleteItemPressed(index);
                    },
                  ),
                ],
              ),
            );
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            String listName = controller.anaMap.value.keys.toList()[section];
            return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                    color: Colors.black,
                    height: 60,
                    child: InkWell(
                      onTap: () {
                        controller.listNameController.text = listName;
                      },
                      child: Container(
                          color: buttonColor,
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              listName,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          )),
                    )));
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

  _goToHome() {
    Get.toNamed(HomePage.routeName);
  }

  _showMessage(String value) {
    Get.snackbar(
      errorTitle,
      value,
      colorText: textFieldColor,
      backgroundColor: registerButtonTextColor,
    );
  }
}
