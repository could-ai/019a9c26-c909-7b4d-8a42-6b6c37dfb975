import 'dart:math';
import '../models/customer.dart';
import '../models/product.dart';

class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  final List<Customer> _customers = [];
  final List<Product> _products = [];

  // 初始化一些假数据
  void init() {
    if (_customers.isNotEmpty) return;
    
    final random = Random();
    
    // 初始化客户数据
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

    // 初始化产品数据
    if (_products.isEmpty) {
      for (int i = 1; i <= 15; i++) {
        _products.add(Product(
          id: 'PROD-$i',
          name: '产品系列 $i',
          sku: 'SKU-${1000 + i}',
          price: (random.nextInt(500) + 50).toDouble(),
          stock: random.nextInt(100),
          description: '这是产品 $i 的详细描述信息...',
        ));
      }
    }
  }

  // --- Customer Methods ---
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

  // --- Product Methods ---
  List<Product> getProducts() {
    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
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

    // 计算库存总价值
    double inventoryValue = 0;
    int lowStockItems = 0;
    for (var p in _products) {
      inventoryValue += p.price * p.stock;
      if (p.stock < 10) lowStockItems++;
    }

    return {
      'totalCustomers': _customers.length,
      'totalValue': totalValue,
      'newLeads': newLeads,
      'closedDeals': closedDeals,
      'totalProducts': _products.length,
      'inventoryValue': inventoryValue,
      'lowStockItems': lowStockItems,
    };
  }
}
