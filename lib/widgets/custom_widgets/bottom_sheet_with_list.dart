import 'package:flutter/material.dart';

class BottomSheetWithList extends StatefulWidget {
  final String? selectedItem;
  final List<String> list;

  const BottomSheetWithList({
    super.key, 
    this.selectedItem, 
    required this.list
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) => const Divider(),
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
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    selectedItemChanged = list[index];
                    Navigator.pop(context, selectedItemChanged);
                  },
                );
              },
            )
          ),
        ),
        Container(
          height: 60,
          margin: const EdgeInsets.all(10),
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
      ],
    );
  }
}