import 'dart:math';
import '../models/customer.dart';

class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  final List<Customer> _customers = [];

  // 初始化一些假数据
  void init() {
    if (_customers.isNotEmpty) return;
    
    final random = Random();
    final statuses = ['New', 'Contacted', 'Qualified', 'Lost', 'Closed'];
    
    for (int i = 1; i <= 20; i++) {
      _customers.add(Customer(
        id: i.toString(),
        name: '客户 $i',
        company: '科技公司 $i',
        email: 'contact$i@example.com',
        phone: '138001380${i.toString().padLeft(2, '0')}',
        status: statuses[random.nextInt(statuses.length)],
        lastContactDate: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        potentialValue: (random.nextInt(100) * 1000).toDouble(),
      ));
    }
  }

  List<Customer> getCustomers() {
    return List.from(_customers);
  }

  void addCustomer(Customer customer) {
    _customers.add(customer);
  }

  void updateCustomer(Customer customer) {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
    }
  }

  void deleteCustomer(String id) {
    _customers.removeWhere((c) => c.id == id);
  }

  // 获取统计数据
  Map<String, dynamic> getStats() {
    double totalValue = 0;
    int newLeads = 0;
    int closedDeals = 0;

    for (var c in _customers) {
      totalValue += c.potentialValue;
      if (c.status == 'New') newLeads++;
      if (c.status == 'Closed') closedDeals++;
    }

    return {
      'totalCustomers': _customers.length,
      'totalValue': totalValue,
      'newLeads': newLeads,
      'closedDeals': closedDeals,
    };
  }
}
