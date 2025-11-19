import 'package:flutter/material.dart';
import '../models/erp_models.dart';
import '../data/mock_database.dart';

class EmployeeEditPage extends StatefulWidget {
  final Employee? employee;

  const EmployeeEditPage({super.key, this.employee});

  @override
  State<EmployeeEditPage> createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _position;
  late String _department;
  late String _email;
  late String _phone;
  late double _salary;
  late DateTime _hireDate;
  late String _status;

  final List<String> _departments = ['销售', '采购', '财务', '人力资源', '技术'];
  final List<String> _positions = ['经理', '主管', '专员', '助理', '工程师'];
  final List<String> _statusOptions = ['Active', 'Inactive', 'Terminated'];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _name = widget.employee!.name;
      _position = widget.employee!.position;
      _department = widget.employee!.department;
      _email = widget.employee!.email;
      _phone = widget.employee!.phone;
      _salary = widget.employee!.salary;
      _hireDate = widget.employee!.hireDate;
      _status = widget.employee!.status;
    } else {
      _name = '';
      _position = '专员';
      _department = '销售';
      _email = '';
      _phone = '';
      _salary = 5000;
      _hireDate = DateTime.now();
      _status = 'Active';
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final employee = Employee(
        id: widget.employee?.id ?? 'EMP-${DateTime.now().millisecondsSinceEpoch}',
        name: _name,
        position: _position,
        department: _department,
        email: _email,
        phone: _phone,
        salary: _salary,
        hireDate: _hireDate,
        status: _status,
      );

      if (widget.employee != null) {
        MockDatabase().updateEmployee(employee);
      } else {
        MockDatabase().addEmployee(employee);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('员工信息保存成功')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? '新建员工' : '编辑员工'),
        actions: [
          if (widget.employee != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                MockDatabase().deleteEmployee(widget.employee!.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('基本信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: '员工姓名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? '请输入员工姓名' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _department,
                      decoration: const InputDecoration(
                        labelText: '部门',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (v) => setState(() => _department = v!),
                      onSaved: (v) => _department = v!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _position,
                      decoration: const InputDecoration(
                        labelText: '职位',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      items: _positions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (v) => setState(() => _position = v!),
                      onSaved: (v) => _position = v!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('联系方式', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: '电子邮箱',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) {
                  if (v!.isEmpty) return '请输入邮箱';
                  if (!v.contains('@')) return '请输入有效邮箱';
                  return null;
                },
                onSaved: (v) => _email = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(
                  labelText: '电话号码',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                onSaved: (v) => _phone = v ?? '',
              ),
              const SizedBox(height: 24),
              const Text('工作信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _salary.toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: '薪资 (¥)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return '请输入薪资';
                        if (double.tryParse(v) == null) return '请输入有效数字';
                        return null;
                      },
                      onSaved: (v) => _salary = double.parse(v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _hireDate.toString().substring(0, 10),
                      decoration: const InputDecoration(
                        labelText: '入职日期',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _hireDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => _hireDate = date);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: '员工状态',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
                onSaved: (v) => _status = v!,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存员工信息', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}