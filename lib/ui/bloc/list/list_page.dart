import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Page'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            GetIt.I<SharedPreferences>().clear();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Center(
        child: BlocConsumer<ListBloc, ListState>(
          listener: (context, state) {
            if (state is ListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ListLoading) {
              return const CircularProgressIndicator();
            } else if (state is ListLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.users[index].name),
                    leading: Image.network(state.users[index].avatarUrl),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),

      );
  }
}
