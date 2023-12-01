import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/usuario.dart';

class UsersFormProvider extends ChangeNotifier{
  Usuario? user;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // TODO
  bool validForm(){
    return formKey.currentState!.validate();

  }




}