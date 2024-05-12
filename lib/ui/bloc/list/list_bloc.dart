import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      emit(ListLoading());
      try {
        var res = await GetIt.I<Dio>().get(
            '/users',
            options: Options(headers: {
              'Authorization': 'Bearer ${GetIt.I<SharedPreferences>().getString('token')}'
            })
        );
        List<UserItem> users = [];
        for (var user in res.data) {
          users.add(UserItem(user['name'], user['avatar']));
        }

      } on DioException catch (e){
        emit(ListError(e.response?.data['message'] ?? 'An error occurred'));
      }
    });

  }
}
