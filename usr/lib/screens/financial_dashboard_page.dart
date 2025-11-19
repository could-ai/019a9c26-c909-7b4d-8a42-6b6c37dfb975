import 'package:flutter/material.dart';
import '../data/mock_database.dart';

class FinancialDashboardPage extends StatelessWidget {
  const FinancialDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = MockDatabase().getStats();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '财务仪表盘',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // 财务指标网格
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                childAspectRatio: 1.5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    context, 
                    '总收入', 
                    '¥${(stats['totalRevenue'] / 10000).toStringAsFixed(1)}万', 
                    Icons.trending_up, 
                    Colors.green
                  ),
                  _buildStatCard(
                    context, 
                    '总支出', 
                    '¥${(stats['totalExpenses'] / 10000).toStringAsFixed(1)}万', 
                    Icons.trending_down, 
                    Colors.red
                  ),
                  _buildStatCard(
                    context, 
                    '净利润', 
                    '¥${(stats['netProfit'] / 10000).toStringAsFixed(1)}万', 
                    Icons.account_balance_wallet, 
                    stats['netProfit'] >= 0 ? Colors.blue : Colors.red
                  ),
                  _buildStatCard(
                    context, 
                    '销售总额', 
                    '¥${(stats['totalSalesValue'] / 10000).toStringAsFixed(1)}万', 
                    Icons.shopping_cart, 
                    Colors.purple
                  ),
                ],
              );
            }
          ),
          const SizedBox(height: 30),
          Text(
            '近期财务活动',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final transactions = MockDatabase().getFinancialTransactions()
                  ..sort((a, b) => b.date.compareTo(a.date));
                if (index >= transactions.length) return const SizedBox.shrink();
                final txn = transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: txn.type == 'Income' ? Colors.green[100] : 
                                    txn.type == 'Expense' ? Colors.red[100] : Colors.blue[100],
                    child: Icon(
                      txn.type == 'Income' ? Icons.arrow_upward : 
                      txn.type == 'Expense' ? Icons.arrow_downward : Icons.swap_horiz,
                      color: txn.type == 'Income' ? Colors.green : 
                             txn.type == 'Expense' ? Colors.red : Colors.blue,
                      size: 20,
                    ),
                  ),
                  title: Text(txn.description),
                  subtitle: Text('${txn.category} • ${txn.date.toString().substring(0, 10)}'),
                  trailing: Text(
                    '${txn.type == 'Expense' ? '-' : '+'}¥${txn.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: txn.type == 'Income' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Icon(icon, color: color, size: 24),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}