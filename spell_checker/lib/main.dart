import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spell_checker/modules/splash.dart';
import 'package:spell_checker/shared/main_cubit/bloc_observer.dart';
import 'package:spell_checker/shared/main_cubit/main_cubit.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spell Checker',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: SplashScreen(),
      ),
    );
  }
}
