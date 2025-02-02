import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.title,
    this.image,
    this.onTap,
  });
  final String title;
  final String? image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // color: Colors.red,
        // height: 300,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(image!, height: 100.h, fit: BoxFit.fill),
              ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
