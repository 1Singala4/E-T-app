import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_tourism/forms/tourist_centre_form.dart';
import 'package:eco_tourism/models/models.dart';
import 'package:eco_tourism/screens/best_hotels.dart';
import 'package:eco_tourism/screens/see_all.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../forms/cultural_centres_form.dart';
import '../widgets/build_slide.dart';
import '../forms/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'best_cultural_centres.dart';
import 'best_tourist_centres.dart';
import 'best_transports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  int _currentSlide = 0;
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Hotels',
    'Transportation',
    'Tourist Destinations',
    'Culture'
  ];
  String _activeCategory = 'Hotels';
  List<Map<String, dynamic>> hotels = [];

  @override
  void initState() {
    super.initState();
    // Fetch hotel data from Firestore
    checkUserLoginStatus();

    fetchHotels();
  }

  // Function to fetch hotel data from Firestore
  void fetchHotels() async {
    final QuerySnapshot hotelSnapshot =
        await FirebaseFirestore.instance.collection('hotels').get();
    final List<Map<String, dynamic>> fetchedHotels = hotelSnapshot.docs
        .map((doc) => {
              'name': doc['name'],
              'imageUrl': doc['imageUrl'],
            })
        .toList();

    setState(() {
      hotels = fetchedHotels;
    });
  }

  void checkUserLoginStatus() {
    // final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    setState(() {
      _isLoggedIn = user != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        // titleSpacing: 1,
        title: const Text(
          "Travel Malawi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          _isLoggedIn
              ? IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    // Perform logout action
                    FirebaseAuth.instance.signOut().then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout Successful'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        _isLoggedIn = false;
                      });
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout Failed. Please try again.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () async {
                    // Navigate to login page
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                    // Check if login was successful
                    if (result == true) {
                      setState(() {
                        _isLoggedIn = true;
                      });
                    }
                  },
                ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CarouselSlider(
                      items: [
                        buildSlide(
                          'images/gule.jpg',
                          'Experience Malawian Cultural Dances',
                        ),
                        buildSlide(
                          'images/wildlife.jpg',
                          'Slide 2 Title',
                        ),
                        buildSlide(
                          'images/Lake-Malawi.jpg',
                          'Slide 3 Title',
                        ),
                      ],
                      options: CarouselOptions(
                        height: 200, // Adjust height as needed
                        aspectRatio: 4 / 3,
                        viewportFraction: 0.80, // Cover 3/4 of the screen width
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentSlide = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentSlide == index
                                ? const Color.fromRGBO(1, 142, 1, 1)
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                                _activeCategory = _categories[index];
                              });
                              // Filter items based on category
                              // You can implement your filtering logic here
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _selectedCategoryIndex == index
                                    ? const Color.fromRGBO(1, 142, 1, 1)
                                    : const Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  _categories[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: _selectedCategoryIndex == index
                                        ? Colors.white
                                        : const Color.fromRGBO(1, 142, 1, 1),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Best $_activeCategory",
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SeeAllPage(), // Replace DestinationDetailPage() with your actual detail page
                              ),
                            );
                          },
                          child: const Text("See All"),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.245,
                      child: const Scrollbar(
                        child: BestHotels(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
