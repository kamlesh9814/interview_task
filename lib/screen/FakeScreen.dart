import 'package:flutter/material.dart';
import 'package:interview_task/providers/FakeModelProvider.dart';
import 'package:interview_task/screen/FakeDetailScreen.dart';
import 'package:interview_task/widgets/FakeScreenShimmer.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class FakeScreen extends StatefulWidget {
  const FakeScreen({super.key});

  @override
  FakeScreenState createState() => FakeScreenState();
}

class FakeScreenState extends State<FakeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // Add listener for infinite scrolling
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of controller to avoid memory leaks
    super.dispose();
  }

  // Infinite scroll logic to load more data
  void _onScroll() {
    final provider = Provider.of<FakeModelProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        provider.hasMoreData) {
      _loadMoreData();
    }
  }

  // Fetch additional data when user scrolls to the bottom
  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Provider.of<FakeModelProvider>(context, listen: false).loadMoreData();
    setState(() {
      _isLoadingMore = false;
    });
  }

  // Navigate to FakeDetailScreen and pass selected item
  void _onItemTap(int index) {
    final provider = Provider.of<FakeModelProvider>(context, listen: false);
    final model = provider.items[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FakeDetailScreen(model: model),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fake Api Data',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<FakeModelProvider>(
        builder: (context, provider, _) {
          // Show placeholder shimmer if no data is available
          if (provider.items.isEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 10, // Fixed shimmer count for placeholders
              itemBuilder: (context, index) {
                return _buildShimmerCard();
              },
            );
          }

          // Main GridView for displaying loaded data
          return Stack(
            children: [
              GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final model = provider.items[index];
                  return GestureDetector(
                    onTap: () => _onItemTap(index),
                    child: _buildDataCard(model),
                  );
                },
              ),
              if (_isLoadingMore)
                const Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(), // Loading indicator for infinite scroll
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Redesigned shimmer card
  Widget _buildShimmerCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: ShimmerPlaceholderText(), // Use ShimmerPlaceholderText widget here
          ),
        ],
      ),
    );
  }

  // Redesigned data card
  Widget _buildDataCard(model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: model.url!,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 40, color: Colors.red),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Text(
              model.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
