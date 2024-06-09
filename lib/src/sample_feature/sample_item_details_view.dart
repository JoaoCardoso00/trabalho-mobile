import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';

class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key, required this.hamburgeriaId});

  final String hamburgeriaId;

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).currentUser;

    final TextEditingController _ratingController = TextEditingController();
    final TextEditingController _feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('hamburguerias')
                  .doc(hamburgeriaId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('Hamburgueria not found'));
                }

                final hamburgueria = snapshot.data!;
                final reviews =
                    hamburgueria.reference.collection('reviews').snapshots();

                return ListView(
                  children: [
                    ListTile(
                      title: Text(hamburgueria['name']),
                      subtitle: Text(
                          'Description: ${hamburgueria['description']}\nRating: ${hamburgueria['rating']}'),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: reviews,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData) {
                          return Center(child: Text('No reviews yet'));
                        }

                        final reviewDocs = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviewDocs.length,
                          itemBuilder: (context, index) {
                            final review = reviewDocs[index];
                            return ListTile(
                              title: Text(review['feedback']),
                              subtitle: Text('Rating: ${review['rating']}'),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          if (user != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _ratingController,
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _feedbackController,
                decoration: InputDecoration(labelText: 'Feedback'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final rating = double.tryParse(_ratingController.text) ?? 0.0;
                final feedback = _feedbackController.text;

                if (rating > 0 && feedback.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('hamburguerias')
                      .doc(hamburgeriaId)
                      .collection('reviews')
                      .add({
                    'rating': rating,
                    'feedback': feedback,
                    'userId': user.uid,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  _ratingController.clear();
                  _feedbackController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please enter a rating and feedback')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ],
      ),
    );
  }
}
