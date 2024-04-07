import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/build_slide.dart';
import 'destination_detail.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    super.initState();
    // Check user login status when the widget initializes
    checkUserLoginStatus();
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
        titleSpacing: 0,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              // Handle search text changes
            },
          ),
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
                          onPressed: () async {},
                          child: const Text("See All"),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 250,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildCustomCard(
                                    'images/protea_hotel.jpg', 'Protea Hotel'),
                                buildCustomCard(
                                    'images/latitude.webp', 'Latitude Hotel'),
                                buildCustomCard('images/gule.jpg', 'Title 3'),
                                // Add more cards as needed
                              ],
                            ),
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
    );
  }

  Widget buildCustomCard(String imagePath, String title) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Add your onPressed logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DestinationDetailPage(), // Replace DestinationDetailPage() with your actual detail page
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
