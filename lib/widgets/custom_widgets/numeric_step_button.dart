import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final double numberSize;
  final double iconSize;
  final double numberWidth;
  final double stepButtonWidth;
  final Color stepButtonBackgroundColor;
  final Color stepButtonColor;
  final MainAxisAlignment alignment;

  final ValueChanged<int?> onChanged;

  const NumericStepButton({
    Key? key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.numberSize = 15,
    this.iconSize = 25,
    this.numberWidth = 45,
    this.stepButtonWidth = 25,
    this.stepButtonBackgroundColor = Colors.blue,
    this.stepButtonColor = Colors.white,
    this.alignment = MainAxisAlignment.start, 
    required this.onChanged, 
  }) : super(key: key);


  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {

  late int counter;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    counter = widget.initialValue;   
    _controller = TextEditingController(text: counter.toString());
    
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: widget.alignment,
      children: [
        Container(
          width: widget.stepButtonWidth,
          height: widget.stepButtonWidth,
          decoration: BoxDecoration(
            color: (counter > widget.minValue) ? widget.stepButtonBackgroundColor : Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(widget.stepButtonWidth/2)),
          ),
          child: FittedBox(
            fit: BoxFit.fill,
            child: IconButton(
              icon: Icon(
                Icons.remove,
                color: widget.stepButtonColor,
              ),
              iconSize: widget.iconSize,
              onPressed: () {
                setState(() {
                  if (counter > widget.minValue) {
                    counter--;
                    _controller = TextEditingController(text: counter.toString());
                  } else {
                    return null;
                  }
                  widget.onChanged(counter);
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Container(
          width: widget.numberWidth,
          color: Colors.white,
          child: TextFormField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: widget.numberSize,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) {
                final intValue = int.tryParse(value);
                if (intValue is int) {
                  counter = intValue;
                } else {
                  counter = widget.initialValue;
                }
                setState(() {
                  widget.onChanged(counter);
                });
            },
            onSaved: (newValue) {
              
            },
          ),
        ),
        const SizedBox(width: 4,),
        Container(
          width: widget.stepButtonWidth,
          height: widget.stepButtonWidth,
          decoration: BoxDecoration(
            color: (counter < widget.maxValue) ? widget.stepButtonBackgroundColor : Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(widget.stepButtonWidth/2)),
          ),
          child: FittedBox(
            fit: BoxFit.fill,
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: widget.stepButtonColor,
              ),
              iconSize: widget.iconSize,
              onPressed: () {
                setState(() {
                  if (counter < widget.maxValue) {
                    counter++;
                    _controller = TextEditingController(text: counter.toString());
                  } else { }
                  widget.onChanged(counter);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}