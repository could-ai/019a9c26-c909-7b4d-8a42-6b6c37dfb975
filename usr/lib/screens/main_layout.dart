import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'customer_list_page.dart';
import 'product_list_page.dart';
import 'financial_dashboard_page.dart';
import 'purchase_order_list_page.dart';
import 'sales_order_list_page.dart';
import 'employee_list_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const CustomerListPage(),
    const ProductListPage(),
    const FinancialDashboardPage(),
    const PurchaseOrderListPage(),
    const SalesOrderListPage(),
    const EmployeeListPage(),
    const Center(child: Text('设置页面 (开发中)')),
  ];

  @override
  Widget build(BuildContext context) {
    // 使用 LayoutBuilder 适配桌面端和移动端
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // 桌面/平板布局：侧边栏
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('仪表盘'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text('客户管理'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2),
                      label: Text('库存管理'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.account_balance_outlined),
                      selectedIcon: Icon(Icons.account_balance),
                      label: Text('财务'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      selectedIcon: Icon(Icons.receipt_long),
                      label: Text('采购订单'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.shopping_bag_outlined),
                      selectedIcon: Icon(Icons.shopping_bag),
                      label: Text('销售订单'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.badge_outlined),
                      selectedIcon: Icon(Icons.badge),
                      label: Text('员工管理'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('设置'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        } else {
          // 移动端布局：底部导航栏
          return Scaffold(
            appBar: AppBar(
              title: const Text('CloudAI ERP'),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: _pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: '仪表盘',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: '客户',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: '库存',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_outlined),
                  selectedIcon: Icon(Icons.account_balance),
                  label: '财务',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: '采购',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: '销售',
                ),
                NavigationDestination(
                  icon: Icon(Icons.badge_outlined),
                  selectedIcon: Icon(Icons.badge),
                  label: '员工',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: '设置',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}