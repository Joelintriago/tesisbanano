import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/widgets/cards/white_card.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/models/usuario.dart';

//TODO
class ResetInfoView extends StatefulWidget {
  final String token;

  const ResetInfoView({Key? key, required this.token}) : super(key: key);

  @override
  State<ResetInfoView> createState() => _ResetInfoViewState();
}

class _ResetInfoViewState extends State<ResetInfoView> {
  Usuario? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final userProvider = Provider.of<AuthProvider>(context);

    TextEditingController nameController =
        TextEditingController(text: user.firstName);
    TextEditingController apellidoController =
        TextEditingController(text: user.lastName);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController rolController =
        TextEditingController(text: user.roles![0].roleName);

    String nombreUsuario = nameController.text;
    String apellidoUsuario = apellidoController.text;
    String emailUsuario = emailController.text;
    String rolUsuario = rolController.text;

    //authProvider.user?.roles?[0].roleCode

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
        child: WhiteCard(
            title: 'Informaciíon general del usuario',
            child: Form(
              key: userProvider.formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: Container(
                          width: 150,
                          child: const Center(child: Text('Nombres: ')),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration: CustomInputs.formInputDecoration(
                            hint: 'Nombres',
                            label: 'Nombres',
                            icon: Icons.person,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Ingrese un nombre.';
                            if (value.length < 3)
                              return 'El nombre debe de ser de tres caracteres como mínimo.';
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: Container(
                          width: 150,
                          child: const Center(child: Text('Apellidos: ')),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: apellidoController,
                          decoration: CustomInputs.formInputDecoration(
                            hint: 'Apellidos',
                            label: 'Apellidos',
                            icon: Icons.person,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Ingrese un apellido.';
                            if (value.length < 3)
                              return 'El apellido debe de ser de tres caracteres como mínimo.';
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: Container(
                          width: 150,
                          child: const Center(child: Text('Email: ')),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: emailController,
                          decoration: CustomInputs.formInputDecoration(
                            hint: 'Email',
                            label: 'Email',
                            icon: Icons.email,
                          ),
                          validator: (value) {
                            if (!EmailValidator.validate(value ?? ''))
                              return 'Email no válido';

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: Container(
                          width: 150,
                          child: const Center(child: Text('Rol: ')),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: rolUsuario,
                          decoration: CustomInputs.formInputDecoration(
                            hint: 'Rol',
                            label: 'Rol',
                            icon: Icons.person_3_outlined,
                          ),
                          enabled: false,
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
                              nameController.text = user.firstName;
                              apellidoController.text = user.lastName;
                              emailController.text = user.email;
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 232, 25, 25)
                                      .withOpacity(0.3)),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.settings_backup_restore, size: 20),
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
                              nombreUsuario = nameController.text;
                              apellidoUsuario = apellidoController.text;
                              emailUsuario = emailController.text;
                            print('Varibales $nombreUsuario,$apellidoUsuario,$emailUsuario');
                            await userProvider.putUpdateProfileUser(nombreUsuario, apellidoUsuario, emailUsuario);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color(0xFFADCFAB).withOpacity(0.9)),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.save_outlined, size: 20),
                                Text('  Guardar')
                              ],
                            )),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
