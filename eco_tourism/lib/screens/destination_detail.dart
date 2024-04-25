import 'package:flutter/material.dart';

class DestinationDetailPage extends StatefulWidget {
  const DestinationDetailPage({super.key});

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Sliver app bar with center image
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 3,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'images/protea_hotel.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                leading: IconButton(
                  // Custom back button
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white), // Set color to white
                  onPressed: () {
                    Navigator.pop(context); // Navigate back when pressed
                  },
                ),
              ),
              // Sliver list with details
              SliverList(
                delegate: SliverChildListDelegate([
                  // Top circle with center details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Center name
                        const Text(
                          'Protea Hotel',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Location
                        const Text(
                          'Location: Lilongwe',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        // Price description
                        const Text(
                          'MK2,000/night',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        // Price description
                        const Text(
                          'Price Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eget sapien ultrices, tincidunt metus at, porta nulla.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Gallery
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Gallery images
                        GridView.count(
                          crossAxisCount: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            for (int i = 0; i < 6; i++)
                              Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image:
                                        AssetImage('images/protea_hotel.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          // Floating button
          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width / 2 -
                150, // Center horizontally
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 165, 0, 1),
                  minimumSize: const Size(
                    320,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reserve Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Ubuntu",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
