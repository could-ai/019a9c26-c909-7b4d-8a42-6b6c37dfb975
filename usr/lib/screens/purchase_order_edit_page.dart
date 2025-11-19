import 'package:flutter/material.dart';
import '../models/erp_models.dart';
import '../data/mock_database.dart';

class PurchaseOrderEditPage extends StatefulWidget {
  final PurchaseOrder? order;

  const PurchaseOrderEditPage({super.key, this.order});

  @override
  State<PurchaseOrderEditPage> createState() => _PurchaseOrderEditPageState();
}

class _PurchaseOrderEditPageState extends State<PurchaseOrderEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _supplierName;
  late String _supplierContact;
  late DateTime _orderDate;
  late DateTime _expectedDeliveryDate;
  late String _status;
  late List<PurchaseOrderItem> _items;

  final List<String> _statusOptions = ['Draft', 'Ordered', 'Received', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _supplierName = widget.order!.supplierName;
      _supplierContact = widget.order!.supplierContact;
      _orderDate = widget.order!.orderDate;
      _expectedDeliveryDate = widget.order!.expectedDeliveryDate;
      _status = widget.order!.status;
      _items = List.from(widget.order!.items);
    } else {
      _supplierName = '';
      _supplierContact = '';
      _orderDate = DateTime.now();
      _expectedDeliveryDate = DateTime.now().add(const Duration(days: 7));
      _status = 'Draft';
      _items = [];
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final totalAmount = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
      final order = PurchaseOrder(
        id: widget.order?.id ?? 'PO-${DateTime.now().millisecondsSinceEpoch}',
        supplierName: _supplierName,
        supplierContact: _supplierContact,
        orderDate: _orderDate,
        expectedDeliveryDate: _expectedDeliveryDate,
        status: _status,
        items: _items,
        totalAmount: totalAmount,
      );

      if (widget.order != null) {
        MockDatabase().updatePurchaseOrder(order);
      } else {
        MockDatabase().addPurchaseOrder(order);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('采购订单保存成功')),
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

  @override
  Widget build(BuildContext context) {
    final totalAmount = _items.fold(0.0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? '新建采购订单' : '编辑采购订单'),
        actions: [
          if (widget.order != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                MockDatabase().deletePurchaseOrder(widget.order!.id);
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
              const Text('供应商信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _supplierName,
                decoration: const InputDecoration(
                  labelText: '供应商名称',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (v) => v!.isEmpty ? '请输入供应商名称' : null,
                onSaved: (v) => _supplierName = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _supplierContact,
                decoration: const InputDecoration(
                  labelText: '供应商联系方式',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_mail),
                ),
                onSaved: (v) => _supplierContact = v ?? '',
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
                        labelText: '预计到货日期',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.delivery_dining),
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
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('订单总金额', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('¥${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  child: const Text('保存采购订单', style: TextStyle(fontSize: 16)),
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
  final Function(PurchaseOrderItem) onAdd;

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
    _unitPrice = widget.products.first.price * 0.8; // 默认采购价为销售价的80%
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = widget.products.firstWhere((p) => p.id == _selectedProductId);

    return AlertDialog(
      title: const Text('添加采购产品'),
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
                _unitPrice = widget.products.firstWhere((p) => p.id == v).price * 0.8;
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
            final item = PurchaseOrderItem(
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