import 'package:flutter/material.dart';
import 'package:ubatku/theme/app_theme.dart';
import 'package:ubatku/screens/dashboard_screen.dart';
import 'package:ubatku/screens/medicine_list_screen.dart';
import 'package:ubatku/screens/medication_history_screen.dart';

void main() {
  runApp(const UbatKuApp());
}

class UbatKuApp extends StatelessWidget {
  const UbatKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UbatKu - Medicine Reminder',
      theme: UbatKuTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    DashboardScreen(),
    MedicineListScreen(),
    MedicationHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicines',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
