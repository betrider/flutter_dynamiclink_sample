import 'package:flutter/material.dart';

class DynamicResultPage extends StatelessWidget {

  const DynamicResultPage({
    Key? key,
    required this.title,
    required this.link,
    required this.id,
  }) : super(key: key);

  final String title;
  final String link;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('link : $link'),
            SizedBox(height: 20,),
            Text('id : $id'),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
