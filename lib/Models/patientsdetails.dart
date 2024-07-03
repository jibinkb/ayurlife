class Patient {
  final int id;
  final List<PatientDetail> patientDetails;
  final Branch branch;
  final String user;
  final String payment;
  final String name;
  final String phone;
  final String address;
  final double? price;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final DateTime dateAndTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.patientDetails,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateAndTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: _parseInt(json['id']),
      patientDetails: json['patientdetails_set'] != null
          ? (json['patientdetails_set'] as List).map((i) => PatientDetail.fromJson(i)).toList()
          : [],
      branch: Branch.fromJson(json['branch'] ?? {}),
      user: json['user'] ?? '',
      payment: json['payment'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      price: json['price'] != null ? _parseDouble(json['price']) : null,
      totalAmount: _parseDouble(json['total_amount']),
      discountAmount: _parseDouble(json['discount_amount']),
      advanceAmount: _parseDouble(json['advance_amount']),
      balanceAmount: _parseDouble(json['balance_amount']),
      dateAndTime: _parseDateTime(json['date_nd_time']),
      isActive: json['is_active'] ?? false,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }
}

class PatientDetail {
  final int id;
  final int male;
  final int female;
  final int patient;
  final int treatment;
  final String treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    required this.treatment,
    required this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: _parseInt(json['id']),
      male: _parseInt(json['male']),
      female: _parseInt(json['female']),
      patient: _parseInt(json['patient']),
      treatment: _parseInt(json['treatment']),
      treatmentName: json['treatment_name'] ?? '',
    );
  }
}

class Branch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      patientsCount: _parseInt(json['patients_count']),
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      mail: json['mail'] ?? '',
      address: json['address'] ?? '',
      gst: json['gst'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}

int _parseInt(dynamic value) {
  if (value == null) {
    return 0;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString()) ?? 0;
}

double _parseDouble(dynamic value) {
  if (value == null) {
    return 0.0;
  }
  if (value is double) {
    return value;
  }
  return double.tryParse(value.toString()) ?? 0.0;
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }
  if (value is DateTime) {
    return value;
  }
  return DateTime.tryParse(value.toString()) ?? DateTime.now();
}
