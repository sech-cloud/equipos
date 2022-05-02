// ignore_for_file: non_constant_identifier_names, unused_import, unnecessary_import, prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Captain extends StatefulWidget {
  Captain({Key? key}) : super(key: key);
  @override
  _CaptainState createState() => _CaptainState();
}

class _CaptainState extends State<Captain> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teamController = TextEditingController();

  final CollectionReference _capitan =
      FirebaseFirestore.instance.collection('capitanes');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['nombre'];
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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _teamController,
                  decoration: const InputDecoration(labelText: 'Equipo'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: Text(action == 'create' ? 'create' : 'update'),
                    onPressed: () async {
                      final String? Nombre = _nameController.text;
                      final String? Equipo = _teamController.text;

                      if (Nombre != null && Equipo != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _capitan.add({
                            "nombre": Nombre,
                            "equipo": Equipo,
                          });
                        }
                        if (action == 'update') {
                          // Update the product
                          await _capitan.doc(documentSnapshot!.id).update({
                            "nombre": Nombre,
                            "equipo": Equipo,
                          });
                        }

                        _nameController.text = "";
                        _teamController.text = "";

                        Navigator.of(context).pop();
                      }
                    })
              ],
            ),
          );
        });
  }

  Future<void> _deleteEquipo(String capitanId) async {
    await _capitan.doc(capitanId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elemento Borrado Correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Capitanes'),
        backgroundColor: Color(0xFF01579B),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _capitan.snapshots(),
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
                    subtitle: Text(documentSnapshot['nombre']),
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
