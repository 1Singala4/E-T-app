import 'package:flutter/material.dart';

import 'destination_detail.dart';

class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Text('See All Type'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCardRow([
              buildCustomCard('images/protea_hotel.jpg', 'Protea Hotel'),
              buildCustomCard('images/latitude.webp', 'Latitude Hotel'),
            ]),
            buildCardRow([
              buildCustomCard('images/gule.jpg', 'Title 3'),
              buildCustomCard('images/gule.jpg', 'Title 3'),
              // Add more cards as needed
            ]),
            buildCardRow([
              buildCustomCard('images/gule.jpg', 'Title 3'),
              buildCustomCard('images/gule.jpg', 'Title 3'),
              // Add more cards as needed
            ]),
            // Add more rows as needed
          ],
        ),
      ),
    );
  }

  Widget buildCardRow(List<Widget> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cards,
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
                height: 150,
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
                      fontSize: 16,
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
