import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';

class IslamicWisdomCard extends StatelessWidget {
  final String wisdom;
  final String author;

  const IslamicWisdomCard({
    super.key,
    required this.wisdom,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        //  A rich gradient reminiscent of traditional Islamic art.
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.8),
            context.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        // color: Colors.white.withOpacity(0.2),
        image: const DecorationImage(image: AssetImage(AssetsData.islamicPattern2), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(20.0),
        // A subtle white border and shadow for a refined look.
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 2,
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black26,
        //     blurRadius: 8,
        //     offset: Offset(2, 2),
        //   )
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Icon(
          //   Icons.nights_stay,
          //   size: 48,
          //   color: Colors.black87,
          // ),
          // const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              wisdom,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // The author of the wisdom.
          Container(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              '- $author',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Scheherazade',
                fontSize: 16,
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
