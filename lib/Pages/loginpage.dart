
import 'package:ayurlife/providers/providerslist.dart';
import 'package:flutter/material.dart';
import 'package:ayurlife/ServicePage/LoginpageServices.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginServices get loginservice => GetIt.I<LoginServices>();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isloading=true;
 String status = "";
  String token = "";
  String? uservalue;
  String? passvalue;




  Future<void> getLogin(String usercode, String password) async {
    final response = await loginservice.getLogin(usercode, password);


    if(response.error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sever connection failed!'),
        ),
      );
    }else{

      status= response.data['status'].toString();
      token =response.data['token'].toString();

      if(status =='true'){
        Provider.of<AuthProvider>(context, listen: false).setToken(token);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Dashboard( token: token,)));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!'),),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username or password'),
          ),
        );
      }


    }


  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
  double screenHeight = size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/login.jpeg',
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18,right: 18 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Login Or Register To Book Your Appointments',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        'Email ',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextField(
                    controller: username,
                    decoration: const InputDecoration(
                      hintText: 'Enter username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextField(
                    controller: password,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {

                      setState(() {
                        uservalue = username.text;
                       passvalue = password.text;
                      });

                      if(uservalue!.isNotEmpty && passvalue!.isNotEmpty){
                        FocusScope.of(context).unfocus();
                        getLogin(uservalue!, passvalue!);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(' Please Enter username or password!'),
                          ),
                        );
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.green.shade700,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Login',
                      style: TextStyle(fontSize: 17,color: Colors.white),
                    ),
                  ),
                   SizedBox(height: screenHeight /6),
                  const Text(
                    'By creating or logging into an account you are agreeing with our Terms and Conditions and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
