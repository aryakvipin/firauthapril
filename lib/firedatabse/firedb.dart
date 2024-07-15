import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAJyk_z0ewu6mO0l5-yI3LQx75KQMOg0W8",
        appId: "1:941207950066:android:c48504c5fe66b9d155b66b",
        messagingSenderId: "",
        projectId: "mygsignin-1649328089383",
        storageBucket: "mygsignin-1649328089383.appspot.com"),
  );
  runApp(const MaterialApp(
    home: FireBaseCRUD(),
  ));
}

class FireBaseCRUD extends StatefulWidget {
  const FireBaseCRUD({super.key});

  @override
  State<FireBaseCRUD> createState() => _FireBaseCRUDState();
}

class _FireBaseCRUDState extends State<FireBaseCRUD> {
  final cname = TextEditingController();
  final cemail = TextEditingController();
  late CollectionReference _userCollection; // object of collection in db

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection("users");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Data"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final users = snapshot.data!.docs;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userId = user.id;
                  final userName = user["name"];
                  final userEmail = user['email'];

                  return ListTile(
                    title: Text(
                      '$userName',
                      style:
                      const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(
                      '$userEmail',
                      style:
                      const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {
                              editUserData(userId);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteUser(userId);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => createUser(),
        child: const Icon(Icons.add_reaction_outlined),
      ),
    );
  }

  void createUser() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add User"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cname,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: cemail,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              OutlinedButton(
                  onPressed: () => addUsertoDB(cname.text, cemail.text),
                  child: const Text("Create User"))
            ],
          );
        });
  }

  Future<void> addUsertoDB(String name, String email) async {
    return _userCollection.add({'name': name, 'email': email}).then((value) {
      print("User Added Successfully");
      cname.clear();
      cemail.clear();
      Navigator.of(context).pop();
    }).catchError((error) {
      print("Failed to add data $error");
    });
  }

  ///read all the documents through QuerySnapshot
  Stream<QuerySnapshot> readUser() {
    return _userCollection.snapshots();
  }

  ///show bottom sheet to edit userdata
  void editUserData(String userId) {
    var uname = TextEditingController();
    var uemail = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: uname,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: uemail,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      updateUser(userId, uname.text, uemail.text);
                      uname.clear();
                      uemail.clear();
                    },
                    child: const Text("Update User"))
              ],
            ),
          );
        });
  }

  ///update user
  Future<void> updateUser(String userId, String uname, String uemail) async {
    var updatedvalues = {"name": uname, "email": uemail};
    return _userCollection.doc(userId).update(updatedvalues).then((value) {
      Navigator.of(context).pop();
      print("User data updated successfully");
    }).catchError((error) {
      print("User data updation Failed");
    });
  }

  Future<void> deleteUser(var id) async {
    return _userCollection.doc(id).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Deleted Successfully")));
    }).catchError((error){
      print("user deletion failed $error");
    });
  }
}