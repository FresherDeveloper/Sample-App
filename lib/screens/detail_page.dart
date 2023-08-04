import 'package:flutter/material.dart';
import 'package:sample_app/models/data_model.dart';

class DetailPage extends StatelessWidget {
  final DataModel data;

  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${data.id}'),
            const SizedBox(height: 8),
            Text('Title: ${data.title}'),
            const SizedBox(height: 8),
            Text('Body: ${data.body}'),
          ],
        ),
      ),
    );
  }
}
