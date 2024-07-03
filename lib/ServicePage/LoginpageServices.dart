
import 'dart:async';
import 'dart:convert';
import 'package:ayurlife/ServicePage/urlgloblal.dart';
import 'package:ayurlife/utils/apiresponse.dart';
import 'package:http/http.dart' as http;



class LoginServices{


  String API =urlglobal().urlff();



  Future<APIResponse> getLogin(String userName, String passWord) async {
    try {
      var url = Uri.parse('${API}Login');
      var response = await http.post(url, body: {
        'username': userName,
        'password': passWord
      });

      if (response.statusCode == 200) {

        Map data = jsonDecode(response.body);
        bool error = data.isEmpty;

        return APIResponse(
          data: data,
          error: error,
          errorMessage: '',
        );
      } else {
        return APIResponse(
          error: true,
          errorMessage: 'An error occurred',
          data: null,
        );
      }
    } catch (e) {
      print("--------------------value------------------$e");
      return APIResponse(
        error: true,
        errorMessage: 'An error occurred',
        data: null,
      );
    }
  }

}


