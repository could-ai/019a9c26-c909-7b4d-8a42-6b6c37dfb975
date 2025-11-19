import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/erp_models.dart';
import 'employee_edit_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> _employees = [];
  List<Employee> _filteredEmployees = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _employees = MockDatabase().getEmployees();
      _filterEmployees(_searchController.text);
    });
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = List.from(_employees);
      } else {
        _filteredEmployees = _employees.where((e) =>
          e.name.toLowerCase().contains(query.toLowerCase()) ||
          e.department.toLowerCase().contains(query.toLowerCase()) ||
          e.position.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Inactive': return Colors.orange;
      case 'Terminated': return Colors.red;
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
                hintText: '搜索员工姓名、部门或职位...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterEmployees,
            ),
          ),
          // 员工列表
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = _filteredEmployees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        employee.name.substring(0, 1),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${employee.position} - ${employee.department}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(employee.email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                            color: _getStatusColor(employee.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border(all: BorderSide(color: _getStatusColor(employee.status))),
                          ),
                          child: Text(
                            employee.status,
                            style: TextStyle(
                              color: _getStatusColor(employee.status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '¥${employee.salary.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmployeeEditPage(employee: employee)),
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
            MaterialPageRoute(builder: (context) => const EmployeeEditPage()),
          );
          _loadData();
        },
        label: const Text('新建员工'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}