import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_tourism/screens/destination_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../forms/cultural_centres_form.dart';

void _confirmDeleteCulturalCentre(
    BuildContext context, String documentId, String? imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content:
            const Text('Are you sure you want to delete this cultural_centre?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteCulturalCentre(documentId, imageUrl);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

void _deleteCulturalCentre(String documentId, String? imageUrl) async {
  await FirebaseFirestore.instance
      .collection('cultural_centres')
      .doc(documentId)
      .delete();

  if (imageUrl != null) {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }
}

class CulturalCentres extends StatefulWidget {
  const CulturalCentres({super.key});

  @override
  State<CulturalCentres> createState() => _CulturalCentresState();
}

class _CulturalCentresState extends State<CulturalCentres> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
          "CulturalCentres",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: _CulturalCentreSearchDelegate());
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cultural_centres')
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

          final culturalCentres = snapshot.data!.docs;

          if (culturalCentres.isEmpty) {
            return const Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('No CulturalCentre Posted Yet'),
              ],
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: culturalCentres.length,
            itemBuilder: (context, index) {
              final culturalCentre = culturalCentres[index];
              final name = culturalCentre['name'];
              final email = culturalCentre['email'];
              final phoneNumber = culturalCentre['phoneNumber'];
              final location = culturalCentre['location'];
              final price = culturalCentre['price'];
              final description = culturalCentre['description'];
              final datePosted =
                  (culturalCentre['datePosted'] as Timestamp).toDate();
              final imageUrl = culturalCentre['imageUrl'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationDetailPage(
                        name: name,
                        location: location,
                        price: price,
                        description: description,
                        datePosted: datePosted,
                        imageUrl: imageUrl,
                        email: email,
                        phoneNumber: phoneNumber,
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
                                          // _confirmDeleteCulturalCentre(
                                          //     context, cultural_centre.id, cultural_centre['imageUrl']);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CulturalCentresForm(),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        tooltip: 'Delete CulturalCentre',
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _confirmDeleteCulturalCentre(
                                              context,
                                              culturalCentre.id,
                                              culturalCentre['imageUrl']);
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

class _CulturalCentreSearchDelegate extends SearchDelegate<String> {
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
      // Show all cultural_centres if query is empty
      return _buildAllCulturalCentres(context);
    } else {
      // Show search results based on the query
      return _buildSearchResults(context);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Show all cultural_centres if query is empty
      return _buildAllCulturalCentres(context);
    } else {
      // Show search suggestions based on the query
      return _buildSearchResults(context);
    }
  }

  Widget _buildAllCulturalCentres(BuildContext context) {
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

        final culturalCentres = snapshot.data!.docs;

        if (culturalCentres.isEmpty) {
          return const Center(
            child: Text('No CulturalCentre Posted Yet'),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: culturalCentres.length,
          itemBuilder: (context, index) {
            final culturalCentre = culturalCentres[index];
            final name = culturalCentre['name'];
            final email = culturalCentre['email'];
            final phoneNumber = culturalCentre['phoneNumber'];
            final location = culturalCentre['location'];
            final price = culturalCentre['price'];
            final description = culturalCentre['description'];
            final datePosted =
                (culturalCentre['datePosted'] as Timestamp).toDate();
            final imageUrl = culturalCentre['imageUrl'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationDetailPage(
                      name: name,
                      location: location,
                      price: price,
                      description: description,
                      datePosted: datePosted,
                      imageUrl: imageUrl,
                      email: email,
                      phoneNumber: phoneNumber,
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
                                        // _confirmDeleteCulturalCentre(
                                        //     context, cultural_centre.id, cultural_centre['imageUrl']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CulturalCentresForm(),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Delete CulturalCentre',
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDeleteCulturalCentre(
                                            context,
                                            culturalCentre.id,
                                            culturalCentre['imageUrl']);
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

        final culturalCentres = snapshot.data!.docs;

        if (culturalCentres.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        final filteredCulturalCentres = culturalCentres.where((culturalCentre) {
          final name = culturalCentre['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

        if (filteredCulturalCentres.isEmpty) {
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
          itemCount: filteredCulturalCentres.length,
          itemBuilder: (context, index) {
            final culturalCentre = filteredCulturalCentres[index];
            final name = culturalCentre['name'];
            final email = culturalCentre['email'];
            final phoneNumber = culturalCentre['phoneNumber'];
            final location = culturalCentre['location'];
            final price = culturalCentre['price'];
            final description = culturalCentre['description'];
            final datePosted =
                (culturalCentre['datePosted'] as Timestamp).toDate();
            final imageUrl = culturalCentre['imageUrl'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationDetailPage(
                      name: name,
                      location: location,
                      price: price,
                      description: description,
                      datePosted: datePosted,
                      imageUrl: imageUrl,
                      email: email,
                      phoneNumber: phoneNumber,
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
                                      tooltip: 'Delete CulturalCentre',
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirmDeleteCulturalCentre(
                                            context,
                                            culturalCentre.id,
                                            culturalCentre['imageUrl']);
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
