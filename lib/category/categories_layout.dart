import 'package:flutter/material.dart';
import './categories_container.dart';

class CategoriesLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff47443F),
      appBar: AppBar(
        backgroundColor: Color(0xff47443F),
        leading: BackButton(
          color: Color(0xFFFFC823),
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [CategoriesContainer()],
        ),
      ),
    );
  }
}
