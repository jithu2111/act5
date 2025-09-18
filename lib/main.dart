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
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50;
  bool isEditingName = false;
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  Color _getPetColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  String _getMoodText() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  String _getDogImage() {
    if (happinessLevel > 70) return "assets/images/Happy.png";
    if (happinessLevel >= 30) return "assets/images/Neutral.png";
    return "assets/images/Sad.png";
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

  Widget _buildStatBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value/100',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: _getPetColor(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Pet Image with Mood
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _getPetColor(), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: _getPetColor().withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    Image.asset(
                      _getDogImage(),
                      fit: BoxFit.cover,
                      width: 180,
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 180,
                          height: 180,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.pets,
                            size: 80,
                            color: _getPetColor(),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: _getPetColor().withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
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

            SizedBox(height: 16.0),
            Text(
              'Mood: ${_getMoodText()}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 20.0),

            // Stat Bars
            _buildStatBar('Happiness', happinessLevel, Colors.pink),
            SizedBox(height: 10),
            _buildStatBar('Hunger', hungerLevel, Colors.orange),
            SizedBox(height: 10),
            _buildStatBar('Energy', energyLevel, Colors.blue),
          ],
        ),
      ),
    );
  }
}