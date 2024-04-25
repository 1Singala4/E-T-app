import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../forms/cultural_centres_form.dart';

class BestCulturalCentres extends StatefulWidget {
  const BestCulturalCentres({super.key});

  @override
  State<BestCulturalCentres> createState() => _BestCulturalCentresState();
}

class _BestCulturalCentresState extends State<BestCulturalCentres> {
  void _confirmDeleteHotel(
      BuildContext context, String documentId, String? imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this cultural_centre?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteHotel(documentId, imageUrl);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHotel(String documentId, String? imageUrl) async {
    await FirebaseFirestore.instance
        .collection('cultural_centres')
        .doc(documentId)
        .delete();

    if (imageUrl != null) {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('cultural_centres').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
                'Error fetching data. Please check your network connection.'),
          );
        }

        final cultural_centres = snapshot.data!.docs;

        if (cultural_centres.isEmpty) {
          return const Column(
            children: [
              SizedBox(height: 16),
              Center(
                child: Text('No Hotels Posted Yet'),
              ),
            ],
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cultural_centres.length,
          itemBuilder: (context, index) {
            final cultural_centre = cultural_centres[index];
            final name = cultural_centre['name'];
            final location = cultural_centre['location'];
            final price = cultural_centre['price'];
            final description = cultural_centre['description'];
            final datePosted =
                (cultural_centre['datePosted'] as Timestamp).toDate();
            final imageUrl = cultural_centre['imageUrl'];

            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HotelDetails(
                //       title: title,
                //       description: description,
                //       datePosted:
                //           datePosted, // Use datePosted instead of datePosted
                //       imageUrl: imageUrl,
                //     ),
                //   ),
                // );
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10.0), // Border radius for the image
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black
                                  .withOpacity(0.4), // Overlay color
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      tooltip: 'Add to Favorites',
                                      icon: const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        // _confirmDeleteHotel(
                                        //     context, cultural_centre.id, cultural_centre['imageUrl']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CulturalCentresForm(), // Replace DestinationDetailPage() with your actual detail page
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Delete Hotel',
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDeleteHotel(
                                            context,
                                            cultural_centre.id,
                                            cultural_centre['imageUrl']);
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 2,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      unratedColor: Colors.white,
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String formattedDate(DateTime date) {
    return DateFormat('HH:mm, d MMM y').format(date);
  }
}
