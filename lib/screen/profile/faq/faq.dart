import 'package:ewaste/screen/default.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Default(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(color: Colors.white, onPressed: () {
            Navigator.pop(context);
          }),
          title: const Text('Frequently Asked Questions',
              style: TextStyle(color: Colors.white)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.deepPurpleAccent[600],
                child: ExpansionTile(
                  title: const Text("FAQ QUESTION TWO"),
                  children: [
                    Container(
                      color: Colors.black12,
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text("Answers for Question Two"),
                    )
                  ],
                ),
              ),
              Card(
                color: Colors.deepPurpleAccent[600],
                child: ExpansionTile(
                  title: const Text("FAQ QUESTION TWO"),
                  children: [
                    Container(
                      color: Colors.black12,
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text("Answers for Question Two"),
                    )
                  ],
                ),
              ),
              Card(
                color: Colors.deepPurpleAccent[600],
                child: ExpansionTile(
                  title: const Text("FAQ QUESTION TWO"),
                  children: [
                    Container(
                      color: Colors.black12,
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text("Answers for Question Two"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
