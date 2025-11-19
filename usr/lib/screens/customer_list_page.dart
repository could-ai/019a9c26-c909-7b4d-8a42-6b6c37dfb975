import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/customer.dart';
import 'customer_edit_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _customers = MockDatabase().getCustomers();
      _filterCustomers(_searchController.text);
    });
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = List.from(_customers);
      } else {
        _filteredCustomers = _customers.where((c) =>
          c.name.toLowerCase().contains(query.toLowerCase()) ||
          c.company.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New': return Colors.blue;
      case 'Contacted': return Colors.orange;
      case 'Qualified': return Colors.teal;
      case 'Lost': return Colors.grey;
      case 'Closed': return Colors.green;
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
                hintText: '搜索客户姓名或公司...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterCustomers,
            ),
          ),
          // 客户列表
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        customer.name.substring(0, 1),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.company),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(customer.email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                            color: _getStatusColor(customer.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatusColor(customer.status)),
                          ),
                          child: Text(
                            customer.status,
                            style: TextStyle(
                              color: _getStatusColor(customer.status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '¥${customer.potentialValue.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomerEditPage(customer: customer)),
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
            MaterialPageRoute(builder: (context) => const CustomerEditPage()),
          );
          _loadData();
        },
        label: const Text('新建客户'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
