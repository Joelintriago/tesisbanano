
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/register_form_provider.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';


class CardRecoveryPass extends StatelessWidget {
  const CardRecoveryPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>RegisterFormProvider(),
      child: Builder(builder: (context){
        final registerFormProvider = Provider.of<RegisterFormProvider>(context,listen: false);
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            onChanged: (value)=>registerFormProvider.email = value,
                            validator: (value){
                              if(!EmailValidator.validate(value??'')){
                                return 'Email no valido';
                              }
                              return null;
                            },
                            decoration: CustomInputs.loginInputDecoration(
                              hint: 'Ingrese su dirección de correo',
                              label: 'Email',
                              icon: Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 48.0),
                          CustomOutlinedButton(
                            onPressed: () {
                               final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                 authProvider.ressetPassword(registerFormProvider.email);

                                 print(registerFormProvider.email);
                            },
                            text: 'RECUPERAR CONTRASEÑA',
                          ),
                          LinkText(
                            text: 'Ir al login',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Flurorouter.loginRoute);
                            },
                          )
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
                          Icons.vpn_key,
                          size: 60.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
      ),
    );
  }
}
