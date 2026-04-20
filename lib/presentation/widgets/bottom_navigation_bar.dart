import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  AppBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: 'study',
        ),
        NavigationDestination(
          icon: const Icon(Icons.fire_extinguisher_outlined),
          selectedIcon: const Icon(Icons.fire_extinguisher),
          label: 'space',
        ),
      ],
    );
  }
}
