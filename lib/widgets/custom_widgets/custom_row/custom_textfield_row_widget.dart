import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomTextFieldRowWidget extends StatefulWidget {
  final String labelText;
  final String name;
  final int maxLines;
  final String? initialValue;
  final bool isShort;
  final bool isImportant;
  final TextInputType? keyboardType;
  final String? hintText;
  final FormFieldValidator<String?>? validator;
  final ValueChanged<String?>? onChanged;
  final FormFieldSetter<String?>? onSaved;

  const CustomTextFieldRowWidget({
    super.key, 
    required this.labelText, 
    required this.name, 
    this.maxLines = 1, 
    this.isShort = false,
    this.isImportant = true,
    this.validator,
    this.onChanged, 
    this.onSaved,
    this.initialValue, 
    this.keyboardType,
    this.hintText,
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
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                TextSpan(
                  text: widget.isImportant ? " *" : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),
                ),
              ]
            )
          )
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: widget.isShort ? 2 : 4,
          child: CustomFormBuilderTextField(
            name: widget.name,
            maxLines: widget.maxLines,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
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