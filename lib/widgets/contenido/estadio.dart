// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_import, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Estadios extends StatefulWidget {
  Estadios({Key? key}) : super(key: key);
  @override
  _EstadiosState createState() => _EstadiosState();
}

class _EstadiosState extends State<Estadios> {
  final TextEditingController _stadiumController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  final CollectionReference _estadio =
      FirebaseFirestore.instance.collection('estadio');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _stadiumController.text = documentSnapshot['stadium'];
      _capacityController.text = documentSnapshot['capacidad'];
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
                  controller: _stadiumController,
                  decoration: const InputDecoration(labelText: 'Estadio'),
                ),
                TextField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: 'Capacidad'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: Text(action == 'create' ? 'create' : 'update'),
                    onPressed: () async {
                      final String? stadium = _stadiumController.text;
                      final String? capacity = _capacityController.text;

                      if (stadium != null && capacity != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _estadio.add({
                            "stadium": stadium,
                            "capacidad": capacity,
                          });
                        }
                        if (action == 'update') {
                          // Update the product
                          await _estadio.doc(documentSnapshot!.id).update({
                            "stadium": stadium,
                            "capacidad": capacity,
                          });
                        }

                        _stadiumController.text = "";
                        _capacityController.text = "";

                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }

  Future<void> _deleteEstadio(String estadioId) async {
    await _estadio.doc(estadioId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elemento Borrado Correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadios Registrados'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _estadio.snapshots(),
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
                    title: Text(documentSnapshot['capacidad']),
                    subtitle: Text(documentSnapshot['stadium']),
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
                                  _deleteEstadio(documentSnapshot.id)),
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
