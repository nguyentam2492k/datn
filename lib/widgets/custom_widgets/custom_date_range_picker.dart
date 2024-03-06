
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CustomFormBuilderDateRangePicker extends StatefulWidget {
  final String name; 
  final FormFieldValidator<DateTimeRange?>? validator;
  final ValueChanged<DateTimeRange?>? onChanged;
  final DateTimeRange? initialValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final Locale? locale;
  final TextStyle? style;
  final InputDecoration decoration;

  const CustomFormBuilderDateRangePicker({
    super.key, 
    required this.name, 
    this.validator, 
    this.onChanged, 
    this.initialValue, 
    required this.firstDate, 
    required this.lastDate, 
    this.locale, 
    this.style = const TextStyle(
      fontSize: 14,
      color: Colors.black
    ),
    this.decoration = const InputDecoration(
      contentPadding: EdgeInsets.all(10),
      hintText: "Chọn thời gian",
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
    return CustomFormBuilderDateRangePickerState();
  }
  
}

class CustomFormBuilderDateRangePickerState extends State<CustomFormBuilderDateRangePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 45),
      child: FormBuilderDateRangePicker(
        name: widget.name, 
        firstDate: widget.firstDate, 
        lastDate: widget.lastDate,
        initialValue: widget.initialValue,
        locale: widget.locale ?? const Locale("vi","VI"),
        format: DateFormat('dd/MM/yyyy'),
        style: widget.style,
        decoration: widget.decoration,
        validator: widget.validator,
        onChanged: widget.onChanged,
        valueTransformer: (value) => value.toString(),
      ),
    );
  }
  
}
