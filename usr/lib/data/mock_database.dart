import 'dart:math';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/erp_models.dart';

class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  final List<Customer> _customers = [];
  final List<Product> _products = [];
  final List<PurchaseOrder> _purchaseOrders = [];
  final List<SalesOrder> _salesOrders = [];
  final List<Employee> _employees = [];
  final List<FinancialTransaction> _financialTransactions = [];

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

    // 初始化员工数据
    final departments = ['销售', '采购', '财务', '人力资源', '技术'];
    final positions = ['经理', '主管', '专员', '助理'];
    if (_employees.isEmpty) {
      for (int i = 1; i <= 12; i++) {
        _employees.add(Employee(
          id: 'EMP-${1000 + i}',
          name: '员工 ${i}',
          position: '${departments[random.nextInt(departments.length)]}${positions[random.nextInt(positions.length)]}',
          department: departments[random.nextInt(departments.length)],
          email: 'employee$i@company.com',
          phone: '139001390${i.toString().padLeft(2, '0')}',
          salary: (random.nextInt(200) + 50) * 1000.0,
          hireDate: DateTime.now().subtract(Duration(days: random.nextInt(365 * 2))),
          status: 'Active',
        ));
      }
    }

    // 初始化采购订单
    if (_purchaseOrders.isEmpty) {
      final suppliers = ['供应商A', '供应商B', '供应商C', '供应商D'];
      final poStatuses = ['Draft', 'Ordered', 'Received', 'Cancelled'];
      for (int i = 1; i <= 8; i++) {
        final items = <PurchaseOrderItem>[];
        final itemCount = random.nextInt(3) + 1;
        double total = 0;
        for (int j = 0; j < itemCount; j++) {
          final product = _products[random.nextInt(_products.length)];
          final qty = random.nextInt(50) + 10;
          final price = product.price * 0.8; // 采购价通常低于销售价
          items.add(PurchaseOrderItem(
            productId: product.id,
            productName: product.name,
            quantity: qty,
            unitPrice: price,
          ));
          total += qty * price;
        }
        _purchaseOrders.add(PurchaseOrder(
          id: 'PO-${1000 + i}',
          supplierName: suppliers[random.nextInt(suppliers.length)],
          supplierContact: 'contact@supplier${random.nextInt(4) + 1}.com',
          orderDate: DateTime.now().subtract(Duration(days: random.nextInt(60))),
          expectedDeliveryDate: DateTime.now().add(Duration(days: random.nextInt(30))),
          status: poStatuses[random.nextInt(poStatuses.length)],
          items: items,
          totalAmount: total,
        ));
      }
    }

    // 初始化销售订单
    if (_salesOrders.isEmpty) {
      final soStatuses = ['Draft', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled'];
      for (int i = 1; i <= 10; i++) {
        final customer = _customers[random.nextInt(_customers.length)];
        final items = <SalesOrderItem>[];
        final itemCount = random.nextInt(4) + 1;
        double total = 0;
        for (int j = 0; j < itemCount; j++) {
          final product = _products[random.nextInt(_products.length)];
          final qty = random.nextInt(20) + 1;
          items.add(SalesOrderItem(
            productId: product.id,
            productName: product.name,
            quantity: qty,
            unitPrice: product.price,
          ));
          total += qty * product.price;
        }
        final discount = total * (random.nextDouble() * 0.1);
        final tax = (total - discount) * 0.13;
        _salesOrders.add(SalesOrder(
          id: 'SO-${1000 + i}',
          customerId: customer.id,
          customerName: customer.name,
          orderDate: DateTime.now().subtract(Duration(days: random.nextInt(45))),
          expectedDeliveryDate: DateTime.now().add(Duration(days: random.nextInt(14))),
          status: soStatuses[random.nextInt(soStatuses.length)],
          items: items,
          totalAmount: total,
          discount: discount,
          taxAmount: tax,
        ));
      }
    }

    // 初始化财务交易
    if (_financialTransactions.isEmpty) {
      final categories = {
        'Income': ['产品销售', '服务收入', '其他收入'],
        'Expense': ['办公用品', '差旅费', '营销费用', '工资支出'],
        'Transfer': ['银行转账', '现金提取']
      };
      for (int i = 1; i <= 25; i++) {
        final type = categories.keys.elementAt(random.nextInt(categories.length));
        final category = categories[type]![random.nextInt(categories[type]!.length)];
        final amount = (random.nextInt(5000) + 500).toDouble();
        _financialTransactions.add(FinancialTransaction(
          id: 'TXN-${10000 + i}',
          type: type,
          category: category,
          description: '${category} - ${DateTime.now().subtract(Duration(days: random.nextInt(90))).toString().substring(0, 10)}',
          amount: amount,
          date: DateTime.now().subtract(Duration(days: random.nextInt(90))),
          reference: type == 'Income' ? 'SO-${1000 + random.nextInt(10)}' : 'REF-${1000 + i}',
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

  // --- Purchase Order Methods ---
  List<PurchaseOrder> getPurchaseOrders() {
    return List.from(_purchaseOrders);
  }

  void addPurchaseOrder(PurchaseOrder order) {
    _purchaseOrders.add(order);
  }

  void updatePurchaseOrder(PurchaseOrder order) {
    final index = _purchaseOrders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _purchaseOrders[index] = order;
    }
  }

  void deletePurchaseOrder(String id) {
    _purchaseOrders.removeWhere((o) => o.id == id);
  }

  // --- Sales Order Methods ---
  List<SalesOrder> getSalesOrders() {
    return List.from(_salesOrders);
  }

  void addSalesOrder(SalesOrder order) {
    _salesOrders.add(order);
  }

  void updateSalesOrder(SalesOrder order) {
    final index = _salesOrders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _salesOrders[index] = order;
    }
  }

  void deleteSalesOrder(String id) {
    _salesOrders.removeWhere((o) => o.id == id);
  }

  // --- Employee Methods ---
  List<Employee> getEmployees() {
    return List.from(_employees);
  }

  void addEmployee(Employee employee) {
    _employees.add(employee);
  }

  void updateEmployee(Employee employee) {
    final index = _employees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      _employees[index] = employee;
    }
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((e) => e.id == id);
  }

  // --- Financial Transaction Methods ---
  List<FinancialTransaction> getFinancialTransactions() {
    return List.from(_financialTransactions);
  }

  void addFinancialTransaction(FinancialTransaction transaction) {
    _financialTransactions.add(transaction);
  }

  void updateFinancialTransaction(FinancialTransaction transaction) {
    final index = _financialTransactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _financialTransactions[index] = transaction;
    }
  }

  void deleteFinancialTransaction(String id) {
    _financialTransactions.removeWhere((t) => t.id == id);
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

    // 财务统计
    double totalRevenue = 0;
    double totalExpenses = 0;
    for (var txn in _financialTransactions) {
      if (txn.type == 'Income') {
        totalRevenue += txn.amount;
      } else if (txn.type == 'Expense') {
        totalExpenses += txn.amount;
      }
    }

    // 订单统计
    int pendingPurchaseOrders = _purchaseOrders.where((o) => o.status == 'Ordered').length;
    int pendingSalesOrders = _salesOrders.where((o) => o.status == 'Confirmed').length;
    double totalSalesValue = _salesOrders.fold(0.0, (sum, order) => sum + order.finalAmount);

    return {
      'totalCustomers': _customers.length,
      'totalValue': totalValue,
      'newLeads': newLeads,
      'closedDeals': closedDeals,
      'totalProducts': _products.length,
      'inventoryValue': inventoryValue,
      'lowStockItems': lowStockItems,
      'totalRevenue': totalRevenue,
      'totalExpenses': totalExpenses,
      'netProfit': totalRevenue - totalExpenses,
      'pendingPurchaseOrders': pendingPurchaseOrders,
      'pendingSalesOrders': pendingSalesOrders,
      'totalSalesValue': totalSalesValue,
      'totalEmployees': _employees.length,
    };
  }
}