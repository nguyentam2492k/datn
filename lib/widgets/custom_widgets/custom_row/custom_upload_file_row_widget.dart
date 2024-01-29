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
    required this.onChanged, 
    required this.isFileAdded, 
  });

  @override
  State<StatefulWidget> createState() {
    return CustomUploadFileRowWidgetState();
  }
  
}

class CustomUploadFileRowWidgetState extends State<CustomUploadFileRowWidget> {
  
  List<PlatformFile> files = [];

  late bool isFileAdded = true;

  @override
  void didUpdateWidget(covariant CustomUploadFileRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    files = widget.files;
    isFileAdded = widget.isFileAdded;
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
            child: Text(
              widget.labelText,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
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
                                debugPrint("${file.name}\n${file.size}");
                              }
                              debugPrint('Add completed');
                            } else {
                              debugPrint("Nothing added");
                            }
                          } catch (error) {
                            debugPrint(error.toString());
                          }
                        },
                      ),
                      Visibility(
                        visible: !isFileAdded,
                        child: Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            "Thêm tệp đính kèm",
                            style: TextStyle(
                              color: Color(0xFFCF0202),
                              fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: files.map((file) {
                        return Container(
                          constraints: const BoxConstraints(maxHeight: 30, maxWidth: 135),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 2,),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.attach_file, size: 14,), 
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
                                      OpenResult result;
                                      try {
                                        result = await OpenFile.open(
                                          file.path,
                                        );
                                        setState(() {
                                          debugPrint("type=${result.type}  message=${result.message}");
                                        });
                                      } catch (error) {
                                        debugPrint(error.toString());
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
                    ),
                  )
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
  
}