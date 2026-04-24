import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Management'), centerTitle: true),
      body: const Center(child: Text('Welcome to Store Management!')),
    );
  }
}
