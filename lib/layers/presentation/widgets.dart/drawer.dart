import 'package:blog_app/layers/presentation/login/login_page.dart';
import 'package:blog_app/layers/presentation/post/add_update_post/ui/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../resources/colour_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/styles_manager.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 230, 242, 251), // Light blue
                  Color(0xFF90CAF9), // Sky blue
                  Color(0xFFBBDEFB), // Pale blue
                  Color(0xFFE3F2FD), // Very pale blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 1.0],
              ),
            ),
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              accountEmail: Text(
                'binodcoder@wlv.ac.uk',
                style: getRegularStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                ),
              ),
              margin: EdgeInsets.zero,
              accountName: Text(
                'Binod Bhandari',
                maxLines: 2,
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                ),
              ),
              currentAccountPicture: const CircleAvatar(backgroundImage: AssetImage('assets/images/image.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.add_circled,
              color: ColorManager.darkGrey,
            ),
            title: Text(
              AppStrings.addPost,
              textScaleFactor: 1.2,
              style: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const CreatePostPage(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: ColorManager.darkGrey,
            ),
            title: const Text(
              "Login",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: ColorManager.darkGrey,
            ),
            title: const Text(
              "Log out",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.building_2_fill,
              color: ColorManager.darkGrey,
            ),
            title: Text(
              "About Us",
              textScaleFactor: 1.2,
              style: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void logout() {}
}