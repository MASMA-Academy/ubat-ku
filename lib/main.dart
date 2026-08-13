import 'package:flutter/material.dart';
import 'package:ubatku/theme/app_theme.dart';
import 'package:ubatku/screens/dashboard_screen.dart';
import 'package:ubatku/screens/medicine_list_screen.dart';
import 'package:ubatku/screens/medication_history_screen.dart';
import 'package:ubatku/screens/login_screen.dart';
import 'package:ubatku/screens/profile_screen.dart';

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
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;
  String? _userEmail;

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: (email) {
          setState(() {
            _isLoggedIn = true;
            _userEmail = email;
          });
        },
      );
    }
    return MainNavigation(
      userEmail: _userEmail,
      onLogout: () {
        setState(() {
          _isLoggedIn = false;
          _userEmail = null;
        });
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final String? userEmail;
  final VoidCallback onLogout;

  const MainNavigation({super.key, this.userEmail, required this.onLogout});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = <Widget>[
    DashboardScreen(),
    MedicineListScreen(),
    MedicationHistoryScreen(),
    ProfileScreen(email: widget.userEmail, onLogout: widget.onLogout),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
