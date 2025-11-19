import 'package:flutter/material.dart';
import '../models/erp_models.dart';
import '../data/mock_database.dart';

class SalesOrderEditPage extends StatefulWidget {
  final SalesOrder? order;

  const SalesOrderEditPage({super.key, this.order});

  @override
  State<SalesOrderEditPage> createState() => _SalesOrderEditPageState();
}

class _SalesOrderEditPageState extends State<SalesOrderEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _customerId;
  late String _customerName;
  late DateTime _orderDate;
  late DateTime _expectedDeliveryDate;
  late String _status;
  late List<SalesOrderItem> _items;
  late double _discount;
  late double _taxAmount;

  final List<String> _statusOptions = ['Draft', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled'];
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _customers = MockDatabase().getCustomers();
    if (widget.order != null) {
      _customerId = widget.order!.customerId;
      _customerName = widget.order!.customerName;
      _orderDate = widget.order!.orderDate;
      _expectedDeliveryDate = widget.order!.expectedDeliveryDate;
      _status = widget.order!.status;
      _items = List.from(widget.order!.items);
      _discount = widget.order!.discount;
      _taxAmount = widget.order!.taxAmount;
    } else {
      _customerId = _customers.isNotEmpty ? _customers.first.id : '';
      _customerName = _customers.isNotEmpty ? _customers.first.name : '';
      _orderDate = DateTime.now();
      _expectedDeliveryDate = DateTime.now().add(const Duration(days: 7));
      _status = 'Draft';
      _items = [];
      _discount = 0;
      _taxAmount = 0;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final totalAmount = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
      final finalAmount = totalAmount - _discount + _taxAmount;
      final order = SalesOrder(
        id: widget.order?.id ?? 'SO-${DateTime.now().millisecondsSinceEpoch}',
        customerId: _customerId,
        customerName: _customerName,
        orderDate: _orderDate,
        expectedDeliveryDate: _expectedDeliveryDate,
        status: _status,
        items: _items,
        totalAmount: totalAmount,
        discount: _discount,
        taxAmount: _taxAmount,
      );

      if (widget.order != null) {
        MockDatabase().updateSalesOrder(order);
      } else {
        MockDatabase().addSalesOrder(order);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('销售订单保存成功')),
      );
      Navigator.pop(context);
    }
  }

  void _addItem() {
    final products = MockDatabase().getProducts();
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先添加产品')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(
        products: products,
        onAdd: (item) {
          setState(() {
            _items.add(item);
          });
        },
      ),
    );
  }

  void _updateCustomer(String customerId) {
    final customer = _customers.firstWhere((c) => c.id == customerId);
    setState(() {
      _customerId = customer.id;
      _customerName = customer.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final finalAmount = totalAmount - _discount + _taxAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? '新建销售订单' : '编辑销售订单'),
        actions: [
          if (widget.order != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                MockDatabase().deleteSalesOrder(widget.order!.id);
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
              const Text('客户信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _customerId,
                decoration: const InputDecoration(
                  labelText: '选择客户',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: _customers.map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.name} (${c.company})'),
                )).toList(),
                onChanged: (v) => _updateCustomer(v!),
                validator: (v) => v!.isEmpty ? '请选择客户' : null,
              ),
              const SizedBox(height: 24),
              const Text('订单信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _orderDate.toString().substring(0, 10),
                      decoration: const InputDecoration(
                        labelText: '订单日期',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _orderDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => _orderDate = date);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _expectedDeliveryDate.toString().substring(0, 10),
                      decoration: const InputDecoration(
                        labelText: '预计交货日期',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_shipping),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _expectedDeliveryDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => _expectedDeliveryDate = date);
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
                  labelText: '订单状态',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
                onSaved: (v) => _status = v!,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('订单明细', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('添加产品'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_items.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('暂无订单明细，请添加产品'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.productName),
                        subtitle: Text('数量: ${item.quantity} × ¥${item.unitPrice.toStringAsFixed(2)}'),
                        trailing: Text('¥${item.totalPrice.toStringAsFixed(2)}'),
                        leading: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _items.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
              const Text('财务信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _discount.toStringAsFixed(2),
                      decoration: const InputDecoration(
                        labelText: '折扣金额 (¥)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.discount),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) => setState(() => _discount = double.tryParse(v) ?? 0),
                      onSaved: (v) => _discount = double.tryParse(v ?? '0') ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _taxAmount.toStringAsFixed(2),
                      decoration: const InputDecoration(
                        labelText: '税费 (¥)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) => setState(() => _taxAmount = double.tryParse(v) ?? 0),
                      onSaved: (v) => _taxAmount = double.tryParse(v ?? '0') ?? 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('小计'),
                          Text('¥${totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('折扣'),
                          Text('-¥${_discount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('税费'),
                          Text('+¥${_taxAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('订单总金额', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('¥${finalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存销售订单', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final List<Product> products;
  final Function(SalesOrderItem) onAdd;

  const _AddItemDialog({required this.products, required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  late String _selectedProductId;
  late int _quantity;
  late double _unitPrice;

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.products.first.id;
    _quantity = 1;
    _unitPrice = widget.products.first.price;
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = widget.products.firstWhere((p) => p.id == _selectedProductId);

    return AlertDialog(
      title: const Text('添加销售产品'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedProductId,
            decoration: const InputDecoration(labelText: '选择产品'),
            items: widget.products.map((p) => DropdownMenuItem(
              value: p.id,
              child: Text('${p.name} (¥${p.price})'),
            )).toList(),
            onChanged: (v) {
              setState(() {
                _selectedProductId = v!;
                _unitPrice = widget.products.firstWhere((p) => p.id == v).price;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _quantity.toString(),
                  decoration: const InputDecoration(labelText: '数量'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _quantity = int.tryParse(v) ?? 1,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: _unitPrice.toStringAsFixed(2),
                  decoration: const InputDecoration(labelText: '单价 (¥)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => _unitPrice = double.tryParse(v) ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('总价: ¥${(_quantity * _unitPrice).toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final item = SalesOrderItem(
              productId: _selectedProductId,
              productName: selectedProduct.name,
              quantity: _quantity,
              unitPrice: _unitPrice,
            );
            widget.onAdd(item);
            Navigator.pop(context);
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}