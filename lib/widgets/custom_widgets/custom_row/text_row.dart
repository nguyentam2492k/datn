import 'package:flutter/material.dart';

class CustomTextRow extends StatefulWidget {
  final String labelText;
  final String text;

  const CustomTextRow({
    super.key, 
    this.labelText = 'LabelText', 
    this.text = 'Read-Only Text', 
  });

  @override
  State<StatefulWidget> createState() {
    return CustomTextRowState();
  }
}

class CustomTextRowState extends State<CustomTextRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
              child: Text(
                widget.labelText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          Flexible(
            flex: 2,
            child: Text(
              widget.text,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    );
  }
}