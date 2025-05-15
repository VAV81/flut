import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/work_record_service.dart';
import '../theme/theme_provider.dart';
import 'work_input_screen.dart';
import 'history_screen.dart';
import 'work_types_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeContent(),
    WorkInputScreen(),
    HistoryScreen(),
    WorkTypesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Учет рабочего времени'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Добавить'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'История'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Типы'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthYear = DateFormat('MMMM yyyy').format(now);
    final records = WorkRecordService().getAll();

    final currentMonthRecords =
        records
            .where(
              (record) =>
                  record.date.month == now.month &&
                  record.date.year == now.year,
            )
            .toList();

    double totalHours = currentMonthRecords.fold(0, (sum, r) => sum + r.hours);
    double totalEarned = currentMonthRecords.fold(
      0,
      (sum, r) => sum + r.totalEarned,
    );
    double averagePerHour = totalHours > 0 ? totalEarned / totalHours : 0;
    double monthlyEarning = totalHours * averagePerHour;

    final recentRecords = records.take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthYear,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Отработано часов:'),
                      Text(totalHours.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Flexible(
                        child: Text(
                          'Средний заработок:',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${averagePerHour.toStringAsFixed(2)} ₽/час',
                        style: const TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('За месяц:'),
                      Text(
                        '${monthlyEarning.toStringAsFixed(2)} ₽',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Последние записи:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                recentRecords.isEmpty
                    ? const Center(child: Text('Нет записей'))
                    : ListView.builder(
                      itemCount: recentRecords.length,
                      itemBuilder: (context, index) {
                        final record = recentRecords[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(record.workType),
                            subtitle: Text(
                              '${record.hours} ч × ${record.units} шт × ${record.totalEarned.toStringAsFixed(2)} руб',
                            ),
                            trailing: Text(
                              DateFormat('dd.MM').format(record.date),
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
}
