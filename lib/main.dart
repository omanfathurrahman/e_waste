import 'package:e_waste/component/icon_widget.dart';
import 'package:e_waste/extention/to_capitalize.dart';
import 'package:e_waste/screen/buang_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://oexltokstwraweaozqav.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9leGx0b2tzdHdyYXdlYW96cWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ1NjM5OTEsImV4cCI6MjAyMDEzOTk5MX0.4IB_1dfaBU6Ew-CtE4Uvs2Pmfd5SPi1Lan1oe5PSwIU');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: DetailJenisElektronikScreen(),
      home: MainLayout(),
    );
  }
}

enum NavbarOption {
  home,
  buang,
  donasi,
  service,
  profile,
}

List<NavigationDestination> navbarItem = NavbarOption.values
    .map(
      (item) => NavigationDestination(
        icon: IconWidget(item.name),
        label: item.name.capitalize(),
      ),
    )
    .toList();

int _selectedIndex = 0;

List<Widget> _screenOption = <Widget>[
  const HomeScreen(),
  const BuangScreen(),
  const Text(
    'Index 2: Donasi',
  ),
  const Text(
    'Index 3: Service',
  ),
  const Text(
    'Index 4: Profile',
  ),
];

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 1.00),
              end: Alignment(0, -1),
              colors: [Color(0xFFE9EBFF), Color(0xFF8B97FF)],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: _screenOption[_selectedIndex],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: navbarItem,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
        )
      ],
    );
  }
}
