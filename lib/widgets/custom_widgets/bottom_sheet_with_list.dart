import 'package:datn/constants/my_icons.dart';
import 'package:datn/function/function.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:flutter/material.dart';

class BottomSheetWithList extends StatefulWidget {
  final String? selectedItem;
  final List<String> list;
  final String? title;
  final bool isHaveLeftIcon;
  final bool isHaveRightIcon;
  final bool isHaveCancelButton;
  final IconData rightIcon;
  final bool isListFile;

  const BottomSheetWithList({
    super.key, 
    this.selectedItem, 
    required this.list,
    this.title,
    this.isHaveRightIcon = true,
    this.isHaveLeftIcon = false,
    this.isHaveCancelButton = true,
    this.rightIcon = MyIcons.arrowRight,
    this.isListFile = false,
  });

  @override
  State<StatefulWidget> createState() {
    return BottomSheetWithListState();
  }  
}

class BottomSheetWithListState extends State<BottomSheetWithList> {

  @override
  Widget build(BuildContext context) {
    String? selectedItemChanged = widget.selectedItem;
    List<String> list =  widget.list;
    String? title = widget.title;
    bool isHaveRightIcon = widget.isHaveRightIcon;
    bool isHaveLeftIcon = widget.isHaveLeftIcon;
    bool isHaveCancelButton = widget.isHaveCancelButton;
    IconData rightIcon = widget.rightIcon;
    bool isListFile = widget.isListFile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
                            !isListFile ? list[index] : getFileNameFromUrl(list[index]),
                            textScaler: selectedItemChanged == list[index] ? const TextScaler.linear(1.1) : const TextScaler.linear(1),
                            style: TextStyle(
                              fontWeight: selectedItemChanged == list[index] ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isHaveRightIcon ? Icon(rightIcon) : null,
                          leading: isHaveLeftIcon ? Icon(getIcon(getFileNameFromUrl(list[index]))) : null,
                          onTap: () async {
                            if (isListFile) {
                              await FileServices().actionDownloadFileWithUrl(
                                context, 
                                url: list[index]
                              );
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