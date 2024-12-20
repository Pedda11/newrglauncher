import 'package:flutter/material.dart';
import 'package:twodotnulllauncher/services/update_service.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('test 3 result'),
              ElevatedButton(onPressed: (){
                UpdateService().updateApp();
              }, child: const Text('update now'))
            ],
          ),
        ),
      ),
    );
  }
}
