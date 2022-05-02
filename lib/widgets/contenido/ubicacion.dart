// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_import, prefer_const_constructors_in_immutables, prefer_adjacent_string_concatenation
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ubicacion extends StatefulWidget {
  Ubicacion({Key? key}) : super(key: key);
  @override
  _UbicacionState createState() => _UbicacionState();
}

class _UbicacionState extends State<Ubicacion> {
  final TextEditingController _stadiumController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();

  final CollectionReference _ubicacion =
      FirebaseFirestore.instance.collection('ubicacion');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _stadiumController.text = documentSnapshot['stadium'];
      _longitudController.text = documentSnapshot['longitud'];
      _latitudController.text = documentSnapshot['latitud'];
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
                  controller: _longitudController,
                  decoration: const InputDecoration(labelText: 'Longitud'),
                ),
                TextField(
                  controller: _latitudController,
                  decoration: const InputDecoration(labelText: 'Latitud'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: Text(action == 'create' ? 'create' : 'update'),
                    onPressed: () async {
                      final String? stadium = _stadiumController.text;
                      final String? longitud = _longitudController.text;
                      final String? latitud = _latitudController.text;

                      if (stadium != null &&
                          latitud != null &&
                          longitud != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _ubicacion.add({
                            "stadium": stadium,
                            "latitud": latitud,
                            "longitud": latitud,
                          });
                        }
                        if (action == 'update') {
                          // Update the product
                          await _ubicacion.doc(documentSnapshot!.id).update({
                            "stadium": stadium,
                            "latitud": latitud,
                            "longitud": longitud,
                          });
                        }

                        _stadiumController.text = "";
                        _latitudController.text = "";
                        _longitudController.text = "";

                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }

  Future<void> _deleteubicacion(String ubicacionId) async {
    await _ubicacion.doc(ubicacionId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elemento Borrado Correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicaciones de Estadios'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _ubicacion.snapshots(),
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
                    title: Text(documentSnapshot['stadium']),
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
                                  _deleteubicacion(documentSnapshot.id)),
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
