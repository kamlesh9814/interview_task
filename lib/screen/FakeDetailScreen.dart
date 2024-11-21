import 'package:flutter/material.dart';
import 'package:interview_task/database/SQLDataBase.dart';
import 'package:interview_task/model/FakeModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FakeDetailScreen extends StatefulWidget {
  final FakeModel model;

  const FakeDetailScreen({super.key, required this.model});

  @override
  FakeDetailScreenState createState() => FakeDetailScreenState();
}

class FakeDetailScreenState extends State<FakeDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _saveDataToDatabase();
  }

  // Save data to the SQLite database
  Future<void> _saveDataToDatabase() async {
    // Prepare the data to be saved
    final data = {
      'id': widget.model.id,
      'title': widget.model.title,
      'imageUrl': widget.model.url,
    };

    // Save data using the DatabaseHelper
    await DatabaseHelperClass().saveData(data);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fake Details View",    style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildDetailScreen(),
    );
  }

  // Build a loading indicator while data is loading
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.teal,
      ),
    );
  }

  // Build the actual UI after data is loaded
  Widget _buildDetailScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Display the image with placeholder and error handling
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: widget.model.url ?? "",
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                width: double.infinity,
                height: 250,
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Display the title after data is loaded
          Text(
            widget.model.title ?? "No Title Available",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Additional data display or UI elements can go here
        ],
      ),
    );
  }
}
