import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saise_de_temps/constants/colors.dart';
import 'package:saise_de_temps/pages/login/login_viewmodel.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFN = FocusNode(),
      passFN = FocusNode(),
      loginFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildFooter(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return MediaQuery.of(context).orientation == Orientation.portrait
                    ? _portraitLayout()
                    : _landscapeLayout();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _portraitLayout() {
    return ViewModelBuilder<LoginVM>.reactive(
      viewModelBuilder: () => LoginVM(),
      onModelReady: (loginVM) async {
        await loginVM.initialize();

        emailController.text = loginVM.credentials?.name ?? "";
        passwordController.text = loginVM.credentials?.password ?? "";
      },
      builder: (context, loginVM, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loginVM.ipAddress != null)
              CachedNetworkImage(
                fit: BoxFit.fitHeight,
                imageUrl: loginVM.ipAddress ?? "",
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _loginFormKey,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        focusNode: emailFN,
                        controller: emailController,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(passFN),
                        validator: (text) {
/*
                                          if (!EmailValidator.validate(text!)) {
                                            FocusScope.of(context)
                                                .requestFocus(emailFN);
                                            return "Please enter a valid email";
                                          }
*/
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 0, 20, 0),
                          errorStyle: const TextStyle(
                              color: Colors.redAccent, fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        focusNode: passFN,
                        obscureText: true,
                        controller: passwordController,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(loginFN),
                        validator: (text) {
                          if (text!.isEmpty) {
                            FocusScope.of(context).requestFocus(passFN);
                            return "Password is empty";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 0, 20, 0),
                          errorStyle: const TextStyle(
                              color: Colors.redAccent, fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      buildLoginButton(context, loginVM),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _landscapeLayout() {
    return ViewModelBuilder<LoginVM>.reactive(
      viewModelBuilder: () => LoginVM(),
      onModelReady: (loginVM) async {
        await loginVM.initialize();

        emailController.text = loginVM.credentials?.name ?? "";
        passwordController.text = loginVM.credentials?.password ?? "";
      },
      builder: (context, loginVM, _) {
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: loginVM.ipAddress != null
                    ? CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        imageUrl: loginVM.ipAddress ?? "",
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
              ),
              Expanded(
                child: Form(
                  key: _loginFormKey,
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            focusNode: emailFN,
                            controller: emailController,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(passFN),
                            validator: (text) {
/*
                                              if (!EmailValidator.validate(text!)) {
                                                FocusScope.of(context)
                                                    .requestFocus(emailFN);
                                                return "Please enter a valid email";
                                              }
*/
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              contentPadding:
                                  const EdgeInsets.fromLTRB(12, 0, 20, 0),
                              errorStyle: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            focusNode: passFN,
                            obscureText: true,
                            controller: passwordController,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(loginFN),
                            validator: (text) {
                              if (text!.isEmpty) {
                                FocusScope.of(context).requestFocus(passFN);
                                return "Password is empty";
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              contentPadding:
                                  const EdgeInsets.fromLTRB(12, 0, 20, 0),
                              errorStyle: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          buildLoginButton(context, loginVM),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLoginButton(BuildContext context, LoginVM loginVM) {
    if (loginVM.isBusy) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          focusNode: loginFN,
          onPressed: () async {
            if (_loginFormKey.currentState!.validate()) {
              await loginVM.login(
                  emailController.text, passwordController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Error validating credentials. Please recheck username and password."),
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 30, 48, 62),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.login),
              SizedBox(
                width: 5,
              ),
              Text('LOGIN'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFooter() => Container(
        height: 100,
        width: double.infinity,
        color: const Color.fromARGB(255, 30, 48, 62),
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'TimeForm',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'v1.0.0',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
}
