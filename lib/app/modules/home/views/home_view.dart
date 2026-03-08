import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bangla Smart CV Maker'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Create your first professional CV!',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Editor
          Get.toNamed('/editor');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
