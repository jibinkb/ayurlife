import 'dart:io';
import 'package:ayurlife/Pages/dashboard.dart';
import 'package:ayurlife/providers/providerslist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class GenerateFile extends StatelessWidget {


  const GenerateFile({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, generateProvider, Widget? child) {
        return  WillPopScope(
          onWillPop: () async {
            final token = Provider.of<AuthProvider>(context ,listen: false).token;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard(token: token,)),
            );
            return false; // Prevent default back navigation
          },
          child: Scaffold(
            appBar: AppBar(
            ),
            body:  Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.network('https://lottie.host/cb152d3c-6d31-4752-b4fd-045dd668a17f/bbiUNOhaGO.json'),

                  Center(child: ElevatedButton(onPressed: (){

                    List<Map<String, dynamic>> pdfData = generateProvider.Getgeneratepdf;
                    for (var data in pdfData) {
                      generatePdf(
                          data['name'],data['whatsappNo'],data['address'].toString(),data['paymentOption'],data['totalPrice'],
                          data['totalDiscount'],data['advanceAmount'],data['dateAndTime'],
                          data['treatments'],data['balance'],data['branch'],data['maleId'],data['femaleId']);
                    }



                  },   style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
                  ),

                    child: Text("Veiw Booking Details",style: TextStyle(fontWeight: FontWeight.bold),),),
                  )
                ],
              ),
            ),
          ),
        );
      },
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
                    pw.Text('${formattedDate} | ${formattedTime}'),
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
