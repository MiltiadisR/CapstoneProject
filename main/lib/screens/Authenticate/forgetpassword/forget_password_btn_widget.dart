import 'package:flutter/material.dart';

class forgetpasswordbtnwidget extends StatelessWidget {
  const forgetpasswordbtnwidget({
    required this.btnIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData btnIcon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(
              btnIcon,
              size: 60,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
