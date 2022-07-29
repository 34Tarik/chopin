import 'package:chopin_app/data/services/adding/adding_service.dart';
import 'package:chopin_app/data/services/shareable/shareable_service.dart';
import 'package:chopin_app/views/create_list_fromQR/create_list_fromQR_page.dart';
import 'package:chopin_app/views/shareable_List/shareable_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopin_app/data/src/colors.dart';
import 'package:chopin_app/data/src/images.dart';
import 'package:chopin_app/data/src/strings.dart';
import 'package:chopin_app/views/adding/adding_page.dart';
import 'package:chopin_app/views/home/home_controller.dart';
import 'package:chopin_app/views/info/info_page.dart';
import 'package:chopin_app/views/login/login_page.dart';
import 'package:chopin_app/views/profile/profile_page.dart';
import 'package:group_list_view/group_list_view.dart';

class HomePage extends GetWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/views/home/home_page';

  @override
  Widget build(BuildContext context) {
    controller.isAppearing.listen((isAppearing) {
      print(isAppearing);
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text(homeAppBarText),
          backgroundColor: mainColor,
        ),
        drawer: _buildDrawer(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton());
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _goToAddingPage(),
      child: const Icon(Icons.add),
      backgroundColor: mainColor,
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
          _buildSpace(),
          _buildSpace(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildTitle(homeAppBarText, Icons.home, _goToBack),
          const Divider(),
          _buildTitle(profileText, Icons.person, _goToProfile),
          const Divider(),
          _buildTitle(infoText, Icons.share, _goToInfo),
          const Divider(),
          _buildTitle(createListFromQRText, Icons.qr_code, _goToCreateListFromQR),
          const Divider(),
          _buildTitle(logoutText, Icons.logout, _goToLogout),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      accountName: Text('Tarık'),
      accountEmail: Text('180403013@ogr.gelisim.edu.tr'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage(chopinLogo),
        backgroundColor: buttonColor,
      ),
      decoration: BoxDecoration(color: buttonColor),
    );
  }

  Widget _buildTitle(String text, IconData, Function function) {
    return ListTile(
      title: Text(text),
      leading: Icon(
        IconData,
        color: mainColor,
      ),
      onTap: () => function(),
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
                          Icons.share,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await controller.shareListAsync(listName);
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

  Widget _buildSpace() {
    return const SizedBox(
      height: 20,
    );
  }

  void _goToBack() {
    Get.back();
  }

  void _goToProfile() {
    Get.toNamed(ProfilePage.routeName);
  }

  void _goToInfo() {
    Get.lazyPut<ShareableService>(() => ShareableServiceImp());
    Get.toNamed(ShareableList.routeName);
  }

  void _goToCreateListFromQR() {
    Get.lazyPut<ShareableService>(() => ShareableServiceImp());
    Get.toNamed(CreateListFromQR.routeName);
  }

  void _goToLogout() {
    Get.offNamedUntil(LoginPage.routeName, (route) => false);
  }

  void _goToAddingPage() {
    Get.lazyPut<AddingService>(() => AddingServiceImp());
    Get.toNamed(AddingPage.routeName);
  }

  void _errorDialog() {
    Get.snackbar(
      errorTitle,
      errorDescription,
      colorText: buttonColor,
      backgroundColor: errorColor,
    );
  }
}
