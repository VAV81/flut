import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/work_model.dart';
import '../services/work_type_service.dart';

class WorkInputScreen extends StatefulWidget {
  const WorkInputScreen({super.key});

  @override
  State<WorkInputScreen> createState() => _WorkInputScreenState();
}

class _WorkInputScreenState extends State<WorkInputScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedWorkType;
  final _hoursController = TextEditingController();
  final _unitsController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _hoursController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveWork() async {
    if (_formKey.currentState!.validate() && _selectedWorkType != null) {
      setState(() {
        _isSaving = true;
      });

      try {
        final workBox = Hive.box<WorkType>('work_types');
        final recordBox = Hive.box<WorkRecord>('work_records');

        final workType = workBox.values.firstWhere(
          (WorkType type) => type.id == _selectedWorkType,
          orElse: () => workBox.getAt(0)!,
        );

        final record = WorkRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: _selectedDate,
          workType: workType.name,
          hours: double.parse(_hoursController.text),
          units: int.parse(_unitsController.text),
          pricePerUnit: workType.pricePerUnit,
        );

        await recordBox.add(record);

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Запись сохранена')));

        _hoursController.clear();
        _unitsController.clear();
        setState(() {
          _isSaving = false;
          _selectedWorkType = null;
        });
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));

        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workTypes = WorkTypeService().getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Добавить запись')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Дата'),
                    subtitle: Text(
                      DateFormat('dd.MM.yyyy').format(_selectedDate),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _isSaving ? null : () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Тип работы',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedWorkType,
                  items:
                      workTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type.id,
                          child: Text(
                            '${type.name} (${type.pricePerUnit} руб/шт)',
                          ),
                        );
                      }).toList(),
                  onChanged:
                      _isSaving
                          ? null
                          : (value) {
                            setState(() => _selectedWorkType = value);
                          },
                  validator:
                      (value) => value == null ? 'Выберите тип работы' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _hoursController,
                  decoration: const InputDecoration(
                    labelText: 'Часы',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => v!.isEmpty ? 'Введите часы' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _unitsController,
                  decoration: const InputDecoration(
                    labelText: 'Единицы',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Введите единицы' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveWork,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      _isSaving
                          ? const CircularProgressIndicator()
                          : const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
