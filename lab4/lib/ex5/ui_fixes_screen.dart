import 'package:flutter/material.dart';

class UiFixesScreen extends StatelessWidget {
  const UiFixesScreen({super.key});

  static const titles = [
    'ListView trong Column',
    'Nội dung dài trên màn hình nhỏ',
    'Cập nhật trạng thái',
    'DatePicker với context hợp lệ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 5 - Sửa lỗi UI')),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(titles[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _FixedExampleScreen(index: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FixedExampleScreen extends StatefulWidget {
  const _FixedExampleScreen({required this.index});

  final int index;

  @override
  State<_FixedExampleScreen> createState() => _FixedExampleScreenState();
}

class _FixedExampleScreenState extends State<_FixedExampleScreen> {
  int _count = 0;
  DateTime? _date;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted || date == null) return;
    setState(() {
      _date = date;
    });
  }

  Widget _buildExample() {
    switch (widget.index) {
      case 0:
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Danh sách con vật'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Con vật ${index + 1}'));
                },
              ),
            ),
          ],
        );
      case 1:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                20,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Thông tin con vật ${index + 1}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        );
      case 2:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Số con vật: $_count'),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _count++;
                  });
                },
                child: const Text('Thêm con vật'),
              ),
            ],
          ),
        );
      default:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _pickDate,
                child: const Text('Chọn ngày'),
              ),
              Text(
                _date == null
                    ? 'Chưa chọn ngày'
                    : 'Ngày đã chọn: ${_date!.day}/${_date!.month}/${_date!.year}',
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(UiFixesScreen.titles[widget.index])),
      body: SafeArea(child: _buildExample()),
    );
  }
}
