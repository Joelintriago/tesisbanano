import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();


  String email = '';
  String password = '';



   validateForm() {
    if(formKey.currentState!.validate()){
      return true;
    }else{
      return false;
    }
  }
}
