class PurchaseOrder {
  final String id;
  String supplierName;
  String supplierContact;
  DateTime orderDate;
  DateTime expectedDeliveryDate;
  String status; // 'Draft', 'Ordered', 'Received', 'Cancelled'
  List<PurchaseOrderItem> items;
  double totalAmount;

  PurchaseOrder({
    required this.id,
    required this.supplierName,
    required this.supplierContact,
    required this.orderDate,
    required this.expectedDeliveryDate,
    required this.status,
    required this.items,
    required this.totalAmount,
  });

  PurchaseOrder copyWith({
    String? id,
    String? supplierName,
    String? supplierContact,
    DateTime? orderDate,
    DateTime? expectedDeliveryDate,
    String? status,
    List<PurchaseOrderItem>? items,
    double? totalAmount,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      supplierContact: supplierContact ?? this.supplierContact,
      orderDate: orderDate ?? this.orderDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

class PurchaseOrderItem {
  final String productId;
  String productName;
  int quantity;
  double unitPrice;
  double totalPrice;

  PurchaseOrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  }) : totalPrice = quantity * unitPrice;
}

class SalesOrder {
  final String id;
  String customerId;
  String customerName;
  DateTime orderDate;
  DateTime expectedDeliveryDate;
  String status; // 'Draft', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled'
  List<SalesOrderItem> items;
  double totalAmount;
  double discount;
  double taxAmount;
  double finalAmount;

  SalesOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.orderDate,
    required this.expectedDeliveryDate,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.discount,
    required this.taxAmount,
  }) : finalAmount = totalAmount - discount + taxAmount;

  SalesOrder copyWith({
    String? id,
    String? customerId,
    String? customerName,
    DateTime? orderDate,
    DateTime? expectedDeliveryDate,
    String? status,
    List<SalesOrderItem>? items,
    double? totalAmount,
    double? discount,
    double? taxAmount,
  }) {
    return SalesOrder(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      orderDate: orderDate ?? this.orderDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      taxAmount: taxAmount ?? this.taxAmount,
    );
  }
}

class SalesOrderItem {
  final String productId;
  String productName;
  int quantity;
  double unitPrice;
  double totalPrice;

  SalesOrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  }) : totalPrice = quantity * unitPrice;
}

class Employee {
  final String id;
  String name;
  String position;
  String department;
  String email;
  String phone;
  double salary;
  DateTime hireDate;
  String status; // 'Active', 'Inactive', 'Terminated'

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.email,
    required this.phone,
    required this.salary,
    required this.hireDate,
    required this.status,
  });

  Employee copyWith({
    String? id,
    String? name,
    String? position,
    String? department,
    String? email,
    String? phone,
    double? salary,
    DateTime? hireDate,
    String? status,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      department: department ?? this.department,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      salary: salary ?? this.salary,
      hireDate: hireDate ?? this.hireDate,
      status: status ?? this.status,
    );
  }
}

class FinancialTransaction {
  final String id;
  String type; // 'Income', 'Expense', 'Transfer'
  String category;
  String description;
  double amount;
  DateTime date;
  String reference; // Invoice number, PO number, etc.

  FinancialTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.reference,
  });

  FinancialTransaction copyWith({
    String? id,
    String? type,
    String? category,
    String? description,
    double? amount,
    DateTime? date,
    String? reference,
  }) {
    return FinancialTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      reference: reference ?? this.reference,
    );
  }
}