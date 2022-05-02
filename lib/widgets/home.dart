// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_import, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equipos_flutter/widgets/contenido/Asig_estadio.dart';
import 'package:equipos_flutter/widgets/contenido/capitanes.dart';
import 'package:equipos_flutter/widgets/contenido/equipos.dart';
import 'package:equipos_flutter/widgets/contenido/estadio.dart';
import 'package:equipos_flutter/widgets/contenido/ubicacion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(167, 138, 132, 132),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(199, 91, 167, 255),
        title: const Text('Equipos'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: getMenu(),
    );
  }

  getMenu() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: Equipos(),
                      type: PageTransitionType.scale));
            },
            child: Card(
              color: Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          width: 100,
                          height: 100,
                          image: AssetImage('assets/team.png'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'EQUIPOS',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: Captain(),
                      type: PageTransitionType.scale));
            },
            child: Card(
              color: Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          width: 100,
                          height: 100,
                          image: AssetImage('assets/coach.png'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'CAPITANES',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: Asignar(),
                      type: PageTransitionType.scale));
            },
            child: Card(
              color: Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          width: 100,
                          height: 100,
                          image: AssetImage('assets/assing.png'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ASIGNAR ESTADIO',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: Estadios(),
                      type: PageTransitionType.scale));
            },
            child: Card(
              color: Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          width: 100,
                          height: 100,
                          image: AssetImage('assets/stadium.png'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ESTADIOS',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: Ubicacion(),
                      type: PageTransitionType.scale));
            },
            child: Card(
              color: Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          width: 100,
                          height: 100,
                          image: AssetImage('assets/ubication.png'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'UBICACION',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
