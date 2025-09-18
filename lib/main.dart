// Author: Prajeeth
// Class Activity #5 - Digital Pet App with State Management
// Due: 09/18/25

import 'package:flutter/material.dart';
import 'dart:async';

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
Timer? _hungerTimer;
Timer? _winTimer;
bool gameOver = false;
bool hasWon = false;
bool isEditingName = false;
TextEditingController nameController = TextEditingController();
DateTime? highHappinessStart;
String selectedActivity = 'Play with Ball';

@override
void initState() {
super.initState();
_startHungerTimer();
}

@override
void dispose() {
_hungerTimer?.cancel();
_winTimer?.cancel();
nameController.dispose();
super.dispose();
}

void _startHungerTimer() {
_hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
if (!gameOver && !hasWon) {
setState(() {
hungerLevel += 10;
if (hungerLevel > 100) {
hungerLevel = 100;
}
if (hungerLevel > 70) {
happinessLevel -= 5;
}
_checkGameConditions();
});
}
});
}

void _checkGameConditions() {
if (hungerLevel >= 100 && happinessLevel <= 10) {
setState(() {
gameOver = true;
});
_hungerTimer?.cancel();
_winTimer?.cancel();
} else if (happinessLevel > 80) {
if (highHappinessStart == null) {
highHappinessStart = DateTime.now();
_winTimer = Timer(Duration(minutes: 3), () {
if (happinessLevel > 80 && !gameOver) {
setState(() {
hasWon = true;
});
}
});
}
} else {
highHappinessStart = null;
_winTimer?.cancel();
}
}

void _playWithPet() {
if (gameOver || hasWon) return;
setState(() {
happinessLevel = (happinessLevel + 10).clamp(0, 100);
energyLevel = (energyLevel + 15).clamp(0, 100);
_updateHunger();
_checkGameConditions();
});
}

void _feedPet() {
if (gameOver || hasWon) return;
setState(() {
hungerLevel = (hungerLevel - 10).clamp(0, 100);
_updateHappiness();
_checkGameConditions();
});
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

void _performActivity() {
if (gameOver || hasWon) return;
setState(() {
switch (selectedActivity) {
case 'Play with Ball':
happinessLevel = (happinessLevel + 15).clamp(0, 100);
energyLevel = (energyLevel + 10).clamp(0, 100);
hungerLevel = (hungerLevel + 8).clamp(0, 100);
break;
case 'Go for Walk':
happinessLevel = (happinessLevel + 20).clamp(0, 100);
energyLevel = (energyLevel + 25).clamp(0, 100);
hungerLevel = (hungerLevel + 12).clamp(0, 100);
break;
case 'Take Nap':
energyLevel = (energyLevel + 30).clamp(0, 100);
happinessLevel = (happinessLevel + 5).clamp(0, 100);
hungerLevel = (hungerLevel + 5).clamp(0, 100);
break;
case 'Learn Tricks':
happinessLevel = (happinessLevel + 25).clamp(0, 100);
energyLevel = (energyLevel + 5).clamp(0, 100);
hungerLevel = (hungerLevel + 10).clamp(0, 100);
break;
case 'Grooming':
happinessLevel = (happinessLevel + 12).clamp(0, 100);
energyLevel = (energyLevel + 8).clamp(0, 100);
hungerLevel = (hungerLevel + 3).clamp(0, 100);
break;
}
_checkGameConditions();
});
}

void _resetGame() {
setState(() {
petName = "Your Pet";
happinessLevel = 50;
hungerLevel = 50;
energyLevel = 50;
gameOver = false;
hasWon = false;
isEditingName = false;
highHappinessStart = null;
selectedActivity = 'Play with Ball';
});
_hungerTimer?.cancel();
_winTimer?.cancel();
_startHungerTimer();
}

@override
Widget build(BuildContext context) {
if (gameOver) {
return Scaffold(
appBar: AppBar(
title: Text('Digital Pet'),
backgroundColor: Colors.red,
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'💀 GAME OVER 💀',
style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
),
SizedBox(height: 20),
Text(
'Your pet became too hungry and unhappy!',
style: TextStyle(fontSize: 18),
),
SizedBox(height: 30),
ElevatedButton(
onPressed: _resetGame,
child: Text('Try Again'),
style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
),
],
),
),
);
}

if (hasWon) {
return Scaffold(
appBar: AppBar(
title: Text('Digital Pet'),
backgroundColor: Colors.green,
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'🎉 YOU WON! 🎉',
style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
),
SizedBox(height: 20),
Text(
'You kept your pet happy for 3 minutes!',
style: TextStyle(fontSize: 18),
),
SizedBox(height: 30),
ElevatedButton(
onPressed: _resetGame,
child: Text('Play Again'),
style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
),
],
),
),
);
}

return Scaffold(
appBar: AppBar(
title: Text('Digital Pet'),
backgroundColor: _getPetColor(),
),
body: SingleChildScrollView(
child: Padding(
padding: EdgeInsets.all(20.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
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

_buildStatBar('Happiness', happinessLevel, Colors.pink),
SizedBox(height: 10),
_buildStatBar('Hunger', hungerLevel, Colors.orange),
SizedBox(height: 10),
_buildStatBar('Energy', energyLevel, Colors.blue),

SizedBox(height: 20.0),

Container(
padding: EdgeInsets.all(15),
decoration: BoxDecoration(
border: Border.all(color: Colors.grey),
borderRadius: BorderRadius.circular(10),
),
child: Column(
children: [
Text(
'Select Activity:',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
SizedBox(height: 10),
DropdownButton<String>(
value: selectedActivity,
isExpanded: true,
items: [
DropdownMenuItem(value: 'Play with Ball', child: Text('🏀 Play with Ball')),
DropdownMenuItem(value: 'Go for Walk', child: Text('🚶 Go for Walk')),
DropdownMenuItem(value: 'Take Nap', child: Text('😴 Take Nap')),
DropdownMenuItem(value: 'Learn Tricks', child: Text('🎓 Learn Tricks')),
DropdownMenuItem(value: 'Grooming', child: Text('✨ Grooming')),
],
onChanged: (String? newValue) {
setState(() {
selectedActivity = newValue!;
});
},
),
SizedBox(height: 15),
ElevatedButton.icon(
onPressed: _performActivity,
icon: Icon(Icons.play_arrow),
label: Text('Do Activity'),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.purple,
foregroundColor: Colors.white,
),
),
],
),
),

SizedBox(height: 20.0),

Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
ElevatedButton.icon(
onPressed: _playWithPet,
icon: Icon(Icons.sports_esports),
label: Text('Quick Play'),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
),
ElevatedButton.icon(
onPressed: _feedPet,
icon: Icon(Icons.restaurant),
label: Text('Feed'),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
),
),
],
),

SizedBox(height: 20),

if (highHappinessStart != null)
Container(
padding: EdgeInsets.all(10),
decoration: BoxDecoration(
color: Colors.green.withOpacity(0.2),
borderRadius: BorderRadius.circular(10),
),
child: Text(
'🏆 Keep happiness above 80 for 3 minutes to win!',
style: TextStyle(fontWeight: FontWeight.bold),
),
),
],
),
),
),
);
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
}