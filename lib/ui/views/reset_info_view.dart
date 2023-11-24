import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/widgets/cards/white_card.dart';
import 'package:flutter/material.dart';

//TODO
class ResetInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
          child: WhiteCard(
              title: 'Informaciíon general del usuario',
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: CustomInputs.formInputDecoration(
                        hint: 'Nombre del usuario',
                        label: 'Nombre',
                        icon: Icons.supervised_user_circle_outlined),
                  )
                ],
              ))),
        ),
      ),
    );
  }
}
