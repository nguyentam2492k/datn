import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderTextField extends StatefulWidget {
    final String name; 
    final int? maxLines;
    final FormFieldValidator<String?>? validator;
    final ValueChanged<String?>? onChanged;
    final String? initialValue;
    final bool enabled;
    final TextInputType? keyboardType;
    final TextStyle? style;
    final InputDecoration decoration;

  const CustomFormBuilderTextField({
    super.key, 
    required this.name, 
    this.maxLines = 1, 
    this.validator, 
    this.onChanged, 
    this.initialValue, 
    this.enabled = true, 
    this.keyboardType, 
    this.style = const TextStyle(fontSize: 14), 
    this.decoration = const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      filled: true,
      fillColor: Colors.white,
      errorStyle: TextStyle(
        fontSize: 10,
        height: 0.3
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Color(0xFFD6D6D6),
          width: 0.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  });

  @override
  State<StatefulWidget> createState() {
    return CustomFormBuilderTextFieldState();
  }
  
}

class CustomFormBuilderTextFieldState extends State<CustomFormBuilderTextField> {

  BoxConstraints constraints = const BoxConstraints(maxHeight: 45);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.maxLines == 1 ? constraints : null,
      child: FormBuilderTextField(
        name: widget.name,
        maxLines: widget.maxLines,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        style: widget.style,
        decoration: widget.decoration,
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
  
}