import 'package:flutter/material.dart';

import '../models/work_model.dart';
import '../services/work_type_service.dart';

class WorkTypesScreen extends StatefulWidget {
  const WorkTypesScreen({super.key});

  @override
  WorkTypesScreenState createState() => WorkTypesScreenState();
}

class WorkTypesScreenState extends State<WorkTypesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addWorkType() {
    if (_formKey.currentState!.validate()) {
      final workType = WorkType(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        pricePerUnit: double.parse(_priceController.text),
      );

      WorkTypeService().add(workType);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Тип работы добавлен!')));

      _nameController.clear();
      _priceController.clear();
      setState(() {});
    }
  }

  void _deleteWorkType(String id) {
    WorkTypeService().deleteById(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final workTypes = WorkTypeService().getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Типы работ')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название работы',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Введите название' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Цена за единицу',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Введите цену' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addWorkType,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Добавить тип работы'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: workTypes.length,
              itemBuilder: (context, index) {
                final type = workTypes[index];
                return ListTile(
                  title: Text(type.name),
                  subtitle: Text('${type.pricePerUnit} руб/ед'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteWorkType(type.id),
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
