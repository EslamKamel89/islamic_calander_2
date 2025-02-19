import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/features/main_homepage/models/wisdom_model.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';

class IslamicWisdomCard extends StatefulWidget {
  // final String wisdom;
  // final String author;

  const IslamicWisdomCard({
    super.key,
    // required this.wisdom,
    // required this.author,
  });

  @override
  State<IslamicWisdomCard> createState() => _IslamicWisdomCardState();
}

class _IslamicWisdomCardState extends State<IslamicWisdomCard> {
  WisdomModel? wisdom;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.2),
            context.primaryColor.withOpacity(0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        image: const DecorationImage(image: AssetImage(AssetsData.islamicPattern2), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xffFFB800).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          // borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
              child: Text(
                wisdom?.wisdomEn ?? '',
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
            // Container(
            //   padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
            //   child: Text(
            //     '- $author',
            //     textAlign: TextAlign.right,
            //     style: const TextStyle(
            //       fontFamily: 'Scheherazade',
            //       fontSize: 16,
            //       color: Colors.black,
            //       fontStyle: FontStyle.italic,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
