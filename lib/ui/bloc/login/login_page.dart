import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {

  @override
  void initState() {
    context.read<LoginBloc>().add(LoginAutoLoginEvent());
    super.initState();
  }
  String _email = '';
  String _emailErrorText = '';
  String _password = '';
  String _passwordErrorText = '';
  bool _rememberMe = false;

  final GlobalKey<_LoginPageBlocState> _formkey =
  GlobalKey<_LoginPageBlocState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, '/list');
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const CircularProgressIndicator();
            } else {
              return buildForm(context, state);
            }
          },
        ),
      )
    );
  }

  Widget buildForm(context, state) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state)
    {
      bool isLoading = state is LoginLoading;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Center(
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5, // 50% of screen width
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            _emailErrorText = '';
                                          });
                                        } else if (!EmailValidator(errorText: 'Email is not valid').isValid(value)) {
                                          setState(() {
                                            _emailErrorText = 'Email is not valid';
                                          });
                                        } else {
                                          setState(() {
                                            _emailErrorText = '';
                                            _email = value.toString();
                                          });
                                        }
                                      },
                                      enabled: !isLoading,
                                      decoration: InputDecoration(
                                          hintText: 'Email',
                                          labelText: 'Email',
                                          prefixIcon: const Icon(
                                            Icons.email,
                                          ),
                                          errorText:  _emailErrorText.isEmpty
                                              ? null
                                              : "Email is not valid",
                                          border: const OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.red),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(9.0)))))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        _passwordErrorText = '';
                                      });
                                    } else if (value.length < 6) {
                                      setState(() {
                                        _passwordErrorText =
                                        'Password must be at least 6 digit';
                                      });
                                    } else {
                                      setState(() {
                                        _passwordErrorText = '';
                                        _password = value.toString();
                                      });
                                    }
                                  },
                                  obscureText: true,
                                  enabled: !isLoading,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                        Icons.key
                                    ),
                                    errorStyle: const TextStyle(fontSize: 18.0),
                                    errorText: _passwordErrorText.isEmpty
                                        ? null
                                        : "Password must be at least 6 digit",
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(9.0))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: isLoading ? null : (bool? value) {
                                        setState(() {
                                          _rememberMe = value!;
                                        });
                                      },
                                    ),
                                    const Text('Remember me'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      disabledBackgroundColor: Colors.grey,
                                    ),
                                    onPressed: isLoading ? null :() {
                                      if (_emailErrorText.isEmpty &&
                                          _passwordErrorText.isEmpty && _email.isNotEmpty && _password.isNotEmpty) {
                                        context.read<LoginBloc>().add(
                                            LoginSubmitEvent(_email, _password,
                                                _rememberMe));
                                      }
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

}