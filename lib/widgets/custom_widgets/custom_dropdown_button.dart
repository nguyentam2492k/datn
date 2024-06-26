import 'package:datn/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderDropdown extends StatefulWidget {
  final String name;
  final dynamic initialValue;
  final FormFieldValidator<dynamic>? validator;
  final TextStyle? style;
  final Widget? icon;
  final InputDecoration decoration;
  final List<DropdownMenuItem<dynamic>> items;
  final ValueChanged<dynamic>? onChanged;
  final ValueTransformer<dynamic>? valueTransformer;
  
  const CustomFormBuilderDropdown({
    super.key, 
    required this.name,
    required this.items, 
    this.validator,
    this.initialValue, 
    this.onChanged,
    this.valueTransformer,

    this.style = const TextStyle(
      fontSize: 14,
      color: Colors.black,  
    ),
    this.icon = const Icon(MyIcons.arrowDown), 
    this.decoration = const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
    return CustomFormBuilderDropdownState();
  }
  
}

class CustomFormBuilderDropdownState extends State<CustomFormBuilderDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 45),
      child: FormBuilderDropdown(
        name: widget.name, 
        initialValue: widget.initialValue,
        style: widget.style,
        icon: widget.icon,
        decoration: widget.decoration,
        items: widget.items,
        validator: widget.validator,
        onChanged: widget.onChanged,
        valueTransformer: widget.valueTransformer,
      ),
    );
  }
  
}
