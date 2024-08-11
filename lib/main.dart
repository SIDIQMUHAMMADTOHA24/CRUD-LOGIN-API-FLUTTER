import 'package:crud_interview/blocs/employe_bloc/employe_bloc.dart';
import 'package:crud_interview/blocs/field_bloc/field_bloc.dart';
import 'package:crud_interview/blocs/image_bloc/image_bloc.dart';
import 'package:crud_interview/blocs/user_bloc/user_bloc.dart';
import 'package:crud_interview/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FieldBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => EmployeBloc()),
        BlocProvider(create: (context) => ImageBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true, scaffoldBackgroundColor: Colors.white),
        home: const SplashView(),
      ),
    );
  }
}
