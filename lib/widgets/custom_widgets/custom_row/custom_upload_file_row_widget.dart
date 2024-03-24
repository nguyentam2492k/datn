import 'package:datn/constants/my_icons.dart';
import 'package:datn/function/function.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomUploadFileRowWidget extends StatefulWidget {

  final List<PlatformFile> files;
  final ValueChanged<List<PlatformFile>> onChanged;
  final bool isFileAdded;
  final String labelText;
  final bool isImportant;
  final bool allowMultiple;
  final bool isPickImage;

  const CustomUploadFileRowWidget({
    super.key, 
    this.labelText = "Tệp đính kèm:",
    required this.files,
    required this.isFileAdded, 
    required this.onChanged,
    this.isImportant = true,
    this.allowMultiple = true,
    this.isPickImage = false
  });

  @override
  State<StatefulWidget> createState() {
    return CustomUploadFileRowWidgetState();
  }
  
}

class CustomUploadFileRowWidgetState extends State<CustomUploadFileRowWidget> {
  
  List<PlatformFile> files = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    files = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.labelText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                    TextSpan(
                      text: widget.isImportant ? " *" : '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      ),
                    ),
                    
                  ]
                )
              )
            ),
          ),
          const SizedBox(width: 4,),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(
                          MyIcons.upload, 
                          size: 19,
                        ),
                        label: const Text(
                          'Thêm tệp (< 5MB)',
                          style: TextStyle(
                            fontSize: 12.5
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        onPressed: () async {
                          try {
                            await FileServices().pickFile(
                              listFiles: files, 
                              allowMultiple: widget.allowMultiple,
                              isPickImage: widget.isPickImage
                            )
                              .then((value) {
                                if (value != null) {
                                  files = value.toList();
                                  widget.onChanged(files);
                                }
                              });
                          } catch (error) {
                            MyToast.showToast(
                              isError: true,
                              errorText: "LỖI: ${error.toString()}"
                            );
                          }
                        },
                      ),
                      Visibility(
                        visible: widget.isImportant && !widget.isFileAdded,
                        child: Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            "Thêm tệp đính kèm",
                            style: TextStyle(
                              color: Color.fromARGB(222, 207, 2, 2),
                              fontSize: 10,
                              height: 0.3
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: listFileWidget(),
                  )
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget listFileWidget() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: files.map((file) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 30, maxWidth: 135),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 2,),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: Icon(getIcon(file.name), size: 14,), 
                    label: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 3),
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    onPressed: () async {
                      FileServices().openFileFromPath(context: context, path: null);
                    }, 
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: IconButton(
                    icon: const Icon(MyIcons.close),
                    onPressed: (){
                      files.removeAt(files.indexOf(file));
                      widget.onChanged(files);
                    }, 
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList()
    );
  }
  
}