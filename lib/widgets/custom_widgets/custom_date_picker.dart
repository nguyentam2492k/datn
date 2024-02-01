import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderDateTimePicker extends FormBuilderDateTimePicker {

  CustomFormBuilderDateTimePicker({
    super.key, 
    required super.name,
    super.validator,
    super.onChanged,
    super.inputType = InputType.date,

    super.locale = const Locale('vi', 'VI'),
    super.style = const TextStyle(
      fontSize: 14,
    ),
    super.decoration = const InputDecoration(
      contentPadding: EdgeInsets.all(10),
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

class CustomFormBuilderDateRangePicker extends FormBuilderDateRangePicker {
  CustomFormBuilderDateRangePicker({
    super.key, 
    required super.name, 
    required super.firstDate,
    required super.lastDate,
    required super.validator,
    super.initialValue,

    super.locale = const Locale('vi', 'VI'),
    super.style = const TextStyle(
      fontSize: 14,
    ),
    super.decoration = const InputDecoration(
      contentPadding: EdgeInsets.all(10),
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