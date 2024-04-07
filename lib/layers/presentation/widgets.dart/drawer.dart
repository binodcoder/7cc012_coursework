import 'package:blog_app/layers/presentation/about_us/about_us.dart';
import 'package:blog_app/layers/presentation/login/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../injection_container.dart';
import '../../../resources/colour_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
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
                sharedPreferences.getString("user_email") ?? '',
                style: getRegularStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                ),
              ),
              margin: EdgeInsets.zero,
              accountName: Text(
                sharedPreferences.getString("role") ?? '',
                maxLines: 2,
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                ),
              ),
              currentAccountPicture: const CircleAvatar(backgroundImage: AssetImage('assets/images/image.jpg')),
            ),
          ),
          sharedPreferences.getBool("login") == null
              ? ListTile(
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
                )
              : const SizedBox(),
          sharedPreferences.getBool("login") == true
              ? ListTile(
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
                  onTap: () {
                    sharedPreferences.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                )
              : const SizedBox(),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const About(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void logout() {}
}
