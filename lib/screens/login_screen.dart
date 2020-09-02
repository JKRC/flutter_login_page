import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/login_bloc.dart';
import 'package:flutter_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible;
  LoginBloc _loginBloc;

  @override
  void initState() {
    _passwordVisible = false;
    _loginBloc = LoginBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<LoginStateBloc>(
            stream: _loginBloc.outLoginState,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              switch (snapshot.data.loginState) {
                case LoginState.LOADING:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case LoginState.IDLE:
                case LoginState.ERROR:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _usernameField(),
                      Divider(),
                      _passwordField(),
                      SizedBox(
                        height: 30,
                      ),
                      snapshot.data.loginState == LoginState.ERROR
                          ? _textError(snapshot.data.message)
                          : Container(),
                      _buttonLogin()
                    ],
                  );
                  break;
                default:
                  return Container();
              }
            }),
      ),
    );
  }

  Text _textError(String message) {
    return Text(message,
    style: TextStyle(
      color: Colors.red
    ),);
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color.fromRGBO(22, 22, 22, 1),
      actions: [
        FlatButton(
          child: Text(
            'REGISTER',
            style: TextStyle(
                color: Color.fromRGBO(10, 255, 255, 1),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  TextFormField _usernameField() {
    return TextFormField(
      onChanged: _loginBloc.attUsername,
      cursorColor: Color.fromRGBO(153, 255, 255, 1),
      style: TextStyle(color: Color.fromRGBO(153, 255, 255, 1)),
      decoration: InputDecoration(
        focusedBorder: _borderFieldStyle(),
        enabledBorder: _borderFieldStyle(),
        hintText: "Username",
        hintStyle: TextStyle(color: Color.fromRGBO(153, 255, 255, 1)),
        border: _borderFieldStyle(),
      ),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      onChanged: _loginBloc.attPassword,
      cursorColor: Color.fromRGBO(153, 255, 255, 1),
      style: TextStyle(color: Color.fromRGBO(153, 255, 255, 1)),
      obscureText: _passwordVisible ? false : true,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: _passwordVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            color: Color.fromRGBO(153, 255, 255, 1),
          ),
          enabledBorder: _borderFieldStyle(),
          focusedBorder: _borderFieldStyle(),
          hintText: "Password",
          hintStyle: TextStyle(color: Color.fromRGBO(153, 255, 255, 1)),
          border: _borderFieldStyle()),
    );
  }

  Container _buttonLogin() {
    return Container(
      height: 50,
      width: 300,
      child: RaisedButton(
        onPressed: () async{
          if (await _loginBloc.login()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: Color.fromRGBO(10, 255, 255, 1),
        child: Text('Login'),
      ),
    );
  }

  OutlineInputBorder _borderFieldStyle() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(10, 255, 255, 1)),
    );
  }
}
