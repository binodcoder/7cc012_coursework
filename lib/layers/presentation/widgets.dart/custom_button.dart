import 'package:blog_app/resources/values_manager.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Size size;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s50,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text(
          text,
        ),
      ),
    );
  }
}

// decoration: BoxDecoration(
// borderRadius: const BorderRadius.all(Radius.circular(6)),
// boxShadow: <BoxShadow>[
// BoxShadow(
// color: Colors.grey.shade200,
// offset: const Offset(2, 4),
// blurRadius: 5,
// spreadRadius: 2,
// ),
// ],
// gradient: LinearGradient(
// begin: Alignment.centerLeft,
// end: Alignment.centerRight,
// colors: [
// ColorManager.lightBlue,
// ColorManager.primary,
// ],
// ),
// ),
