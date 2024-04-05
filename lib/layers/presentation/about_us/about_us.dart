import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../resources/colour_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import 'aboutus_contact.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = AppStrings.email;
    Size size = MediaQuery.of(context).size;
    GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blueGrey[900],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottomSheet: SizedBox(
            width: double.infinity,
            child: Container(
              color: ColorManager.primary,
              padding: const EdgeInsets.only(top: 3.0, bottom: 5.0),
              height: 20,
              child: const Text(
                AppStrings.poweredBybinodcoder,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )),
        key: scaffoldState,
        backgroundColor: ColorManager.white,
        //  drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.1,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  SizedBox(
                    height: AppHeight.h10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.softwareCompany,
                      style: getBoldStyle(
                        fontSize: FontSize.s17,
                        color: ColorManager.middleBlue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppHeight.h6,
                  ),
                  SizedBox(
                    height: AppHeight.h10,
                  ),
                  AboutUsContact(
                    onTap: () => launch('https://binodcoder.github.io/binodcoder/'),
                    icon: FontAwesomeIcons.internetExplorer,
                    contactName: AppStrings.website,
                    iconColor: ColorManager.lightBlue,
                  ),
                  AboutUsContact(
                    onTap: () => launch('tel: 014168260'),
                    icon: FontAwesomeIcons.phone,
                    contactName: '014168260',
                    iconColor: ColorManager.blue,
                  ),
                  AboutUsContact(
                    onTap: () => launch("https://www.youtube.com/@webbooksupport8470"),
                    icon: FontAwesomeIcons.youtube,
                    contactName: AppStrings.youtube,
                    iconColor: ColorManager.red,
                  ),
                  AboutUsContact(
                    onTap: () => launch('mailto:$email'),
                    icon: Icons.mail,
                    contactName: email,
                    iconColor: ColorManager.green,
                  ),
                  AboutUsContact(
                    onTap: () => launch('https://www.facebook.com/webbooksoftware'),
                    icon: FontAwesomeIcons.facebook,
                    contactName: AppStrings.facebook,
                    iconColor: ColorManager.blue,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
