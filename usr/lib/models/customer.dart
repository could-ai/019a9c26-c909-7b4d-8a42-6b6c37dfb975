class Customer {
  final String id;
  String name;
  String company;
  String email;
  String phone;
  String status; // 'New', 'Contacted', 'Qualified', 'Lost', 'Closed'
  DateTime lastContactDate;
  double potentialValue;

  Customer({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.status,
    required this.lastContactDate,
    required this.potentialValue,
  });

  // 复制对象用于修改
  Customer copyWith({
    String? id,
    String? name,
    String? company,
    String? email,
    String? phone,
    String? status,
    DateTime? lastContactDate,
    double? potentialValue,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      potentialValue: potentialValue ?? this.potentialValue,
    );
  }
}
