import 'dart:math';
import 'package:flutter/material.dart';
import '../../../resources/colour_manager.dart';
import '../../../resources/styles_manager.dart';
import 'custom_clipper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  TextEditingController userNameController = TextEditingController();

  dynamic user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -size.height * 0.15,
              right: -size.width * 0.4,
              child: SizedBox(
                child: Transform.rotate(
                  angle: -pi / 3.5,
                  child: ClipPath(
                    clipper: ClipPainter(),
                    child: Container(
                      height: size.height * 0.5,
                      width: size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorManager.darkWhite,
                            ColorManager.blue,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Login',
                          style: getSemiBoldStyle(
                            fontSize: 30,
                            color: ColorManager.blue,
                          ),
                          children: [
                            TextSpan(
                              text: ' Now',
                              style: getSemiBoldStyle(
                                color: ColorManager.black,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Contact No.",
                                  style: getBoldStyle(
                                    fontSize: 15,
                                    color: ColorManager.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: userNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '*Required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: ColorManager.redWhite,
                                    filled: true,
                                    hintText: 'Contact',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorManager.blueGrey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorManager.red),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorManager.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                ColorManager.blue,
                                ColorManager.blue,
                              ],
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: getRegularStyle(
                              color: ColorManager.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
