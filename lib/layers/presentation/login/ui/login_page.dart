import 'dart:math';
import 'package:blog_app/core/entities/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../injection_container.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../post/read_posts/ui/read_posts_page.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../widgets/custom_clipper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  TextEditingController userNameController = TextEditingController(text: "root");
  TextEditingController passwordController = TextEditingController(text: "root");

  dynamic user;
  final LoginBloc loginBloc = sl<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is LoggedState) {
          userNameController.clear();
          passwordController.clear();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ReadPostsPage(),
            ),
          );
        } else if (state is LoginErrorState) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
          }).then((value) => Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: ColorManager.error,
              ));
        }
      },
      builder: (context, state) {
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
                                      "Username",
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
                                        hintText: 'Enter Username',
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Password",
                                      style: getBoldStyle(
                                        fontSize: 15,
                                        color: ColorManager.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      obscureText: !isPasswordVisible,
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '*Required';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordVisible = !isPasswordVisible;
                                            });
                                          },
                                        ),
                                        border: InputBorder.none,
                                        fillColor: ColorManager.redWhite,
                                        filled: true,
                                        hintText: 'Enter Password',
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
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                LoginModel loginModel = LoginModel(
                                  email: userNameController.text,
                                  password: passwordController.text,
                                );
                                loginBloc.add(LoginButtonPressEvent(loginModel));
                              }
                            },
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
      },
    );
  }
}
