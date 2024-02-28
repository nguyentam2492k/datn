import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CustomFormBuilderDateTimePicker extends StatefulWidget {
  final String name; 
  final FormFieldValidator<DateTime?>? validator;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? initialValue;
  final InputType inputType;
  final Locale? locale;
  final TextStyle? style;
  final InputDecoration decoration;

  const CustomFormBuilderDateTimePicker({
    super.key, 
    required this.name, 
    this.validator, 
    this.onChanged, 
    this.initialValue, 

    this.inputType = InputType.date, 
    this.locale = const Locale('vi', 'VI'), 
    this.style = const TextStyle(
      fontSize: 14,
      color: Colors.black
    ),
    this.decoration = const InputDecoration(
      contentPadding: EdgeInsets.all(10),
      hintText: "Chọn ngày",
      hintStyle: TextStyle(
        fontSize: 13,
        color: Colors.grey,
        fontWeight: FontWeight.normal
      ),
      suffixIcon: Icon(Icons.calendar_month_outlined, size: 20,),
      suffixIconColor: Colors.grey,
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
    return CustomFormBuilderDateTimePickerState();
  }
  
}

class CustomFormBuilderDateTimePickerState extends State<CustomFormBuilderDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 45),
      child: FormBuilderDateTimePicker(
        name: widget.name,
        initialDate: widget.initialValue,
        inputType: widget.inputType,
        locale: widget.locale,
        format: DateFormat('dd/MM/yyyy'),
        style: widget.style,
        decoration: widget.decoration,
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
  
}