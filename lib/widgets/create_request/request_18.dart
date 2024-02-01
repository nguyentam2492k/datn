import 'dart:convert';
import 'package:datn/model/district.dart';
import 'package:datn/model/province.dart';
import 'package:datn/model/ward.dart';
import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_address_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request18 extends StatefulWidget {
  const Request18({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request18State();
  }
}

class Request18State extends State<Request18> {

  final GlobalKey<FormBuilderState> _request18FormKey = GlobalKey<FormBuilderState>();

  List<Province> provinces = [];
  List<District> districts = [];
  List<Ward> wards = [];

  String selectedProvince = '';
  String selectedDistrict = '';
  String selectedWard = '';

  Future getAddressData() async {
    var response = await rootBundle.loadString('assets/data/dvhcvn.json');
    var jsonData = jsonDecode(response)['data'] as List;
    provinces = jsonData.map((provinceJson) => Province.fromJson(provinceJson)).toList();
    return;
  }

  @override
  void initState() {
    super.initState();
    getAddressData();
    selectedProvince = '';
    selectedDistrict = '';
    selectedWard = '';
  }

  @override
  Widget build(BuildContext context) {
    return 
    FutureBuilder(
      future: getAddressData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return 
          FormBuilder(
            key: _request18FormKey,
            child: CustomAddressRowWidget(
              labelText: "Dia chi",
              provinceName: 'province', 
              districtName: 'district', 
              wardName: 'ward', 
              selectedProvince: selectedProvince, 
              selectedDistrict: selectedDistrict, 
              selectedWard: selectedWard, 
              provinces: provinces, 
              districts: districts, 
              wards: wards,
              provinceChanged: (value) {
                var provinceIndex = provinces.indexWhere((element) => element.id == _request18FormKey.currentState!.fields['province']!.value);
                selectedProvince = _request18FormKey.currentState!.fields['province']!.value;
                selectedDistrict = '';
                selectedWard = '';
                districts = provinces[provinceIndex].districts!;
                debugPrint(districts.length.toString());
                // didUpdateWidget(widget);
                // _request18FormKey.currentState!.fields['district']!.didChange("a");
                setState(() {
                });
              },
              districtChanged: (value) {
                var districtIndex = districts.indexWhere((element) => element.id == _request18FormKey.currentState!.fields['district']!.value);
                selectedDistrict = _request18FormKey.currentState!.fields['district']!.value;
                selectedWard = '';
                wards = districts[districtIndex].wards!;
                debugPrint(wards.length.toString());
                setState(() {
                });
              },
              wardChanged: (value) {
                selectedWard = _request18FormKey.currentState!.fields['ward']!.value;
                debugPrint(value);
                // setState(() {
                // });
              },
              ),
            // child: Wrap(
            //   spacing: 4,
            //   runSpacing: 4,
            //   children: [
            //     Container(
            //       constraints: BoxConstraints(maxWidth: 200),
            //       child: CustomFormBuilderDropdown(
            //         name: 'province',
            //         initialValue: selectedProvince,
            //         items: provinces
            //           .map((province) => DropdownMenuItem(
            //             value: province.id, 
            //             child: Text(province.name!),
            //           ))
            //           .toList(),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return "Chọn Tỉnh/Thành phố";
            //           }
            //           return null;
            //         },
            //         onChanged: (value) {
            //           var provinceIndex = provinces.indexWhere((element) => element.id == _request18FormKey.currentState!.fields['province']!.value);
            //           selectedProvince = _request18FormKey.currentState!.fields['province']!.value;
            //           selectedDistrict = '';
            //           selectedWard = '';
            //           districts = provinces[provinceIndex].districts!;
            //           debugPrint(districts.length.toString());
            //           // didUpdateWidget(widget);
            //           // _request18FormKey.currentState!.fields['district']!.didChange("a");
            //           setState(() {
            //           });
            //         },
            //         decoration: InputDecoration(
            //           // prefixIcon:Padding(
            //           //   padding: const EdgeInsets.all(8.0),
            //           //   child: Text("Tỉnh/TP: "),
            //           // ),
            //           labelText: "Tỉnh/TP",
            //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             borderSide: BorderSide(
            //               width: 0.5,
            //               color: Colors.grey,
            //             ),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             borderSide: BorderSide(
            //               color: Colors.grey,
            //               width: 0.5,
            //             ),
            //           ),
            //           errorBorder: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.red),
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //           ),
            //           focusedErrorBorder: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.red),
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       constraints: BoxConstraints(maxWidth: 200),
            //       child: CustomFormBuilderDropdown(
            //         name: 'district',
            //         initialValue: selectedDistrict,
            //         items: districts
            //           .map((district) => DropdownMenuItem(
            //             value: district.id, 
            //             child: Text(district.name!),
            //           ))
            //           .toList(),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return "Chọn Quận/Huyện/Thị xã";
            //           }
            //           return null;
            //         },
            //         onChanged: (value) {
            //           var districtIndex = districts.indexWhere((element) => element.id == _request18FormKey.currentState!.fields['district']!.value);
            //           selectedDistrict = _request18FormKey.currentState!.fields['district']!.value;
            //           selectedWard = '';
            //           wards = districts[districtIndex].wards!;
            //           debugPrint(wards.length.toString());
            //           setState(() {
            //           });
            //         },
            //       ),
            //     ),
            //     Container(
            //       constraints: BoxConstraints(maxWidth: 200),
            //       child: CustomFormBuilderDropdown(
            //         name: 'ward',
            //         initialValue: selectedWard,
            //         items: wards
            //           .map((ward) => DropdownMenuItem(
            //             value: ward.id, 
            //             child: Text(ward.name!),
            //           ))
            //           .toList(),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return "Chọn Xã/Phường";
            //           }
            //           return null;
            //         },
            //         onChanged: (value) {
            //           selectedWard = _request18FormKey.currentState!.fields['ward']!.value;
            //           debugPrint(value);
            //           // setState(() {
            //           // });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}