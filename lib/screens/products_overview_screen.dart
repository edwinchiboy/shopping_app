import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

class ProjectOverviewScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My SHop'),
      ),
      body:  ProductGrid(),
    );
  }
}
