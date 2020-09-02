import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';

enum LoginState{
  IDLE, LOADING, ERROR
}

class LoginStateBloc{
  LoginState loginState;
  String message;

  LoginStateBloc(this.loginState, {this.message});
}

class LoginBloc{

  LoginBloc(){
    _loginController.sink.add(LoginStateBloc(LoginState.IDLE));
  }

  String _username;
  String _password;

  StreamController _loginController = StreamController<LoginStateBloc>();
  StreamController _usernameController = StreamController<String>();
  StreamController _passwordController = StreamController<String>();

  Stream get outLoginState => _loginController.stream;
  Stream get outUsername => _usernameController.stream;
  Stream get outPassword => _passwordController.stream;
  StreamSink get setPassword => _passwordController.sink;
  StreamSink get setUsername => _usernameController.sink;

  void attPassword(text){
    _password = text;
    setPassword.add(text);
  }

  void attUsername(text){
    _username = text;
    setUsername.add(text);
  }

  Future<bool> login() async{
    _loginController.sink.add(LoginStateBloc(LoginState.LOADING));
    await Future.delayed(Duration(seconds: 2));
    if(_username == 'John Kevid' && _password == '12345678'){
      return true;
    }
    else{
      _loginController.sink.add(LoginStateBloc(
        LoginState.ERROR, message: "Aconteceu um erro ao logar!"
      ));
      return false;
    }
  }

  void dispose(){
    _loginController.close();
    _usernameController.close();
    _passwordController.close();
  }
}