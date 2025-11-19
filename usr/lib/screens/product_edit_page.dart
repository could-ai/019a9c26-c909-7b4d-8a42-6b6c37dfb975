import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/mock_database.dart';

class ProductEditPage extends StatefulWidget {
  final Product? product;

  const ProductEditPage({super.key, this.product});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _sku;
  late double _price;
  late int _stock;
  late String _description;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product!.name;
      _sku = widget.product!.sku;
      _price = widget.product!.price;
      _stock = widget.product!.stock;
      _description = widget.product!.description;
    } else {
      _name = '';
      _sku = '';
      _price = 0;
      _stock = 0;
      _description = '';
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final product = Product(
        id: widget.product?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}',
        name: _name,
        sku: _sku,
        price: _price,
        stock: _stock,
        description: _description,
      );

      if (widget.product != null) {
        MockDatabase().updateProduct(product);
      } else {
        MockDatabase().addProduct(product);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('产品保存成功')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? '新建产品' : '编辑产品'),
        actions: [
          if (widget.product != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                MockDatabase().deleteProduct(widget.product!.id);
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
                  labelText: '产品名称',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: (v) => v!.isEmpty ? '请输入产品名称' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _sku,
                decoration: const InputDecoration(
                  labelText: 'SKU (库存单位)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (v) => v!.isEmpty ? '请输入SKU' : null,
                onSaved: (v) => _sku = v!,
              ),
              const SizedBox(height: 24),
              const Text('库存与价格', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _price == 0 ? '' : _price.toString(),
                      decoration: const InputDecoration(
                        labelText: '单价 (¥)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return '请输入价格';
                        if (double.tryParse(v) == null) return '请输入有效数字';
                        return null;
                      },
                      onSaved: (v) => _price = double.parse(v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _stock == 0 ? '' : _stock.toString(),
                      decoration: const InputDecoration(
                        labelText: '库存数量',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return '请输入库存';
                        if (int.tryParse(v) == null) return '请输入整数';
                        return null;
                      },
                      onSaved: (v) => _stock = int.parse(v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('其他信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: '产品描述',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                onSaved: (v) => _description = v ?? '',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存产品', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
