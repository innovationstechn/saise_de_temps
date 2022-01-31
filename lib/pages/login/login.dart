import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saise_de_temps/constants/colors.dart';
import 'package:saise_de_temps/pages/login/login_viewmodel.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked/stacked.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFN = FocusNode(),
      passFN = FocusNode(),
      loginFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context);

    return ViewModelBuilder<LoginVM>.reactive(
        viewModelBuilder: () => LoginVM(),
        onModelReady: (loginVM) async {
          await loginVM.loadPreviousCredentials();

          emailController.text = loginVM.credentials?.name ?? "";
          passwordController.text = loginVM.credentials?.password ?? "";
        },
        builder: (context, loginVM, _) {
          return Scaffold(
            body: SafeArea(
              child: Form(
                key: _loginFormKey,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 80.h - md.viewInsets.bottom,
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
                              SizedBox(
                                width: 100.w,
                                child: TextFormField(
                                  focusNode: passFN,
                                  obscureText: true,
                                  controller: passwordController,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context)
                                          .requestFocus(loginFN),
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(passFN);
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
                              ),
                              const SizedBox(height: 5),
                              buildLoginButton(context, loginVM),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: buildFooter(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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

              if (!loginVM.hasError) {
                Navigator.of(context).pushNamed('/form');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      loginVM.error(loginVM),
                    ),
                  ),
                );
              }
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Saise-De-Temps',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'v0.0.1',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
}
