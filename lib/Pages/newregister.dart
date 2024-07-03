
import 'dart:io';
import 'package:ayurlife/Pages/generatepdf.dart';
import 'package:ayurlife/ServicePage/GetpatientServices.dart';
import 'package:ayurlife/providers/providerslist.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;





class NewRegister extends StatefulWidget {
  const NewRegister({super.key});

  @override
  State<NewRegister> createState() => _NewRegisterState();
}

class _NewRegisterState extends State<NewRegister> {


  DashboardDetails get dashboardservices => GetIt.I<DashboardDetails>();

  List<String> branchNames =[];
  String? _selectedLocation;
  String? _selectedBranch;
  int malePatients = 0;
  int femalePatients = 0;
  String? selectedTreatment;
  List<String> treatmentList = [];
  List<String> treatmentPrice = [];
  var status;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _paymentOption;
  bool isLoading = false;
  List<dynamic> treatmentPrices = [];
  List<dynamic> treatmentNames = [];
  List<dynamic> treatmentprice = [];
  List<dynamic> maleCount = [];
  List<dynamic> femaleCount = [];
  List<Map<String, dynamic>> result = [];

  var Status;
   bool isvisible =true;


  final List<String> _locations = {'Kochi', 'Alapuzha', 'Kottaayam'}.toList();




  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }



  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }




  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await getbranchlist();
      await getTreatmentList();
      Provider.of<AuthProvider>(context, listen: false).clearAllControllers();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }



  Future<void> getbranchlist() async {
    setState(() {
      isLoading = true;
    });
    final token = Provider.of<AuthProvider>(context ,listen: false).token;
    final response = await dashboardservices.GetBranchlist(token);

    if(response.error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serverissue!')),
      );
    }else{
      var status = response.data['status'].toString();
      if (status == 'true') {
        var braches =  response.data['branches'] != null ? response.data['branches'] : null;
        branchNames = braches.map<String>((branch) => branch['name'] as String).toList();
        setState(() {
          isLoading = false;
        });
      }
    }
  }



  Future<void> getTreatmentList() async {

    setState(() {
      isLoading = true;
    });
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await dashboardservices.GetTreatementlist(token);

    if(response.error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serverissue!')),
      );
    }else{
      status = response.data['status'].toString();
      var treatments = response.data['treatments'] != null ? response.data['treatments'] : null;

      if (status == 'true' && treatments != null) {
        treatmentList = treatments.map<String>((treatment) => treatment['name'] as String).toList();
        treatmentPrice = treatments.map<String>((treatment) => treatment['price'] as String).toList();

        List<List<dynamic>> treatmentDetails = [];

        for (var treatment in treatments) {
          String id = treatment['id'].toString();
          String price = treatment['price'].toString();
          String name = treatment['name'].toString();

          treatmentDetails.add([id,name,price]);

          Provider.of<AuthProvider>(context, listen: false).addTreatmentDetails(treatmentDetails);

        }
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load treatments')),
        );
      }
    }



  }




    Future<void> Updatepatient(
        String name,
        String whatsappNo ,
        String address,
        String paymentoption,
        double totalPrice,
        double totalDiscount,
        double advanceAmount,
        String DateandTime,
        List<dynamic> treatmentid,
        double balance,
        String Branch,
        List<String> maleid,
        List<String> femaleid,) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final token = Provider.of<AuthProvider>(context,listen:  false).token;
      final response = await dashboardservices.SavePatientDetails(
          token,name,
          whatsappNo,
          address,
          paymentoption,
          totalPrice,
          totalDiscount,
          advanceAmount,
          DateandTime,
          treatmentid,
          balance ,
          Branch,maleid,femaleid
      );


      if(response.error){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Error'),duration: Duration(seconds: 1),),
        );
      }else{
      Status = response.data['status'].toString();
      if(Status == 'true'){
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              elevation: 5,
              content: const SizedBox(
                width: double.infinity,
                child: Text('Saved Sucessfully'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    treatmentNames = Provider.of<AuthProvider>(context, listen: false).getTreatmentname();
                    treatmentprice = Provider.of<AuthProvider>(context, listen: false).getPrice();
                    maleCount = Provider.of<AuthProvider>(context, listen: false).getmalecount();
                    femaleCount = Provider.of<AuthProvider>(context, listen: false).getfemalecount();


                    for (int i = 0; i < treatmentNames.length; i++) {
                      if (i < treatmentprice.length && i < maleCount.length && i < femaleCount.length) {
                        result.add({
                          'name': treatmentNames[i],
                          'price': treatmentprice[i],
                          'male': maleCount[i],
                          'female' :femaleCount[i]
                        });
                      }
                    }

                    final List<String> maleId = [];
                    final List<String> femaleId = [];

                    Provider.of<AuthProvider>(context, listen: false).addpdf(name,whatsappNo,address,
                        paymentoption,totalPrice,totalDiscount,advanceAmount,DateandTime,result,balance,Branch,maleId,femaleId);

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GenerateFile(),),);

                  },
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.teal[400]),
                  ),
                ),
              ],
            );
          },
        );

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Error'),duration: Duration(seconds: 1),),
        );
      }
      }
    }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),

                  _PatientDataTextField(
                    hintText: 'Enter your full Name',
                    textController: Provider.of<AuthProvider>(context).nameController,
                    onChanged: (value) => Provider.of<AuthProvider>(context, listen: false).addName(value),
                    labelText: 'Name',readOnly: false
                  ),

                  const SizedBox(height: 20),
                  _PatientDataTextField(
                    hintText: 'Enter your Whatsapp number',
                    textController: Provider.of<AuthProvider>(context).whatsappnoController,
                    onChanged: (value) => Provider.of<AuthProvider>(context, listen: false).addNumber(value),
                    labelText: 'Whatsapp Number',
                    keyboardType: TextInputType.number,
                    maxLength: 10,readOnly: false
                  ),


                  const SizedBox(height: 20),
                  _PatientDataTextField(
                    hintText: 'Enter your full address',
                    textController: Provider.of<AuthProvider>(context).AddressController,
                    onChanged: (value) => Provider.of<AuthProvider>(context, listen: false).addAddress(value),
                    labelText: 'Address',readOnly: false
                  ),


                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,), textAlign: TextAlign.left,),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: 'Choose your location',
                    ),
                    value: _selectedLocation,
                    items: _locations.map((location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('Branch',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), hintText: 'Select the branch',),
                    value: _selectedBranch,
                    items: branchNames.map((branch) {
                      return DropdownMenuItem(
                        value: branch, child: Text(branch.toString()),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {

                        _selectedBranch = value;
                        Provider.of<AuthProvider>(context, listen: false).addABranch(_selectedBranch!);
                      });
                    },
                  ),


                  const SizedBox(height: 20),
                  Consumer<AuthProvider>(
                    builder: (context, treatmentProvider, child) {
                      return Column(
                        children: treatmentProvider.selectedTreatments.map((treatment) {

                          // Null safety checks
                          String treatmentName = treatment['treatment'] ?? 'Unknown';
                          String males = treatment['males']?.toString() ?? '0';
                          String females = treatment['females']?.toString() ?? '0';

                          int index = treatmentProvider.selectedTreatments.indexOf(treatment);
                          return Card(
                            child: ListTile(
                              title: Text(treatmentName),
                              subtitle: Text('Males: $males, Females: $females'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      BuildContext dialogContext = context;
                                      return AlertDialog(
                                        elevation: 5,
                                        title: const FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text('Delete'),
                                        ),
                                        content: const SizedBox(
                                          width: double.infinity,
                                          child: Text('Are you sure?'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: Text('NO',
                                              style: TextStyle(color: Colors.teal[400]),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              treatmentProvider.removeTreatment(index);
                                              result.removeAt(index);
                                              Navigator.of(dialogContext).pop();

                                            },
                                            child: Text('YES', style: TextStyle(color: Colors.teal[400]),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),


                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {showtreat();},
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAEAEE6),
                    ),
                        child: const Text('Add Treatments',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                  ),


                  const SizedBox(height: 20),
                  _PatientDataTextField(
                    textController: Provider.of<AuthProvider>(context).totalPriceController,
                    labelText: 'Total Amount',
                    readOnly: true
                  ),



                  const SizedBox(height: 20),
                  _PatientDataTextField(
                      textController: Provider.of<AuthProvider>(context).TotalDiscController,
                      labelText: 'Total Discount',
                      readOnly: true
                  ),




                  const SizedBox(height: 20),
                  const Row(
                    children: [Text('Payment Method',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),

                  Row(children: [
                      Radio<String>(
                        value: 'Cash',
                        groupValue: _paymentOption,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentOption = value;
                          });
                        },
                      ),
                      const Text("Cash"),
                    const Spacer(),
                      Radio<String>(
                        value: 'Card',
                        groupValue: _paymentOption,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentOption = value;
                          });
                        },
                      ),
                      const Text("Card"),
                      const Spacer(),
                      Radio<String>(
                        value: 'UPI',
                        groupValue: _paymentOption,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentOption = value;
                          });
                        },
                      ),
                      const Text("UPI"),
                    ],
                  ),


                  const SizedBox(height: 20),
                  _PatientDataTextField(
                      textController: Provider.of<AuthProvider>(context).AdvanceamountController,
                      labelText: 'Advance Amount',
                      readOnly: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      double? amount = double.tryParse(value);
                      if (amount != null) {
                        Provider.of<AuthProvider>(context,listen: false).addAdvance(amount);
                      }
                    },
                  ),



                  const SizedBox(height: 20),
                  _PatientDataTextField(
                    textController: Provider.of<AuthProvider>(context).BalanceController,
                    labelText: 'Balance Amount',
                    readOnly: true,
                  ),



                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('Treatment Date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,), textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),),
                    child: ListTile(
                      title: Text(_selectedDate == null
                          ? 'No date chosen!'
                          : DateFormat.yMMMd().format(_selectedDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                  ),




                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('Treatment Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                    ),
                    child: ListTile(
                      title: Text(_selectedTime == null
                          ? 'No time chosen!'
                          : _selectedTime!.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(context),
                    ),
                  ),



                  const SizedBox(height: 20,),
                  Consumer<AuthProvider>(
                    builder: (BuildContext context, Savevalues, Widget? child) {
                    return  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if(Savevalues.nameController.text.isNotEmpty && Savevalues.whatsappnoController.text.isNotEmpty
                        &&Savevalues.AddressController.text.isNotEmpty){
                          if(Savevalues.tratmentdetails.isNotEmpty){
                            if(Savevalues.AdvanceamountController.text.isNotEmpty &&
                                _paymentOption!.isNotEmpty && _selectedTime!= null && _selectedDate!= null
                                && Savevalues.whatsappnoController.text.length == 10){

                              treatmentPrices = Savevalues.getTreatmentPrices();
                              String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate!);
                              String formattedTime = TimeOfDay(hour: _selectedTime!.hour, minute: _selectedTime!.minute).format(context);
                              String formattedDateTime = '$formattedDate-$formattedTime';
                              List<String> maleTreatmentIds = Savevalues.getMaleTreatmentIds();
                              List<String> femaleTreatmentIds = Savevalues.getFemaleTreatmentIds();


                              Updatepatient(
                                Savevalues.nameController.text,
                                Savevalues.whatsappnoController.text,
                                Savevalues.AddressController.text,
                                _paymentOption!,
                                double.parse(Savevalues.totalPriceController.text),
                                double.parse(Savevalues.TotalDiscController.text),
                                double.parse(Savevalues.AdvanceamountController.text),
                                formattedDateTime,treatmentPrices,
                                double.parse(Savevalues.BalanceController.text,),
                                 Savevalues.branch,maleTreatmentIds,femaleTreatmentIds
                              );


                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please Enter the value!'),duration: Duration(seconds: 1),),
                              );
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select Treatment'),duration: Duration(seconds: 1),),
                            );
                          }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please Enter the values!'),duration: Duration(seconds: 1),),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Save", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ); },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }





  Widget _PatientDataTextField({
      String? hintText,
    required TextEditingController textController,
     Function(String)? onChanged,
    required String labelText,
    TextInputType? keyboardType,
    int? maxLength,
    required bool readOnly,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(labelText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return TextField(
              controller: textController,
              onChanged: onChanged,
              keyboardType: keyboardType,
              maxLength: maxLength,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                counterText: '', // Hide counter text
              ),
            );
          },
        ),
      ],
    );
  }



  Future showtreat() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Map<String, dynamic>? _selectedTreatmentDialog;
        int _malePatientsDialog = malePatients;
        int _femalePatientsDialog = femalePatients;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Text('Choose Treatment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Consumer<AuthProvider>(
                    builder: (BuildContext context, treatmentProvider, Widget? child) {
                      return DropdownButtonFormField<Map<String, dynamic>>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        isExpanded: true,
                        value: _selectedTreatmentDialog,
                        items: treatmentProvider.TreatmentDetails.map((treatment) {
                          return DropdownMenuItem(
                            value: treatment,
                            child: Text(treatment['name']),
                          );
                        }).toList(),
                        onChanged: (Map<String, dynamic>? value) {
                          setState(() {
                            _selectedTreatmentDialog = value ;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildCounter('Male', _malePatientsDialog, (val) {
                    setState(() {
                      _malePatientsDialog = val;
                    });
                  }),
                  const SizedBox(height: 10),
                  _buildCounter('Female', _femalePatientsDialog, (val) {
                    setState(() {
                      _femalePatientsDialog = val;
                    });
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedTreatmentDialog != null) {
                      setState(() {
                        selectedTreatment = _selectedTreatmentDialog!['name'];
                        malePatients = _malePatientsDialog;
                        femalePatients = _femalePatientsDialog;
                        Provider.of<AuthProvider>(context, listen: false).addTreatment(
                          selectedTreatment!, malePatients, femalePatients,
                          _selectedTreatmentDialog!['price'], _selectedTreatmentDialog!['id'],
                        );
                      });
                      malePatients =0;
                      femalePatients=0;
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a treatment'),duration: Duration(seconds: 1),),
                      );
                    }

                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.zero),
              child: IconButton(
                onPressed: () {
                  if (value > 0) onChanged(value - 1);
                },
                icon: const Icon(Icons.remove),
              ),
            ),
            Text(value.toString()),
            IconButton(
              onPressed: () {
                onChanged(value + 1);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }



  Future<void> generatePdf(
      String name,
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
      List<String> femaleId) async {

    DateTime now = DateTime.now();

    // Format the date
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    // Format the time
    String formattedTime = DateFormat('hh:mm a').format(now);
    List<String> parts = dateAndTime.split('-');
    String date = parts[0];
    String time = parts[1];

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('KUMARAKOM', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563'),
                    pw.Text('e-mail: unknown@gmail.com'),
                    pw.Text('Mob: +91 9876543210 | +91 9876543210'),
                    pw.Text('GST No: 32AABCU9603R1ZW'),
                  ],
                ),
                // Add your logo here if needed
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 15),
            pw.Text('Patient Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),

            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Name:'),
                    pw.SizedBox(height: 5),
                    pw.Text('Address:'),
                    pw.SizedBox(height: 5),
                    pw.Text('WhatsApp Number:'),
                  ],
                ),pw.SizedBox(width: 5),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(name),
                    pw.SizedBox(height: 5),
                    pw.Text(address),
                    pw.SizedBox(height: 5),
                    pw.Text(whatsappNo),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Booked On:'),
                    pw.SizedBox(height: 5),
                    pw.Text('Treatment Date:'),
                    pw.SizedBox(height: 5),
                    pw.Text('Treatment Time:'),
                  ],
                ),pw.SizedBox(width: 5),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('$formattedDate | $formattedTime'),
                    pw.SizedBox(height: 5),
                    pw.Text(date),
                    pw.SizedBox(height: 5),
                    pw.Text(time),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Treatment', style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              context: context,
              data: <List<dynamic>>[
                <String>['Treatment', 'Price', 'Male', 'Female', 'Total'],
                ...treatments.map((treatment) {
                  double price = treatment['price'] is String ? double.parse(treatment['price']) : treatment['price'];
                  int male = treatment['male'] is String ? int.parse(treatment['male']) : treatment['male'];
                  int female = treatment['female'] is String ? int.parse(treatment['female']) : treatment['female'];

                  return  [
                    treatment['name'],
                    (treatment['price'].toString()),
                    treatment['male'].toString(),
                    treatment['female'].toString(),
                    ((male + female) * price).toString(),
                  ];}
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [

                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Total Amount:',style:pw.TextStyle( fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text('Discount:'),
                    pw.SizedBox(height: 5),
                    pw.Text('Advance:'),
                    pw.SizedBox(height: 5),
                    pw.Text('Balance:',style:pw.TextStyle( fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(width: 5),

                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(totalPrice.toString(),style:pw.TextStyle( fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text(totalDiscount.toString()),
                    pw.SizedBox(height: 5),
                    pw.Text(advanceAmount.toString()),
                    pw.SizedBox(height: 5),
                    pw.Text(balance.toString(),style:pw.TextStyle( fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
pw.Spacer(),
pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
  pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('Thank you for choosing us', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Your well-being is our commitment, and we\'re honored '),
        pw.Text('you\'ve entrusted us with your health journey'),
        pw.SizedBox(height: 20),
      ]
  )
]),

          ],
        ),

      ),
    );


    // Get the document directory path
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/patient_details.pdf");

    // Save the PDF to the file
    await file.writeAsBytes(await pdf.save());

    // Display success message
    print("PDF saved to: ${file.path}");

    // Open the PDF
    await OpenFile.open(file.path);
  }



}

