// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_import, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Equipos extends StatefulWidget {
  Equipos({Key? key}) : super(key: key);
  @override
  _EquiposState createState() => _EquiposState();
}

class _EquiposState extends State<Equipos> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _entrenadorController = TextEditingController();
  final TextEditingController _enPrimeraController = TextEditingController();
  final TextEditingController _webController = TextEditingController();

  final CollectionReference _equipo =
      FirebaseFirestore.instance.collection('equipos');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nombreController.text = documentSnapshot['nombre'];
      _entrenadorController.text = documentSnapshot['entrenador'];
      _enPrimeraController.text = documentSnapshot['enPrimera'];
      _webController.text = documentSnapshot['web'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _entrenadorController,
                  decoration: const InputDecoration(labelText: 'Entrenador'),
                ),
                TextField(
                  controller: _enPrimeraController,
                  decoration: const InputDecoration(
                    labelText: 'En Primera',
                  ),
                ),
                TextField(
                  controller: _webController,
                  decoration: const InputDecoration(labelText: 'Web'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: Text(action == 'create' ? 'create' : 'update'),
                    onPressed: () async {
                      final String? Nombre = _nombreController.text;
                      final String? Entrenador = _entrenadorController.text;
                      final String? EnPrimera = _enPrimeraController.text;
                      final String? web = _webController.text;

                      if (Nombre != null &&
                          Entrenador != null &&
                          EnPrimera != null &&
                          web != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _equipo.add({
                            "nombre": Nombre,
                            "entrenador": Entrenador,
                            "enPrimera": EnPrimera,
                            "web": web
                          });
                        }
                        if (action == 'update') {
                          // Update the product
                          await _equipo.doc(documentSnapshot!.id).update({
                            "nombre": Nombre,
                            "entrenador": Entrenador,
                            "enPrimera": EnPrimera,
                            "web": web
                          });
                        }

                        _nombreController.text = "";
                        _entrenadorController.text = "";
                        _enPrimeraController.text = "";
                        _webController.text = "";

                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }

  Future<void> _deleteEquipo(String equipoId) async {
    await _equipo.doc(equipoId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elemento Borrado Correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Equipos'),
        backgroundColor: Colors.cyan,
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _equipo.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['nombre']),
                    subtitle: Text(documentSnapshot['entrenador']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteEquipo(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
