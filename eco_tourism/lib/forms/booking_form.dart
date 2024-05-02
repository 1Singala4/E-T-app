import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingForm extends StatefulWidget {
  final String placeName;
  final String userName;
  final String userEmail;

  const BookingForm({
    super.key,
    required this.placeName,
    required this.userName,
    required this.userEmail,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  DateTime dateOfEvent = DateTime.now();
  TextEditingController arrivalDateController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  TextEditingController numberOfDaysController = TextEditingController();
  TextEditingController numberOfGuestsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    arrivalDateController.dispose();
    departureDateController.dispose();
    numberOfDaysController.dispose();
    numberOfGuestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 60.0),
                        const Text(
                          "Reservation Form",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Reserve your place of destination",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextFormField(
                          controller: arrivalDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Arrival Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            filled: true,
                            prefixIcon: const Icon(Icons.calendar_month),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the arrival date';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );

                            if (selectedDate != null) {
                              setState(() {
                                dateOfEvent = selectedDate;
                                arrivalDateController.text =
                                    formattedDate(dateOfEvent);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: departureDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Departure Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            filled: true,
                            prefixIcon: const Icon(Icons.calendar_month),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the departure date';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );

                            if (selectedDate != null) {
                              setState(() {
                                dateOfEvent = selectedDate;
                                departureDateController.text =
                                    formattedDate(dateOfEvent);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: numberOfDaysController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Number of Days or Nights",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            filled: true,
                            prefixIcon: const Icon(Icons.night_shelter),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: numberOfGuestsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Number of Guests",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            filled: true,
                            prefixIcon: const Icon(Icons.people),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: _reserve,
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color.fromRGBO(255, 165, 0, 1),
                        ),
                        child: const Text(
                          "Reserve",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String formattedDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  void _reserve() {
    String arrivalDate = arrivalDateController.text;
    String departureDate = departureDateController.text;
    String numberOfDaysNights = numberOfDaysController.text;
    String numberOfGuests = numberOfGuestsController.text;

    FirebaseFirestore.instance.collection('bookings').add({
      'placeName': widget.placeName,
      'userName': widget.userName,
      'userEmail': widget.userEmail,
      'arrivalDate': arrivalDate,
      'departureDate': departureDate,
      'numberOfDaysNights': numberOfDaysNights,
      'numberOfGuests': numberOfGuests,
    }).then((value) {
      // Show a Snackbar with a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reservation successfully made!'),
          duration: const Duration(seconds: 3), // Adjust duration as needed
          action: SnackBarAction(
            label: 'View your Bookings',
            onPressed: () {
              // Navigate to view bookings screen
              // Replace 'ViewBookingsScreen' with your actual screen name
              Navigator.pushReplacementNamed(context, '/viewBookings');
            },
          ),
        ),
      );
    }).catchError((error) {
      print('Error: $error');
    });
  }
}
