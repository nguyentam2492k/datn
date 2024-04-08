import 'package:datn/constants/my_icons.dart';
import 'package:flutter/material.dart';

class SendRequestButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isFormValid;
  final Icon icon;
  final String labelText;

  const SendRequestButton({
    super.key, 
    this.onPressed,
    this.isFormValid = true,
    this.icon = const Icon(MyIcons.send, size: 20,),
    this.labelText = "Gửi yêu cầu"
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton.icon(
          icon: icon,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFormValid ? Colors.blue : Colors.grey,
            foregroundColor: Colors.white
          ),
          onPressed: onPressed, 
          label: Text(labelText),
        ),
      ),
    );
  }
}