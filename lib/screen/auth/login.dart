import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/login.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/utils/validator.dart';
import 'package:puth_story/widgets/platform_alert.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:puth_story/widgets/v_margin.dart';

class LoginPage extends StatefulWidget {

  final Function() onLogin;
  final Function() onRegister;

  const LoginPage({super.key, required this.onLogin, required this.onRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        title: "Login",
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text("Login", style: Theme.of(context).textTheme.titleLarge,),
              const VMargin(),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email Address"
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Email must be filled';
                  }
                  if(!validateEmail(value)){
                    return 'Email is not valid';
                  }

                  return null;
                },
              ),
              const VMargin(),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: "Password"
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Password must be filled';
                  }
                  if(value.length < 5){
                    return 'Password is not valid';
                  }

                  return null;
                },
              ),
              const VMargin(
                height: 20.0,
              ),
              context.watch<AuthProvider>().isLoadingLogin
              ? OutlinedButton(onPressed: (){}, child: const CircularProgressIndicator())
                  : ElevatedButton(onPressed: () async {
                    if(formKey.currentState!.validate()){
                      final reqBody = LoginRequest(email: emailController.text, password: passwordController.text);
                      final result = await context.read<AuthProvider>().login(reqBody);

                      if(result){
                        widget.onLogin();
                      }else{
                        showPlatformAlert(context, "Email or Password is not correct");
                      }
                    }
              }, child: const Text("Login"),),
              OutlinedButton(onPressed: () => widget.onRegister, child: const Text("Register"))
            ],
          ),
        ));
  }
}
