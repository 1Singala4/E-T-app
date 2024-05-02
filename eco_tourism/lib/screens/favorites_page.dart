import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          title: const Text('ECO Tourism'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {},
            ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.person))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: Container(
              color: Colors.grey,
            ),
          ),
        ),
        body: const Center(
          child: Text("This is Home Page"),
        ));
  }
}
