import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../data/mock_database.dart';

class CustomerEditPage extends StatefulWidget {
  final Customer? customer;

  const CustomerEditPage({super.key, this.customer});

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _company;
  late String _email;
  late String _phone;
  late String _status;
  late double _potentialValue;

  final List<String> _statusOptions = ['New', 'Contacted', 'Qualified', 'Lost', 'Closed'];

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _name = widget.customer!.name;
      _company = widget.customer!.company;
      _email = widget.customer!.email;
      _phone = widget.customer!.phone;
      _status = widget.customer!.status;
      _potentialValue = widget.customer!.potentialValue;
    } else {
      _name = '';
      _company = '';
      _email = '';
      _phone = '';
      _status = 'New';
      _potentialValue = 0;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final customer = Customer(
        id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        company: _company,
        email: _email,
        phone: _phone,
        status: _status,
        lastContactDate: DateTime.now(),
        potentialValue: _potentialValue,
      );

      if (widget.customer != null) {
        MockDatabase().updateCustomer(customer);
      } else {
        MockDatabase().addCustomer(customer);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存成功')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? '新建客户' : '编辑客户'),
        actions: [
          if (widget.customer != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                MockDatabase().deleteCustomer(widget.customer!.id);
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
                  labelText: '客户姓名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? '请输入姓名' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _company,
                decoration: const InputDecoration(
                  labelText: '公司名称',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (v) => v!.isEmpty ? '请输入公司名称' : null,
                onSaved: (v) => _company = v!,
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
                onSaved: (v) => _email = v ?? '',
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
              const Text('销售详情', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: '当前状态',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
                onSaved: (v) => _status = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _potentialValue.toString(),
                decoration: const InputDecoration(
                  labelText: '潜在价值 (¥)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                onSaved: (v) => _potentialValue = double.tryParse(v ?? '0') ?? 0,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存客户信息', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
