import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangeFilenameAlertDialog extends StatelessWidget {
  final String filename;
  const ChangeFilenameAlertDialog({
    super.key,
    required this.filename
  });

  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormBuilderState> changeFilenameFormKey = GlobalKey<FormBuilderState>();

    var acceptButton = TextButton(
      onPressed: () async {
        if (changeFilenameFormKey.currentState!.saveAndValidate()) {
          Navigator.of(context).pop(changeFilenameFormKey.currentState!.fields["new_name"]!.value);
        }
      }, 
      child: const Text("Lưu")
    );

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
      titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      actionsPadding: const EdgeInsets.all(5),
      title: const Text("Tên tệp đã tồn tại", style: TextStyle(fontWeight: FontWeight.bold),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Vui lòng nhập tên mới, nếu tên KHÔNG thay đổi hoặc ĐÓNG cửa sổ thì sẽ tự động lưu ĐÈ lên tệp cũ",
            style: TextStyle(
              color: Color(0xFF464646)
            ),
          ),
          const SizedBox(height: 10,),
          FormBuilder(
            key: changeFilenameFormKey,
            child: CustomTextFieldRowWidget(
              labelText: "Tên mới", 
              name: "new_name",
              isImportant: false,
              initialValue: filename,
              crossAxisAlignment: CrossAxisAlignment.center,
              autoFocus: true,
              validator: (value) {
                if (value == null || value.isEmpty ) {
                  return "Điền tên mới!";
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        acceptButton
      ],
    );
  }
  
}