// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/widgets/cards/white_card.dart';
import 'package:provider/provider.dart';

//TODO
class ResetPasswordView extends StatefulWidget {
  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final userProvider = Provider.of<AuthProvider>(context);

    final TextEditingController lastPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController repeatPasswordController = TextEditingController();

    String lastPassword;
    String newPassword;
    String repeatPassword;

    // ignore: unused_local_variable
    bool _showPassword = false;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
          child: WhiteCard(
              title: 'Actualizar contraseña',
              child: Form(
                  key: userProvider.formKey2,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: Container(
                              width: 150,
                              child: const Center(child: Text('Contraseña: ')),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: lastPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true, // Agregar fondo lleno
                                fillColor:
                                    Colors.white, // Color de fondo blanco
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown.shade400
                                          .withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown.shade400
                                          .withOpacity(0.3)),
                                ),
                                hintText: '******',
                                label: const Text('Escriba su contraseña'),
                                labelStyle: TextStyle(color: Colors.brown),
                                hintStyle: TextStyle(color: Colors.brown),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Ingrese un nombre.';
                                if (value.length < 3)
                                  return 'El nombre debe de ser de tres caracteres como mínimo.';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: Container(
                              width: double.infinity,
                              child: const Center(
                                  child: Text('Nueva contraseña: ')),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      300), // Ancho máximo deseado para el TextFormField
                              child: TextFormField(
                                controller: newPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown.shade400
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown.shade400
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  hintText: '******',
                                  labelText: 'Escribir nueva contraseña',
                                  labelStyle: TextStyle(color: Colors.brown),
                                  hintStyle: TextStyle(color: Colors.brown),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Ingrese un nombre.';
                                  if (value.length < 3)
                                    return 'El nombre debe ser de al menos tres caracteres.';
                                  return null;
                                },

                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: Container(
                              width: 150,
                              child: const Center(
                                  child: Text('Repita contraseña: ')),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 300,
                              child: TextFormField(
                                obscureText: true,
                                controller: repeatPasswordController,
                                decoration: InputDecoration(
                                  filled: true, // Agregar fondo lleno
                                  fillColor:
                                      Colors.white, // Color de fondo blanco
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.brown.shade400
                                            .withOpacity(0.3)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.brown.shade400
                                            .withOpacity(0.3)),
                                  ),
                                  hintText: '******',
                                  label: const Text('Repita nueva contraseña'),
                                  labelStyle: TextStyle(color: Colors.brown),
                                  hintStyle: TextStyle(color: Colors.brown),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Ingrese contraseña.';
                                  if (value.length < 4)
                                    return 'La contraseña debe ser de 4 caracteres como mínimo.';
                                  if (value.length > 16)
                                    return 'La contraseña no debe ser mayor a 16 caracteres';
                                  if (value != newPasswordController.text)
                                    return 'Las contraseñas no coinciden';
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: ElevatedButton(
                                onPressed: () {
                                  NavigationService.replaceTo(
                                      Flurorouter.dashboardRoute);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 232, 25, 25)
                                          .withOpacity(0.3)),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.close, size: 20),
                                    Text('  Cancelar')
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: ElevatedButton(
                                onPressed: () async {
                                  lastPassword = lastPasswordController.text;
                                  newPassword = newPasswordController.text;
                                  repeatPassword = repeatPasswordController.text;

                                  await userProvider.putUpdatePaswword(lastPassword, newPassword);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFADCFAB).withOpacity(0.9)),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check, size: 20),
                                    Text('  Aceptar')
                                  ],
                                )),
                          ),
                        ],
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
