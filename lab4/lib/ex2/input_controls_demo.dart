import 'package:flutter/material.dart';

// StatefulWidget cho phép cập nhật giao diện khi người dùng thay đổi giá trị.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _notificationsEnabled = false;
  String _selectedAnimal = 'Mèo';
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || date == null) return;

    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Giá trị Slider: ${_sliderValue.round()}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),

            Text('Thông báo: ${_notificationsEnabled ? 'Bật' : 'Tắt'}'),
            // Switch lưu trạng thái bật hoặc tắt.
            Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            Text('Con vật đã chọn: $_selectedAnimal'),
            RadioGroup<String>(
              groupValue: _selectedAnimal,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedAnimal = value;
                });
              },
              child: const Column(
                children: [
                  RadioListTile<String>(value: 'Mèo', title: Text('Mèo')),
                  RadioListTile<String>(value: 'Chó', title: Text('Chó')),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Chọn ngày'),
            ),
            Text(
              _selectedDate == null
                  ? ''
                  : 'Ngày đã chọn: ${_selectedDate!.day}/'
                        '${_selectedDate!.month}/${_selectedDate!.year}',
            ),
          ],
        ),
      ),
    );
  }
}
