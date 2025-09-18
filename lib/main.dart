// Author: Prajeeth
// Class Activity #5 - Digital Pet App with State Management
// Due: 09/18/25

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({Key? key}) : super(key: key);

  @override
  DigitalPetAppState createState() => DigitalPetAppState();
}

class DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  bool isEditingName = false;
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _toggleNameEdit() {
    setState(() {
      if (isEditingName) {
        if (nameController.text.isNotEmpty) {
          petName = nameController.text;
        }
        isEditingName = false;
      } else {
        nameController.text = petName;
        isEditingName = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Pet Image Placeholder
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 4),
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.pets,
                size: 80,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),

            // Pet Name Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isEditingName) ...[
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter pet name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleNameEdit,
                    icon: Icon(Icons.check),
                  ),
                ] else ...[
                  Text(
                    'Name: $petName',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _toggleNameEdit,
                    icon: Icon(Icons.edit),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}