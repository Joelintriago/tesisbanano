//import 'package:admin_dashboard/providers/route_provider.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/login_form_provider.dart';
import 'package:email_validator/email_validator.dart';

class CardLogin extends StatelessWidget {
  const CardLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
        create: (_) => LoginFormProvider(),
        child: Builder(builder: (context) {
          final loginFormProvider =
              Provider.of<LoginFormProvider>(context, listen: false);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Card(
                  margin: const EdgeInsets.only(top: 90),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 100, top: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white, width: 2.0),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(39, 97, 12, 1),
                          Color.fromRGBO(176, 227, 101, 0.6),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: loginFormProvider.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onFieldSubmitted: (_) =>
                                  onFormSubmit(loginFormProvider, authProvider),
                              validator: (value) {
                                if (!EmailValidator.validate(value ?? ''))
                                  return 'Email no válido';
                                return null;
                              },
                              onChanged: (value) =>
                                  loginFormProvider.email = value,
                              decoration: CustomInputs.loginInputDecoration(
                                hint: 'Ingrese su dirección de correo',
                                label: 'Email',
                                icon: Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              onFieldSubmitted: (_) =>
                                  onFormSubmit(loginFormProvider, authProvider),
                              onChanged: (value) =>
                                  loginFormProvider.password = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese su contraseña';
                                }
                                if (value.length < 3) {
                                  return 'La contraseña debe ser de 3 caracteres';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: CustomInputs.loginInputDecoration(
                                hint: '*********',
                                label: 'Contraseña',
                                icon: Icons.lock_outline_rounded,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: false, onChanged: (value) {}),
                                    const Text('Remember Me'),
                                  ],
                                ),
                                LinkText(
                                  text: 'Forgot password?',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, Flurorouter.recoveryRoute);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            CustomOutlinedButton(
                              onPressed: () {
                                onFormSubmit(loginFormProvider, authProvider);
                              },
                              text: 'LOGIN',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 20,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        child: const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Color(0xFF08320A),
                          child: Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          );
        }));
  }

  void onFormSubmit(
      LoginFormProvider loginFormProvider, AuthProvider authProvider) {
    final isValid = loginFormProvider.validateForm();
    if (isValid) {
      authProvider.login(loginFormProvider.email, loginFormProvider.password);
    }
  }
}
