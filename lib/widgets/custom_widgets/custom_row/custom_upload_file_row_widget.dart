import 'package:datn/function/function.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class CustomUploadFileRowWidget extends StatefulWidget {

  final List<PlatformFile> files;
  final ValueChanged<List<PlatformFile>> onChanged;
  final bool isFileAdded;
  final String labelText;

  const CustomUploadFileRowWidget({
    super.key, 
    this.labelText = "Tệp đính kèm:",
    required this.files,
    required this.isFileAdded, 
    required this.onChanged, 
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
                    const TextSpan(
                      text: " *",
                      style: TextStyle(
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
                  height: 45,
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.file_upload_outlined),
                        label: const Text('Thêm tệp'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        onPressed: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                            
                            if (result != null) {
                              Set<PlatformFile> fileSet = Set.from(files);
                              fileSet.addAll(result.files);
                              files = fileSet.toList();
                              widget.onChanged(files);
                              for (var file in files) {
                                print("${file.name}-${file.size}");
                              }
                              print('Add completed');
                            } else {
                              print("Nothing added");
                            }
                          } catch (error) {
                            print(error.toString());
                          }
                        },
                      ),
                      Visibility(
                        visible: !widget.isFileAdded,
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
                      print(file.path);
                      OpenResult result;
                      try {
                        result = await OpenFile.open(
                          file.path,
                        );

                        switch (result.type) {
                          case ResultType.fileNotFound:
                            throw "File not found!";
                          case ResultType.noAppToOpen:
                            throw "No app to open!";
                          case ResultType.permissionDenied:
                            throw "Permission denied!";
                          case ResultType.error:
                            throw ResultType.error.name;
                          case ResultType.done:
                            break;
                        }
                      } catch (error) {
                        if (context.mounted) {
                          CustomSnackBar().showSnackBar(
                            context,
                            isError: true,
                            // text: "Gửi thành công",
                            errorText: "LỖI: ${error.toString()}"
                          );
                        }
                      }
                    }, 
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: IconButton(
                    icon: const Icon(Icons.close),
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