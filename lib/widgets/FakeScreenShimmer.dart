import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholderText extends StatelessWidget {
  const ShimmerPlaceholderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 16.0,
        width: double.infinity,
        color: Colors.grey,
        margin: const EdgeInsets.only(bottom: 8.0),
      ),
    );
  }
}
