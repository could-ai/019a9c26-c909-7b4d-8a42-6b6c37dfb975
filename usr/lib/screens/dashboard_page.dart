import 'package:flutter/material.dart';
import '../data/mock_database.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = MockDatabase().getStats();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '仪表盘',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // 统计卡片网格
          LayoutBuilder(
            builder: (context, constraints) {
              // 响应式布局：宽屏显示4列，窄屏显示2列
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
                    '总客户数', 
                    stats['totalCustomers'].toString(), 
                    Icons.people, 
                    Colors.blue
                  ),
                  _buildStatCard(
                    context, 
                    '潜在总价值', 
                    '¥${(stats['totalValue'] / 10000).toStringAsFixed(1)}万', 
                    Icons.attach_money, 
                    Colors.green
                  ),
                  _buildStatCard(
                    context, 
                    '新线索', 
                    stats['newLeads'].toString(), 
                    Icons.new_releases, 
                    Colors.orange
                  ),
                  _buildStatCard(
                    context, 
                    '已成交', 
                    stats['closedDeals'].toString(), 
                    Icons.check_circle, 
                    Colors.purple
                  ),
                ],
              );
            }
          ),
          const SizedBox(height: 30),
          Text(
            '最近活动',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.history, size: 20, color: Colors.grey),
                  ),
                  title: Text('跟进记录 #100${index + 1}'),
                  subtitle: Text('系统自动记录 - ${DateTime.now().subtract(Duration(hours: index * 2)).toString().substring(0, 16)}'),
                  trailing: const Icon(Icons.chevron_right),
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
