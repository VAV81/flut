import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/work_model.dart';
import '../services/work_record_service.dart';
import '../services/work_type_service.dart';

class EditRecordScreen extends StatefulWidget {
  final int recordKey;

  const EditRecordScreen({super.key, required this.recordKey});

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  String? _selectedWorkTypeId;
  final _hoursController = TextEditingController();
  final _unitsController = TextEditingController();
  bool _isSaving = false;
  late WorkRecord _originalRecord;
  final WorkTypeService _workTypeService = WorkTypeService();
  final WorkRecordService _recordService = WorkRecordService();
  List<WorkType> _workTypes = [];

  @override
  void initState() {
    super.initState();
    _loadRecord();
    _loadWorkTypes();
  }

  Future<void> _loadRecord() async {
    final record = _recordService.getByKey(widget.recordKey);
    if (record != null) {
      setState(() {
        _originalRecord = record;
        _selectedDate = record.date;
        _hoursController.text = record.hours.toString();
        _unitsController.text = record.units.toString();
      });
    }
  }

  Future<void> _loadWorkTypes() async {
    _workTypes = _workTypeService.getAll();
    if (_workTypes.isNotEmpty) {
      final type = _workTypes.firstWhere(
        (type) => type.name == _originalRecord.workType,
        orElse: () => _workTypes.first,
      );
      _selectedWorkTypeId = type.id;
    }
    setState(() {});
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

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate() && _selectedWorkTypeId != null) {
      setState(() => _isSaving = true);

      try {
        final workType = _workTypes.firstWhere(
          (type) => type.id == _selectedWorkTypeId,
        );

        final hours = double.parse(_hoursController.text);
        final units = int.parse(_unitsController.text);

        final updatedRecord = WorkRecord(
          id: _originalRecord.id,
          date: _selectedDate,
          workType: workType.name,
          hours: hours,
          units: units,
          pricePerUnit: workType.pricePerUnit,
          key: widget.recordKey,
        );

        await _recordService.update(widget.recordKey, updatedRecord);

        if (!mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка при обновлении: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteRecord() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить запись?'),
            content: const Text('Вы уверены, что хотите удалить эту запись?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _recordService.delete(widget.recordKey);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать запись'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isSaving ? null : _deleteRecord,
          ),
        ],
      ),
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
                  value: _selectedWorkTypeId,
                  items:
                      _workTypes.map((type) {
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
                            setState(() => _selectedWorkTypeId = value);
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
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'Сохранить изменения',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
