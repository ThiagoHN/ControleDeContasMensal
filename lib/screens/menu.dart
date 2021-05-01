import 'package:flutter/material.dart';
import 'login.dart';

class Menu extends StatefulWidget {
  static const routeName = 'Menu';

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.purple[700],
                Colors.indigo[500],
              ],
            )),
          ),
          Center(
            child: Card(
              elevation: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        'O que vamos',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        'aprender?',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Login.routeName),
                            child: Text('Sair')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
