import 'package:flutter/material.dart';
import 'package:my_app/data/flowers_data.dart';

class HomeLists extends StatelessWidget {
  const HomeLists({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          FlowerList(),
        ],
      ),
    ));
  }
}
