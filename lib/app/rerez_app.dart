import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/account_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/generator_screen.dart';
import '../screens/welcome_screen.dart';
import 'app_state.dart';
import 'theme.dart';

class RerezApp extends StatelessWidget {
  const RerezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rerez',
      debugShowCheckedModeBanner: false,
      theme: RerezTheme.dark,
      home: const RerezRoot(),
    );
  }
}

class RerezRoot extends StatefulWidget {
  const RerezRoot({super.key});

  @override
  State<RerezRoot> createState() => _RerezRootState();
}

class _RerezRootState extends State<RerezRoot> {
  int _selectedIndex = 0;

  void _openAuth() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
    );
  }

  void _openGenerator() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!appState.isLoggedIn) {
      return WelcomeScreen(
        onOpenAuth: _openAuth,
        onOpenGenerator: _openGenerator,
      );
    }

    final screens = <Widget>[
      const GeneratorScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: RerezTheme.glassBorder,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_fix_high_rounded),
                label: 'Generate',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
