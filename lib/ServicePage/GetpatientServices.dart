
import 'dart:async';
import 'dart:convert';
import 'package:ayurlife/ServicePage/urlgloblal.dart';
import 'package:ayurlife/utils/apiresponse.dart';
import 'package:http/http.dart' as http;



class DashboardDetails{


  String api =urlglobal().urlff();


  Future<APIResponse> GetPatientslist(String token) async {
    try {
      final url = Uri.parse('${api}PatientList');

      var response = await http.get(url,  headers: {
        'Authorization': 'Bearer $token',
      },);

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
      return APIResponse(
        error: true,
        errorMessage: 'An error occurred',
        data: null,
      );
    }
  }



  Future<APIResponse> GetBranchlist(String token) async {
    try {
      final url = Uri.parse('${api}BranchList');
      var response = await http.get(url , headers: {
      'Authorization': 'Bearer $token',
      },);

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
      print('caught error $e');
      return APIResponse(
        error: true,
        errorMessage: 'An error occurred',
        data: null,
      );
    }
  }



  Future<APIResponse> GetTreatementlist(String token) async {

    try {
      final url = Uri.parse('${api}TreatmentList');

      var response = await http.get(url , headers: {
        'Authorization': 'Bearer $token',
      },);

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
      print('caught error $e');
      return APIResponse(
        error: true,
        errorMessage: 'An error occurred',
        data: null,
      );
    }
  }





  Future<APIResponse> SavePatientDetails(
      String token, String name, String whatsappNo, String address,
      String paymentoption, double totalPrice, double totalDiscount, double advanceAmount,
      String DateandTime, List<dynamic> Treatmentid, double balance,
      String Branch, List<String> maleid, List<String> femaleid,) async {
    try {

      String  maleids = "";
      String  femaleids = "";

      if(maleid.length == 1){
        maleids = maleid.toString();
      }else{
        maleids = maleid.join(',');
      }


      if(femaleid.length == 1){
        femaleids = femaleid.toString();
      }else{
        femaleids = femaleid.join(',');
      }

      var url = Uri.parse('${api}PatientUpdate');
      var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $token'},
        body: {
          'name':name,
          'excecutive': name,
          'payment': paymentoption,
          'phone': whatsappNo,
          'address': address,
          'total_amount': totalPrice.toStringAsFixed(0),
          'discount_amount': totalDiscount.toStringAsFixed(0),
          'advance_amount': totalDiscount.toStringAsFixed(0),
          'balance_amount': totalDiscount.toStringAsFixed(0),
          'date_nd_time': DateandTime,
          'id': '',
          'male':  maleids,
          'female': femaleids,
          'branch': '166',
          'treatments': Treatmentid.join(',')
        }
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        bool error = data.isEmpty;

        return APIResponse(data: data, error: error, errorMessage: '',);
      } else {
        print("response code------${response.statusCode}");
        return APIResponse(error: true, errorMessage: 'Failed to register patient: ${response.statusCode}', data: null,
        );
      }
    } catch (e) {
      print('Error: $e');
      return APIResponse(error: true, errorMessage: 'An error occurred', data: null,
      );
    }
  }


}


