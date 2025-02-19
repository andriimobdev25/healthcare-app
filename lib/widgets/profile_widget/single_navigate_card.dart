import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class SingleNavigateCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback onPressed;
  const SingleNavigateCard({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: subLandMarksCardBg,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          ClipRect(
            child: Image.asset(
              iconUrl,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
