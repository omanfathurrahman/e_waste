import 'package:e_waste/component/navbar_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/143035475_1029718927553677_5869815052519506947_n 1.png",
                  ),
                  const Text("John Mayer")
                ],
              ),
              ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    splashColor: Colors.red, // Splash color
                    onTap: () {},
                    child: const SizedBox(
                        width: 56, height: 56, child: Icon(Icons.menu)),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
