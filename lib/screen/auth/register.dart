import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puth_story/model/api/register.dart';
import 'package:puth_story/provider/auth_provider.dart';
import 'package:puth_story/utils/validator.dart';
import 'package:puth_story/widgets/platform_alert.dart';
import 'package:puth_story/widgets/platform_scaffold.dart';
import 'package:puth_story/widgets/v_margin.dart';

class RegisterPage extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterPage({super.key, required this.onRegister, required this.onLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      title: "Register",
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              "Register",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const VMargin(),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name must be filled';
                }
                if (value.length < 4) {
                  return 'Name is not valid';
                }

                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email Address"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email must be filled';
                }
                if (!validateEmail(value)) {
                  return 'Email is not valid';
                }

                return null;
              },
            ),
            const VMargin(),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password must be filled';
                }
                if (value.length < 5) {
                  return 'Password is not valid';
                }

                return null;
              },
            ),
            const VMargin(
              height: 20.0,
            ),
            context.watch<AuthProvider>().isLoadingRegister
                ? OutlinedButton(
                    onPressed: () {}, child: const CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final reqBody = RegisterRequest(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text);
                        final result = await context
                            .read<AuthProvider>()
                            .register(reqBody);

                        if (result) {
                          widget.onRegister();
                        } else {
                          showPlatformAlert(context, "Registration Failed");
                        }
                      }
                    },
                    child: const Text("Register"),
                  ),
            OutlinedButton(onPressed: widget.onLogin, child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
