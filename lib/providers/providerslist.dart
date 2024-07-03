import 'package:ayurlife/Models/patientsdetails.dart';
import 'package:flutter/material.dart';


    class AuthProvider with ChangeNotifier {
      String _token = "";

      String get token => _token;

      void setToken(String token) {
        _token = token;
        notifyListeners();
      }



      List<Patient> _patients = [];

      List<Patient> get patients => _patients;

      void setPatients(List<Patient> patients) {
        _patients = patients;
        notifyListeners();
      }



      List<Map<String, dynamic>> _selectedTreatments = [];

      List<Map<String, dynamic>> get selectedTreatments => _selectedTreatments;

      void addTreatment(String treatment, int males, int females,String price,String id) {
        _selectedTreatments.add({
          'treatment': treatment,
          'males': males,
          'females': females,
          'price' : price,
          'id': id
        });
        updateTotalPrice();
        notifyListeners();
      }


      List<Map<String, dynamic>> _getgeneratepdf = [];

      List<Map<String, dynamic>> get Getgeneratepdf => _getgeneratepdf;

      void addpdf( String name,
          String whatsappNo,
          String address,
          String paymentOption,
          double totalPrice,
          double totalDiscount,
          double advanceAmount,
          String dateAndTime,
          List<Map<String, dynamic>> treatments,
          double balance,
          String branch,
          List<String> maleId,
          List<String> femaleId) {
        _getgeneratepdf.add({
          'name': name,
          'whatsappNo': whatsappNo,
          'address': address,
          'paymentOption' : paymentOption,
          'totalPrice': totalPrice,
          'totalDiscount' : totalDiscount,
          'advanceAmount': advanceAmount,
          'dateAndTime' : dateAndTime,
          'treatments': treatments,
          'balance' : balance,
          'branch': branch,
          'maleId' : maleId,
          'femaleId': femaleId,
        });
        notifyListeners();
      }



      //Remove Treatment Card
      void removeTreatment(int index) {
        _selectedTreatments.removeAt(index);
        updateTotalPrice();
        notifyListeners();
      }




      // get male treatment id
      List<String> getMaleTreatmentIds() {
        return _selectedTreatments
            .where((treatment) => treatment['males'] > 0)
            .map((treatment) => treatment['id'] as String)
            .toList();
      }


      //get tratment name(pdf)
      List<String> getTreatmentname() {
        return _selectedTreatments.map((treatment) => treatment['treatment'] as String).toList();
      }

      //get price (pdf)
      List<dynamic> getPrice() {
        return _selectedTreatments.map((treatment) => treatment['price']).toList();
      }

    //get mail count
      List<dynamic> getmalecount() {
        return _selectedTreatments.map((treatment) => treatment['males']).toList();
      }


      //get female count
      List<dynamic> getfemalecount() {
        return _selectedTreatments.map((treatment) => treatment['females']).toList();
      }



    // get female treatment id
      List<String> getFemaleTreatmentIds() {
        return _selectedTreatments
            .where((treatment) => treatment['females'] > 0)
            .map((treatment) => treatment['id'] as String)
            .toList();
      }


//fetch treatment result and add

      List<Map<String, dynamic>> tratmentdetails = [];

      List<Map<String, dynamic>> get TreatmentDetails => tratmentdetails;


      void addTreatmentDetails(List<List<dynamic>> treatments) {
        tratmentdetails = treatments.map((treatment) {
          return {
            'id': treatment[0],
            'name': treatment[1],
            'price': treatment[2],
          };
        }).toList();
        notifyListeners();
      }


//get treatment id
      List<dynamic> getTreatmentPrices() {
        return tratmentdetails.map((treatment) => treatment['id']).toList();
      }



  // total price
      TextEditingController totalPriceController = TextEditingController();

      void  updateTotalPrice() {
        double totalPrice = 0.0;
        for (var treatment in _selectedTreatments) {
          totalPrice +=(double.tryParse(treatment['price'])! * ( treatment['males']! + treatment['females']) )   ?? 0.0;
        }
        totalPriceController.text = totalPrice.toStringAsFixed(2);
        updateTotalDiscount(totalPrice);
      }



      double getTotalPrice() {
        return double.tryParse(totalPriceController.text) ?? 0.0;
      }





      //balance

      TextEditingController BalanceController = TextEditingController();

      double _balance = 0;

      double get balance => _balance;

      void updateBalance() {
        double totalPrice = getTotalPrice();
        double advance = double.tryParse(AdvanceamountController.text) ?? 0.0;
        double totalDiscount = double.tryParse(TotalDiscController.text) ?? 0.0;

        _balance = totalPrice - advance - totalDiscount;
        BalanceController.text = _balance.toStringAsFixed(2);
        notifyListeners();
      }

      @override
      void balancediscispose() {
        BalanceController.dispose();
        super.dispose();
      }



      //totaldisc
      TextEditingController TotalDiscController = TextEditingController();

      double _totaldisc = 0;

      double get totaldisc => _totaldisc;

      void updateTotalDiscount(double totalPrice) {
        double totalDiscount = totalPrice * 0.03; // 3% discount
        TotalDiscController.text = totalDiscount.toStringAsFixed(2);
        updateBalance();
      }

      @override
      void totaldiscispose() {
        TotalDiscController.dispose();
        super.dispose();
      }



  //Name
      TextEditingController nameController = TextEditingController();

      String _name = '';

      String get name => _name;

      void addName(String newName) {
        _name = newName;
        notifyListeners();
      }

      @override
      void dispose() {
        nameController.dispose();
        super.dispose();
      }




      //advance amount

      TextEditingController AdvanceamountController = TextEditingController();

      double _advance =0;

      double get advance => _advance;

      void addAdvance(double newAdvance) {
        _advance = newAdvance;
        notifyListeners();
        updateBalance();
      }

      @override
      void advancedispose() {
        AdvanceamountController.dispose();
        super.dispose();
      }


      //whatsapp no
      TextEditingController whatsappnoController = TextEditingController();

      String _whatsappnumber = '';

      String get whatsappnumber => _whatsappnumber;

      void addNumber(String newNumber) {
        _whatsappnumber = newNumber;
        notifyListeners();
      }

      @override
      void nodispose() {
        whatsappnoController.dispose();
        super.dispose();
      }



  //Address
      TextEditingController AddressController = TextEditingController();

      String _address = '';

      String get adress => _address;

      void addAddress(String newAddress) {
        _address = newAddress;
        notifyListeners();
      }

      @override
      void addressdispose() {
        AddressController.dispose();
        super.dispose();
      }


      //Branch
      String _branch = '';

      String get branch => _branch;

      void addABranch(String newBranch) {
        _branch = newBranch;
        notifyListeners();
      }



      // Clear all controllers
      void clearAllControllers() {
        nameController.clear();
        whatsappnoController.clear();
        AddressController.clear();
        AdvanceamountController.clear();
        TotalDiscController.clear();
        BalanceController.clear();
        totalPriceController.clear();
        _selectedTreatments.clear();
        notifyListeners();
      }


    }


