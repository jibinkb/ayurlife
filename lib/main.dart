
import 'package:ayurlife/providers/providerslist.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'Pages/loginpage.dart';
import 'ServicePage/GetpatientServices.dart';
import 'ServicePage/LoginpageServices.dart';


void setupLocator(){
  GetIt.I.registerLazySingleton( () => LoginServices());
  GetIt.I.registerLazySingleton( () => DashboardDetails());
}



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>( create: (context) => AuthProvider()),
  ],
      child: const MyApp()));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          fontFamily: 'Quicksand',

      ),
      home: const LoginPage(),
    );
  }
}
