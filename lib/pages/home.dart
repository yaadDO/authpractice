import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('User Accounts'),
      ),
      body: StreamBuilder(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error Loading Users'));
            }
            final data = snapshot.data;
            if(data == null || data.docs.isEmpty) {
              return Center(child: Text('No User Accounts Found'));
            }
            
            return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  final user = data.docs[index].data() as Map<String, dynamic>;

                  final username = user['name'] ?? 'Unnamed';
                  final email = user['email'] ?? 'No email';

                  return ListTile(
                    title: Text(username),
                    subtitle: Text(email),
                  );
                }
            );
          }
      ),
    );
  }
}
