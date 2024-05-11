import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    Response token;

    on<LoginSubmitEvent>((event, emit) async{
      try {
        if (state != LoginLoading) {
          emit(LoginLoading());
          Map<String, String> map = {
            'email': event.email,
            'password': event.password,
          };
          token = await GetIt.I<Dio>().post('/login', data: map);
          if (event.rememberMe) {
            GetIt.I<SharedPreferences>().setString('token', token.data['token']);
          }
          emit(LoginSuccess());
        }
      } on DioException catch (e) {
          emit(LoginError(e.response?.data['message'] ?? 'An error occurred'));
      }
    });

  }
}
