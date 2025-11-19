import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/erp_models.dart';
import 'purchase_order_edit_page.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
  List<PurchaseOrder> _orders = [];
  List<PurchaseOrder> _filteredOrders = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _orders = MockDatabase().getPurchaseOrders();
      _filterOrders(_searchController.text);
    });
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = List.from(_orders);
      } else {
        _filteredOrders = _orders.where((o) =>
          o.id.toLowerCase().contains(query.toLowerCase()) ||
          o.supplierName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Draft': return Colors.grey;
      case 'Ordered': return Colors.blue;
      case 'Received': return Colors.green;
      case 'Cancelled': return Colors.red;
      default: return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索采购订单号或供应商...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterOrders,
            ),
          ),
          // 订单列表
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.receipt_long, color: Colors.orange),
                    ),
                    title: Text('采购订单 ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.supplierName),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(order.orderDate.toString().substring(0, 10), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        )
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border(all: BorderSide(color: _getStatusColor(order.status))),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '¥${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PurchaseOrderEditPage(order: order)),
                      );
                      _loadData(); // 返回后刷新
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PurchaseOrderEditPage()),
          );
          _loadData();
        },
        label: const Text('新建采购订单'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}