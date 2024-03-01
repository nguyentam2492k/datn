import 'package:datn/function/function.dart';
import 'package:datn/model/request/file_data_model.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BottomSheetWithList extends StatefulWidget {
  final String? selectedItem;
  final List<String> list;
  final String? title;
  final bool isHaveLeftIcon;
  final bool isHaveRightIcon;
  final bool isHaveCancelButton;
  final IconData rightIcon;
  final bool isListFile;
  final List<FileData>? listFile;

  const BottomSheetWithList({
    super.key, 
    this.selectedItem, 
    required this.list,
    this.title,
    this.isHaveRightIcon = true,
    this.isHaveLeftIcon = false,
    this.isHaveCancelButton = true,
    this.rightIcon = Icons.keyboard_arrow_right,
    this.isListFile = false,
    this.listFile
  });

  @override
  State<StatefulWidget> createState() {
    return BottomSheetWithListState();
  }  
}

class BottomSheetWithListState extends State<BottomSheetWithList> {
  // String? selectedItemChanged = widget.selectedItem;

  @override
  Widget build(BuildContext context) {
    String? selectedItemChanged = widget.selectedItem;
    List<String> list = widget.list;
    String? title = widget.title;
    bool isHaveRightIcon = widget.isHaveRightIcon;
    bool isHaveLeftIcon = widget.isHaveLeftIcon;
    bool isHaveCancelButton = widget.isHaveCancelButton;
    IconData rightIcon = widget.rightIcon;
    bool isListFile = widget.isListFile;
    List<FileData>? listFile = widget.listFile;

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return const LoadingHud(text: "Đang mở...",);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC1C1C1),
                      borderRadius: BorderRadius.circular(2)
                    ),
                  ),
                  Visibility(
                    visible: title != null,
                    child: Text(
                      title ?? "",
                      maxLines: 1,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const Divider(thickness: 0.4,),
                      itemBuilder: (context, index) {
                        return ListTile(
                          textColor: selectedItemChanged == list[index] ? Colors.blue : Colors.black,
                          iconColor: selectedItemChanged == list[index] ? Colors.blue : Colors.black,
                          title: Text(
                            list[index],
                            textScaler: selectedItemChanged == list[index] ? const TextScaler.linear(1.1) : const TextScaler.linear(1),
                            style: TextStyle(
                              fontWeight: selectedItemChanged == list[index] ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isHaveRightIcon ? Icon(rightIcon) : null,
                          leading: isHaveLeftIcon ? Icon(getIcon(list[index])) : null,
                          onTap: () async {
                            if (isListFile && listFile != null) {
                              context.loaderOverlay.show();
                              await openFileFromUrl(listFile[index].url, listFile[index].filename)
                                .then((value) {
                                  context.loaderOverlay.hide();
                                });
                            } else {
                              selectedItemChanged = list[index];
                              Navigator.pop(context, selectedItemChanged);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            ),
          ),
          Visibility(
            visible: isHaveCancelButton,
            child: Container(
              height: 60,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: (){
                  Navigator.pop(context, selectedItemChanged);
                },
                child: const Text("Cancel"),
              )
            ),
          ),
        ],
      ),
    );
  }
}