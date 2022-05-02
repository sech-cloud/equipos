// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_import, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Asignar extends StatefulWidget {
  Asignar({Key? key}) : super(key: key);
  @override
  _AsignarState createState() => _AsignarState();
}

class _AsignarState extends State<Asignar> {
  final TextEditingController _stadiumController = TextEditingController();
  final TextEditingController _teamController = TextEditingController();

  final CollectionReference _asignacion =
      FirebaseFirestore.instance.collection('asignar_estadio');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _stadiumController.text = documentSnapshot['stadium'];
      _teamController.text = documentSnapshot['equipo'];
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
                  controller: _teamController,
                  decoration: const InputDecoration(labelText: 'Equipo'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: Text(action == 'create' ? 'create' : 'update'),
                    onPressed: () async {
                      final String? stadium = _stadiumController.text;
                      final String? team = _teamController.text;

                      if (stadium != null && team != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _asignacion.add({
                            "stadium": stadium,
                            "equipo": team,
                          });
                        }
                        if (action == 'update') {
                          // Update the product
                          await _asignacion.doc(documentSnapshot!.id).update({
                            "stadium": stadium,
                            "equipo": team,
                          });
                        }

                        _stadiumController.text = "";
                        _teamController.text = "";

                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }

  Future<void> _deleteAsignacion(String asignacionId) async {
    await _asignacion.doc(asignacionId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elemento Borrado Correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Estadio'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _asignacion.snapshots(),
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
                    title: Text(documentSnapshot['equipo']),
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
                                  _deleteAsignacion(documentSnapshot.id)),
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
