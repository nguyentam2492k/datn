import 'package:datn/model/district.dart';
import 'package:datn/model/province.dart';
import 'package:datn/model/ward.dart';
import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:flutter/material.dart';

class CustomAddressRowWidget extends StatefulWidget {

  final String labelText;
  final String provinceName;
  final String districtName;
  final String wardName;
  final FormFieldValidator<dynamic>? provinceValidator;
  final FormFieldValidator<dynamic>? districtValidator;
  final FormFieldValidator<dynamic>? wardValidator;
  final ValueChanged<dynamic>? provinceChanged;
  final ValueChanged<dynamic>? districtChanged;
  final ValueChanged<dynamic>? wardChanged;
  final String? initialProvinceValue;
  final String? initialDistrictValue;
  final String? initialWardValue;
  final String selectedProvince;
  final String selectedDistrict;
  final String selectedWard;
  final List<Province> provinces;
  final List<District> districts;
  final List<Ward> wards;

  const CustomAddressRowWidget({
    super.key, 
    required this.labelText, 
    required this.provinceName, 
    required this.districtName, 
    required this.wardName, 
    this.provinceValidator, 
    this.districtValidator, 
    this.wardValidator, 
    this.provinceChanged, 
    this.districtChanged, 
    this.wardChanged, 
    this.initialProvinceValue, 
    this.initialDistrictValue, 
    this.initialWardValue, 
    required this.selectedProvince, 
    required this.selectedDistrict, 
    required this.selectedWard, 
    required this.provinces, 
    required this.districts, 
    required this.wards,
  });
  
  @override
  State<StatefulWidget> createState() {
    return CustomAddressRowWidgetState();
  }
}

class CustomAddressRowWidgetState extends State<CustomAddressRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
          flex: 4,
          child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: CustomFormBuilderDropdown(
                    name: widget.provinceName,
                    initialValue: widget.selectedProvince,
                    items: widget.provinces
                      .map((province) => DropdownMenuItem(
                        value: province.id, 
                        child: Text(province.name!),
                      ))
                      .toList(),
                    validator: widget.provinceValidator,
                    onChanged: widget.provinceChanged,
                    decoration: const InputDecoration(
                      labelText: "Tỉnh/TP",
                      labelStyle: TextStyle(
                        fontSize: 13
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      
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
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: CustomFormBuilderDropdown(
                    name: widget.districtName,
                    initialValue: widget.selectedDistrict,
                    items: widget.districts
                      .map((district) => DropdownMenuItem(
                        value: district.id, 
                        child: Text(district.name!),
                      ))
                      .toList(),
                    validator: widget.districtValidator,
                    onChanged: widget.districtChanged,
                    decoration: const InputDecoration(
                      labelText: "Quận/Huyện",
                      labelStyle: TextStyle(
                        fontSize: 13
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      
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
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: CustomFormBuilderDropdown(
                    name: widget.wardName,
                    initialValue: widget.selectedWard,
                    items: widget.wards
                      .map((ward) => DropdownMenuItem(
                        value: ward.id, 
                        child: Text(ward.name!),
                      ))
                      .toList(),
                    validator: widget.wardValidator,
                    onChanged: widget.wardChanged,
                    decoration: const InputDecoration(
                      labelText: "Xã/Phường",
                      labelStyle: TextStyle(
                        fontSize: 13
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      
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
                  ),
                ),
              ],
            ),
        )
      ],
    );
  }
}