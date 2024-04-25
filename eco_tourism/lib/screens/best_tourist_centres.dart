import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../forms/tourist_centre_form.dart';

class BestTouristCentres extends StatefulWidget {
  const BestTouristCentres({super.key});

  @override
  State<BestTouristCentres> createState() => _BestTouristCentresState();
}

class _BestTouristCentresState extends State<BestTouristCentres> {
  void _confirmDeleteHotel(
      BuildContext context, String documentId, String? imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this tourist_centre?'),
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
        .collection('tourist_centres')
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
          FirebaseFirestore.instance.collection('tourist_centres').snapshots(),
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

        final tourist_centres = snapshot.data!.docs;

        if (tourist_centres.isEmpty) {
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
          itemCount: tourist_centres.length,
          itemBuilder: (context, index) {
            final tourist_centre = tourist_centres[index];
            final name = tourist_centre['name'];
            final location = tourist_centre['location'];
            final price = tourist_centre['price'];
            final description = tourist_centre['description'];
            final datePosted =
                (tourist_centre['datePosted'] as Timestamp).toDate();
            final imageUrl = tourist_centre['imageUrl'];

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
                                        //     context, tourist_centre.id, tourist_centre['imageUrl']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TouristCentreForm(), // Replace DestinationDetailPage() with your actual detail page
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
                                            tourist_centre.id,
                                            tourist_centre['imageUrl']);
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
