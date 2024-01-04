import 'package:e_waste/component/icon_widget.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final List<BottomNavigationBarItem> _navbarItem = [
    const BottomNavigationBarItem(
      icon: IconWidget('home'),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: IconWidget('buang'),
      label: 'Buang',
    ),
    const BottomNavigationBarItem(
      icon: IconWidget('donasi'),
      label: 'Donasi',
    ),
    const BottomNavigationBarItem(
      icon: IconWidget('service'),
      label: 'Service',
    ),
    const BottomNavigationBarItem(
      icon: IconWidget('profile'),
      label: 'Profile',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: const Color.fromARGB(255, 173, 173, 173),
      selectedItemColor: const Color.fromARGB(255, 173, 173, 173),
      showUnselectedLabels: true,
      items: _navbarItem,
    );
  }
}
