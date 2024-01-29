import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomTextFieldRowWidget extends StatefulWidget {
  final String labelText;
  final String name;
  final int maxLines;
  final String? initialValue;
  final bool isShort;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;

  const CustomTextFieldRowWidget({
    super.key, 
    required this.labelText, 
    required this.name, 
    this.maxLines = 1, 
    this.isShort = false,
    this.validator,
    this.onChanged, 
    this.initialValue,
  });

  @override
  State<StatefulWidget> createState() {
    return CustomTextFieldRowWidgetState();
  }
  
}

class CustomTextFieldRowWidgetState extends State<CustomTextFieldRowWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            widget.labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          flex: widget.isShort ? 2 : 4,
          child: CustomFormBuilderTextField(
            name: widget.name,
            maxLines: widget.maxLines,
            initialValue: widget.initialValue,
            validator: widget.validator,
            onChanged: widget.onChanged,
          ),
        ),
        Visibility(
          visible: widget.isShort,
          child: const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        )
      ],
    );
  }

}