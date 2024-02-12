
import 'package:e_waste/component/icon_widget.dart';
import 'package:e_waste/extention/to_capitalize.dart';
import 'package:e_waste/screen/buang/buang_screen.dart';
import 'package:e_waste/screen/donasi/donasi_screen.dart';
import 'package:e_waste/screen/home/home_screen.dart';
import 'package:e_waste/screen/profile/profile_screen.dart';
import 'package:e_waste/screen/service/service_screen.dart';
import 'package:flutter/material.dart';

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

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.curScreenIndex = 0});
  final int curScreenIndex;
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int selectedIndex;

  void gantiScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    selectedIndex = widget.curScreenIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screenOption = <Widget>[
      HomeScreen(
        gantiScreen: gantiScreen,
      ),
      const BuangScreen(),
      const DonasiScreen(),
      const ServiceScreen(),
      const ProfileScreen(),
    ];

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
            child: screenOption[selectedIndex],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: navbarItem,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        )
      ],
    );
  }
}
