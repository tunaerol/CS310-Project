import 'package:flutter/material.dart';

class BuildingCollectionPage extends StatelessWidget {
  const BuildingCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Building Collection')),
      body: const Center(
        child: Text('This is the Building Collection Page'),
      ),
    );
  }
}