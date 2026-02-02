import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget{

  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Design')
      ),
      body: Center(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 800),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  // Wide layout
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildContent()
                      ),
                  ],
                );
              } else {
            return Column(
              // narrow layout
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(),
                SizedBox(height: 20),
                _buildContent(),
                ],
               );
              }
            }
          ),
        ),
      ),
    );
  }
}


// Function that returns a widget
Widget _buildAvatar() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.blueAccent
    ),
    padding: EdgeInsets.all(16),
     child: Icon(Icons.person, size: 50, color: Colors.white),
  );
}

// Content widget for the profile
Widget _buildContent() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start, // Left justifies 
    children: [
       Text('Poindexter Dankworth',
       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
       ),
       Text('Major: Computer Science'),
       Text('Favorite Class: Algo Analysis'),
       SizedBox(height: 20),
       ElevatedButton(
        onPressed: (){}, 
        child: Text('Log In')
        ),
    ],
    );
}