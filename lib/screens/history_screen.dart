import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../services/work_record_service.dart';
import '../utils/helpers.dart' as helpers;
import 'edit_record_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late final WorkRecordService _service;

  @override
  void initState() {
    super.initState();
    _service = WorkRecordService();
    initializeDateFormatting('ru_RU');
  }

  @override
  Widget build(BuildContext context) {
    final records = _service.getByDate(_selectedDay);
    double totalEarned = records.fold(0.0, (sum, r) => sum + r.totalEarned);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('История')),
      body: Column(
        children: [
          TableCalendar<DateTime>(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => helpers.isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            locale: 'ru_RU',
            availableCalendarFormats: const {CalendarFormat.month: 'Месяц'},
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 17,
                color: isDark ? Colors.white : Colors.black,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: isDark ? Colors.white : Colors.black,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              weekendStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
              ),
              holidayTextStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.withAlpha(77), // примерно равно opacity 0.3
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
              rowDecoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.transparent)),
              ),
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final text = DateFormat.E('ru_RU').format(day);
                return Center(
                  child: Text(
                    text.substring(0, min(text.length, 2)).toUpperCase(),
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            daysOfWeekHeight: 32,
            rowHeight: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'За ${DateFormat('d MMMM yyyy', 'ru_RU').format(_selectedDay)}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalEarned.toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child:
                records.isEmpty
                    ? const Center(child: Text('Нет записей на этот день'))
                    : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(record.workType),
                            subtitle: Text(
                              '${record.hours} ч × ${record.units} шт × ${record.pricePerUnit} ₽/шт',
                            ),
                            trailing: Text(
                              '${record.totalEarned.toStringAsFixed(2)} ₽',
                            ),
                            onTap: () async {
                              if (record.key != null) {
                                final result = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditRecordScreen(
                                          recordKey: record.key!,
                                        ),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {}); // Обновляем список
                                }
                              }
                            },
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

int min(int a, int b) => a < b ? a : b;
