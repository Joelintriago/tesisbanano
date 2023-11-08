import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Logo extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black, // Fondo negro
            // Aquí puedes agregar otras propiedades del CircleAvatar
            radius: 30, // Tamaño del círculo
          ),
          const SizedBox(
            height: 5,
          ),
          Text(user.firstName),
        ],
      ),
    );
  }
}
