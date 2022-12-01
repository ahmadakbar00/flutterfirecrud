import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.collection('users').snapshots(),
          builder: (contenx, snapshots) {
            // membuat tampilan loading ketika sedang meload data
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshots.hasError) {
              return const Center(
                child: Text('ERROR LOAD DATA'),
              );
            }

            // Show Realtime data
            var _data = snapshots.data!.docs;
            return ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onLongPress: () {
                      // hapus ketika ditekan lama
                      // db.collection('users').doc(_data[index].id).delete(); //cara tak efektif
                      _data[index].reference.delete().then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Data Berhasil Dihapus'),
                          )));
                    },
                    subtitle: Text(_data[index].data()['born'].toString()),
                    title: Text(_data[index].data()['first'] +
                        ' ' +
                        _data[index].data()['last']),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create a new user with a first and last name
          final user = <String, dynamic>{
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
          };

          // Add a new document with a generated ID
          db.collection("users").add(user).then((DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));

          // Menambahkan data dengan set nama datanya
          // db.collection("users").doc("data1").set(user).then((doc) =>
          //     print('DocumentSnapshot added'));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
