import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';
import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hamburguerias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final user =
                  Provider.of<Auth>(context, listen: false).currentUser;
              if (user == null) {
                Navigator.pushNamed(context, '/login');
              } else {
                Navigator.pushNamed(context, '/add_hamburgeria');
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('hamburguerias').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No hamburguerias found'));
          }

          final hamburguerias = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hamburguerias.length,
            itemBuilder: (context, index) {
              final hamburgueria = hamburguerias[index];
              final name = hamburgueria['name'];
              final description = hamburgueria['description'];
              final rating = hamburgueria['rating'];

              return ListTile(
                title: Text(name),
                subtitle: Text('Description: $description\nRating: $rating'),
                leading: const CircleAvatar(
                  foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                ),
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    SampleItemDetailsView.routeName,
                    arguments: hamburgueria.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
