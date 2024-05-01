import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_tourism/screens/destination_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../forms/tourist_centre_form.dart';

void _confirmDeleteTouristCentre(
    BuildContext context, String documentId, String? imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content:
            const Text('Are you sure you want to delete this tourist_centre?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTouristCentre(documentId, imageUrl);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

void _deleteTouristCentre(String documentId, String? imageUrl) async {
  await FirebaseFirestore.instance
      .collection('tourist_centres')
      .doc(documentId)
      .delete();

  if (imageUrl != null) {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }
}

class TouristCentres extends StatefulWidget {
  const TouristCentres({super.key});

  @override
  State<TouristCentres> createState() => _TouristCentresState();
}

class _TouristCentresState extends State<TouristCentres> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _tourist_centresStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tourist_centresStream =
        FirebaseFirestore.instance.collection('tourist_centres').snapshots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        // titleSpacing: 1,
        title: const Text(
          "TouristCentres",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: _TouristCentreSearchDelegate());
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tourist_centres')
            .snapshots(),
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
                SizedBox(
                  height: 20,
                ),
                Text('No TouristCentre Posted Yet'),
              ],
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: tourist_centres.length,
            itemBuilder: (context, index) {
              final tourist_centre = tourist_centres[index];
              final name = tourist_centre['name'];
              final email = tourist_centre['email'];
              final phoneNumber = tourist_centre['phoneNumber'];
              final location = tourist_centre['location'];
              final price = tourist_centre['price'];
              final description = tourist_centre['description'];
              final datePosted =
                  (tourist_centre['datePosted'] as Timestamp).toDate();
              final imageUrl = tourist_centre['imageUrl'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationDetailPage(
                        name: name,
                        email: email,
                        phoneNumber: phoneNumber,
                        location: location,
                        price: price,
                        description: description,
                        datePosted: datePosted,
                        imageUrl: imageUrl,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
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
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          // _confirmDeleteTouristCentre(
                                          //     context, tourist_centre.id, tourist_centre['imageUrl']);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TouristCentresForm(),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        tooltip: 'Delete TouristCentre',
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _confirmDeleteTouristCentre(
                                              context,
                                              tourist_centre.id,
                                              tourist_centre['imageUrl']);
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
      ),
    );
  }

  String formattedDate(DateTime date) {
    return DateFormat('HH:mm, d MMM y').format(date);
  }
}

class _TouristCentreSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      // Show all tourist_centres if query is empty
      return _buildAllTouristCentres(context);
    } else {
      // Show search results based on the query
      return _buildSearchResults(context);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Show all tourist_centres if query is empty
      return _buildAllTouristCentres(context);
    } else {
      // Show search suggestions based on the query
      return _buildSearchResults(context);
    }
  }

  Widget _buildAllTouristCentres(BuildContext context) {
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
          return const Center(
            child: Text('No TouristCentre Posted Yet'),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: tourist_centres.length,
          itemBuilder: (context, index) {
            final touristCentre = tourist_centres[index];
            final name = touristCentre['name'];
            final email = touristCentre['email'];
            final phoneNumber = touristCentre['phoneNumber'];
            final location = touristCentre['location'];
            final price = touristCentre['price'];
            final description = touristCentre['description'];
            final datePosted =
                (touristCentre['datePosted'] as Timestamp).toDate();
            final imageUrl = touristCentre['imageUrl'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationDetailPage(
                      name: name,
                      email: email,
                      phoneNumber: phoneNumber,
                      location: location,
                      price: price,
                      description: description,
                      datePosted: datePosted,
                      imageUrl: imageUrl,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
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
                              color: Colors.black.withOpacity(0.4),
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
                                        // _confirmDeleteTouristCentre(
                                        //     context, tourist_centre.id, tourist_centre['imageUrl']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TouristCentresForm(),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Delete TouristCentre',
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDeleteTouristCentre(
                                            context,
                                            touristCentre.id,
                                            touristCentre['imageUrl']);
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

  Widget _buildSearchResults(BuildContext context) {
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
          return const Center(
            child: Text('No results found'),
          );
        }

        final filteredTouristCentres = tourist_centres.where((tourist_centre) {
          final name = tourist_centre['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

        if (filteredTouristCentres.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: filteredTouristCentres.length,
          itemBuilder: (context, index) {
            final touristCentre = filteredTouristCentres[index];
            final name = touristCentre['name'];
            final email = touristCentre['email'];
            final phoneNumber = touristCentre['phoneNumber'];
            final location = touristCentre['location'];
            final price = touristCentre['price'];
            final description = touristCentre['description'];
            final datePosted =
                (touristCentre['datePosted'] as Timestamp).toDate();
            final imageUrl = touristCentre['imageUrl'];

            return GestureDetector(
              onTap: () {
                // Navigate to tourist_centre detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationDetailPage(
                      name: name,
                      email: email,
                      phoneNumber: phoneNumber,
                      location: location,
                      price: price,
                      description: description,
                      datePosted: datePosted,
                      imageUrl: imageUrl,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
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
                              color: Colors.black.withOpacity(0.4),
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
                                        // Add to favorites functionality
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Delete TouristCentre',
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDeleteTouristCentre(
                                            context,
                                            touristCentre.id,
                                            touristCentre['imageUrl']);
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
}
