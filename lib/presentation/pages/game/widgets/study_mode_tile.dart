import 'package:flutter/material.dart';

class StudyModeTile extends StatelessWidget {
  final String studyModeName;
  final bool isActive;
  final VoidCallback onTap;
  StudyModeTile({super.key, required this.studyModeName, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(studyModeName, style: TextStyle(
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal
      ),),
      trailing: Icon(Icons.play_arrow),
      subtitle: isActive ? Text("Active") : null,
      onTap: onTap,
    );
  }
}