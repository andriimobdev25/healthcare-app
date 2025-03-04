
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/services/analytic/analytic_category_service.dart';

class SignleAnylisticCategoryCard extends StatelessWidget {
  const SignleAnylisticCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AnalyticCategoryService()
          .getAnalyticCategory(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Not create category yet"),
          );
        } else {
          final analytics = snapshot.data;

          // Using SingleChildScrollView with Row for horizontal scrolling
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  analytics!.length,
                  (index) {
                    // Get the analytic category item
                    final category = analytics[index];

                    // Create a square card for each category
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 120, // Fixed width for square
                      height: 120, // Fixed height for square
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Handle category tap
                            // You can navigate to detail page here
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.name, // Display category name
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
