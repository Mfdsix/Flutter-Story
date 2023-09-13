import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/login.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/utils/result_state.dart';
import 'package:puth_story/utils/validator.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:puth_story/widgets/v_margin.dart';

class LoginPage extends StatefulWidget {

  final Function() onLogin;
  final Function() onRegister;
  final Function(String message) onError;

  const LoginPage({super.key, required this.onLogin, required this.onRegister, required this.onError});

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
        child: SingleChildScrollView(
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
                obscureText: true,
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
              Consumer<AuthProvider>(builder: (context, provider, _) {
                switch(provider.state){
                  case ResultState.loading:
                      return OutlinedButton(onPressed: (){}, child: const CircularProgressIndicator());
                  default:
                return  ElevatedButton(onPressed: () async {
                  if(formKey.currentState!.validate()){
                    final reqBody = LoginRequest(email: emailController.text, password: passwordController.text);
                    final result = await context.read<AuthProvider>().login(reqBody);

                    if(result){
                      widget.onLogin();
                    }else{
                      widget.onError("Wrong Email or Password");
                      // showPlatformAlert(context, "Wrong Email or Password");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.message ?? "Wrong Email or Password"))
                      );
                    }
                  }
                }, child: const Text("Login"),);
                }
              }),
              OutlinedButton(onPressed: widget.onRegister, child: const Text("Register"))
            ],
          ),
        ),
        ),
    );
  }
}
