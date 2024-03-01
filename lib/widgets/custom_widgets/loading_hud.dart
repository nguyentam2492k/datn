import 'package:flutter/material.dart';

class LoadingHud extends StatelessWidget {
  final double hudHeight;
  final double hudWidth;
  final double loadingHeight;
  final double loadingWidth;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final String text;

  const LoadingHud({
    super.key, 
    this.hudHeight = 110, 
    this.hudWidth = 110, 
    this.loadingHeight = 40, 
    this.loadingWidth = 40, 
    this.backgroundColor = const Color(0xFFF5F5F5), 
    this.borderColor = const Color(0xFFDCDCDC), 
    this.borderRadius = 16, 
    this.text = "Đang gửi..."
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: hudHeight,
        width: hudWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 0.2),
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: SizedBox(
                  height: loadingHeight,
                  width: loadingWidth,
                  child: const CircularProgressIndicator()
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        )
      )
    );
  }
}