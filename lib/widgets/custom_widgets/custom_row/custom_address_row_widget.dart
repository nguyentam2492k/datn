import 'package:datn/model/address.dart';
import 'package:datn/model/district.dart';
import 'package:datn/model/province.dart';
import 'package:datn/model/ward.dart';
import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomAddressRowWidget extends StatefulWidget {

  final GlobalKey<FormBuilderState> formKey;
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
  final List<Province> provinces;

  const CustomAddressRowWidget({
    super.key, 
    required this.formKey,
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
    required this.provinces,
    });
  
  @override
  State<StatefulWidget> createState() {
    return CustomAddressRowWidgetState();
  }
}

class CustomAddressRowWidgetState extends State<CustomAddressRowWidget> {

  late GlobalKey<FormBuilderState> _formKey;

  late String provinceName;
  late String districtName;
  late String wardName;

  List<Province> provinces = [];
  List<District> districts = [];
  List<Ward> wards = [];

  ValueNotifier<Address> selectedAddressChanged = ValueNotifier(Address());

  BoxConstraints buttonConstraints = const BoxConstraints(maxWidth: 150, maxHeight: 45);
  TextStyle buttonTextStyle = const TextStyle(
    fontSize: 13,
    color: Colors.black
  );

  InputDecoration buttonDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    provinces = widget.provinces;
    _formKey = widget.formKey;
    provinceName = widget.provinceName;
    districtName = widget.districtName;
    wardName = widget.wardName;
  }

  @override
  Widget build(BuildContext context) {

    // print(widget.formKey!.currentState!.value);
    return ValueListenableBuilder(
      valueListenable: selectedAddressChanged,
      builder: (context, selectedAddress, child) {
        // print("${widget.provinces.length}--${districts.length}--${wards.length}");
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
            const SizedBox(width: 4,),
            Expanded(
              flex: 4,
              child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      constraints: buttonConstraints,
                      child: CustomFormBuilderDropdown(
                        name: provinceName,
                        initialValue: selectedAddress.province,
                        items: provinces
                          .map((province) => DropdownMenuItem(
                            value: province.name, 
                            child: Text(
                              province.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                          .toList(),
                        validator: widget.provinceValidator,
                        // onChanged: widget.provinceChanged,
                        onChanged: (value) {
                          var provinceIndex = provinces.indexWhere((element) => element.name == _formKey.currentState!.fields[provinceName]!.value);
                          if ((_formKey.currentState!.fields[provinceName]!.value != selectedAddress.province)) {
                            selectedAddressChanged.value = Address(
                              province: _formKey.currentState!.fields[provinceName]!.value,
                              district: null,
                              ward: null,
                            );
                            wards.clear();
                          }
                          debugPrint(selectedAddressChanged.value.toString());
                          districts = provinces[provinceIndex].districts!;
                        },
                        style: buttonTextStyle,
                        decoration: buttonDecoration("Tỉnh/Tp"),
                      ),
                    ),
                    Container(
                      constraints: buttonConstraints,
                      child: CustomFormBuilderDropdown(
                        name: districtName,
                        initialValue: selectedAddress.district,
                        items: districts
                          .map((district) => DropdownMenuItem(
                            value: district.name, 
                            child: Text(
                              district.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                          .toList(),
                        validator: widget.districtValidator,
                        // onChanged: widget.districtChanged,
                        onChanged: (value) {
                          var districtIndex = districts.indexWhere((element) => element.name == _formKey.currentState!.fields[districtName]!.value);
                          if ((_formKey.currentState!.fields[districtName]!.value != selectedAddress.district)) {
                            selectedAddressChanged.value = Address(
                              province: selectedAddress.province,
                              district: _formKey.currentState!.fields[districtName]!.value,
                              ward: null,
                            );
                          }
                          debugPrint(selectedAddressChanged.value.toString());
                          wards = districts[districtIndex].wards!;
                        },
                        style: buttonTextStyle,
                        decoration: buttonDecoration("Quận/Huyện")
                      ),
                    ),
                    Container(
                      constraints: buttonConstraints,
                      child: CustomFormBuilderDropdown(
                        name: wardName,
                        initialValue: selectedAddress.ward,
                        items: wards
                          .map((ward) => DropdownMenuItem(
                            value: ward.name, 
                            child: Text(
                              ward.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                          .toList(),
                        validator: widget.wardValidator,
                        // onChanged: widget.wardChanged,
                        onChanged: (value) {
                          selectedAddressChanged.value = Address(
                            province: selectedAddress.province,
                            district: selectedAddress.district,
                            ward: _formKey.currentState!.fields[wardName]!.value,
                          );
                          debugPrint(selectedAddressChanged.value.toString());
                        },
                        style: buttonTextStyle,
                        decoration: buttonDecoration("Xã/Phường")
                      ),
                    ),
                  ],
                ),
            )
          ],
        );
      },
    );
  }
}