import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderDropdown extends FormBuilderDropdown {
  CustomFormBuilderDropdown({
    super.key, 
    required super.name, 
    required super.items,
    super.validator,
    super.onChanged,
    super.initialValue,
    
    super.style = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    super.icon = const Icon(Icons.keyboard_arrow_down),
    super.decoration = const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
}