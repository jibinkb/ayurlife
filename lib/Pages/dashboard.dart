
import 'package:ayurlife/Models/patientsdetails.dart';
import 'package:ayurlife/ServicePage/GetpatientServices.dart';
import 'package:ayurlife/providers/providerslist.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'newregister.dart';

class Dashboard extends StatefulWidget {
  final String token;

  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardDetails get dashboardservices => GetIt.I<DashboardDetails>();
  String? status;
  PatientDetail? patientDetail;
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    searchPatientList();
  }


  Future<void> searchPatientList({String query = ''}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final response = await dashboardservices.GetPatientslist(widget.token);
    status = response.data['status'].toString();

    if (status == 'true') {
      Navigator.of(context, rootNavigator: true).pop();
      var result = response.data['patient'] != null ? response.data['patient'] : [];
      List<Patient> patients =
      (result as List).map((i) => Patient.fromJson(i)).toList();


      if (query.isNotEmpty) {
        patients = patients.where((patient) {
          return patient.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      Provider.of<AuthProvider>(context, listen: false).setPatients(patients);

    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.asset('assets/logo.png'),
          ),
          title: const Center(child: Text('Patients',style: TextStyle(fontWeight: FontWeight.bold),)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: searchPatientList,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                     Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        searchPatientList(query: _searchController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Text('Sort by:',),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton<String>(
                        value: 'Date',
                        items: <String>['Date', 'Name', 'Package'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, patientProvider, child) {
                    return ListView.builder(
                      itemCount: patientProvider.patients.length,
                      itemBuilder: (context, index) {
                        var patient = patientProvider.patients[index];
                        DateTime dateAndTime = patient.dateAndTime;
                        String formattedDate = DateFormat('yyyy-MM-dd').format(dateAndTime);
                        patientDetail = patient.patientDetails.isNotEmpty ? patient.patientDetails[0] : null;
                        String treatmentName = patientDetail?.treatmentName ?? 'No treatment';

                        return Card(
                          color: const Color(0xFFF4E7E9),
                          margin: const EdgeInsets.all(5.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  '${index + 1} .',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  patient.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treatmentName,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 14),
                                    const SizedBox(width: 4),
                                    Text(formattedDate,),
                                    const Spacer(),
                                    const Icon(Icons.person, size: 14),
                                    const SizedBox(width: 4),
                                    Text(patient.name,),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('View Booking details',),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      onPressed: () {
                                        // Add navigation to details page here
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          extendedPadding: EdgeInsets.all(MediaQuery.of(context).size.width / 3),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewRegister(),
              ),
            );
          },
          label: const Text(
            'Register Now',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade900,
        ),
      ),
    );
  }
}
