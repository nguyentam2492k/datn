import 'dart:ui' as ui;

import 'package:datn/constants/my_icons.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/constants/constant_list.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/widgets/custom_widgets/bottom_sheet_with_list.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:datn/widgets/manage_request/request_information_dialog.dart';
import 'package:flutter/material.dart';

class ManageRequestScreen extends StatefulWidget {

  const ManageRequestScreen({
    super.key,
  });
  
  @override
  State<StatefulWidget> createState() {
    return ManageRequestScreenState();
  }
}

class ManageRequestScreenState extends State<ManageRequestScreen> {

  static const double loadingIndicatorSize = 20;
  static const double requestStatusBarHeight = 45;
  static const int maxLines = 4;

  late ValueNotifier<List<bool>> isExpanded = ValueNotifier([]);

  APIService apiService = APIService();
  ValueNotifier<List<Request>> listRequest = ValueNotifier([]);
  
  String? currentStatus = ConstantList.requestStatus[0];
  late int selectedStatusIndex;

  int currentPage = 1;
  int pageSize = 10;
  int totalRequests = 99;
  String? getDataErrorText;
  late String accessToken;
  late String userId;

  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  Future<void> loadRequest() async {
    print("LOAD");
    isLoading = true;

    if (currentPage == 1) {
      listRequest.value = [];
    }

    try {
      await apiService.getMyData(currentStatus, pageIndex: currentPage, pageSize: pageSize).then((value) {
        getDataErrorText = null;

        totalRequests = value.totalRequests;
        final list = value.listRequests;

        listRequest.value.addAll(value.listRequests);
        listRequest.value = List.from(listRequest.value);
        
        isExpanded.value.addAll(List.generate(list.length, (index) => false));
        isExpanded.value = List.from(isExpanded.value);
        if (listRequest.value.length < totalRequests) {
          currentPage += 1;
          isLoading = false;
        }
      });
    } catch (e) {
      getDataErrorText = e.toString();
      MyToast.showToast(
        isError: true,
        errorText: e.toString()
      );
    }
  }

  void _handleScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - loadingIndicatorSize && !isLoading && listRequest.value.length < totalRequests) {
      loadRequest();
    }
  }

  @override
  void initState() {
    super.initState();
    accessToken = globalLoginResponse!.accessToken!;
    userId = globalLoginResponse!.user?.id ?? "999999";
    selectedStatusIndex = 0;
    scrollController.addListener(() {
      _handleScroll();
    });
  }

  @override
  void dispose() {
    apiService.cancelTask();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: manageRequestScreenBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Xử lý yêu cầu"),
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.3,
        )
      ),
    );
  }

  Widget manageRequestScreenBody() {

    return Stack(
      children: [
        buildRequestListView(),
    
        Align(
          alignment: Alignment.topCenter,
          child: buildFilterChips(),
        ),
      ]
    );
  }

  Widget buildRequestListView() {
    currentPage = 1;
    // isLoading = false;

    return FutureBuilder(
      future: loadRequest(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          
          if (getDataErrorText != null) {
            return Center(
              child: Text(
                "LỖI: $getDataErrorText!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF7B7B7B),
                  fontSize: 12
                ),
              ),
            );
          }
          if (totalRequests == 0) {
            return const Center(
              child: Text(
                "Chưa có yêu cầu nào!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7B7B7B),
                  fontSize: 12
                ),
              ),
            );
          }

          return ValueListenableBuilder(
            valueListenable: listRequest,
            builder: (context, list, child) {
              print("BUILD - ${list.length}");

              return ListView.separated(
                controller: scrollController,
                itemCount: list.length + 1,
                padding: const EdgeInsets.fromLTRB(10, requestStatusBarHeight, 10, 15),
                separatorBuilder: (context, index) => const SizedBox(height: 10,),
                itemBuilder: (BuildContext context, int index) {
                  
                  if (index == list.length) {
                    return (listRequest.value.length < totalRequests)
                      ? const Center(
                        child: SizedBox(
                          height: loadingIndicatorSize,
                          width: loadingIndicatorSize,
                          child: CircularProgressIndicator(color: Color(0xFF1E3CFF), strokeWidth: 2.25,)
                        ),
                      )
                      : const Text(
                          "Đã tải toàn bộ yêu cầu!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10
                          ),
                        );
                  }
                  return listRequestItem(list, index, context);
                }
              );
            },
          );
        } else {
          return const Center(
            child: SizedBox(
              height: loadingIndicatorSize + 5,
              width: loadingIndicatorSize + 5,
              child: CircularProgressIndicator(color: Color(0xFF1E3CFF), strokeWidth: 2.75,)
            ),
          );
        }
      },
    );
  }

  Widget listRequestItem(List<Request> list, int index, BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 20, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1.5,
              offset: const Offset(0, 0.5),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row( 
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 7,
                decoration: BoxDecoration(
                  color: getColor(list[index].statusId ?? 99),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                ),
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: isExpanded,
                  builder: (BuildContext context, value, Widget? child) {
                    
                    var requestText = getRequestText(list[index].info!);
                    
                    return listRequestItemDetail(list, index, context, requestText, value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context, 
          builder: (context) => requestInforDialog(context, index, list[index]),
        );
      },
    );
  }

  Column listRequestItemDetail(List<Request> list, int index, BuildContext context, String requestText, List<bool> value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "#${list[index].id}",
              style: const TextStyle(
                color: Colors.grey
              )
            ),
            const SizedBox(width: 7,),
            Expanded(
              child: Text(
                list[index].requestType ?? "----",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                )
              )
            ),
            const SizedBox(width: 5,),
            buildAttachFileButton(list, index, context),
          ],
        ),
        const SizedBox(height: 5,),

        const Text(
          "Yêu cầu:",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        
        Text(
          requestText,
          overflow: TextOverflow.fade,
          maxLines: value[index] ? null : 4,
        ),
        const SizedBox(height: 1.5,),

        buidExpandedTextButton(requestText, index),
        const SizedBox(height: 5,),

        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    MyIcons.calendar,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 3,),
                  Flexible(
                    child: Text(
                      list[index].dateCreate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                ],
              )
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    MyIcons.money,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 3,),
                  Flexible(
                    child: Text(
                      list[index].fee ?? "----",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(width: 5,),
                ],
              )
            ),
          ],
        ),
      ],
    );
  }

  Visibility buildAttachFileButton(List<Request> list, int index, BuildContext context) {
    return Visibility(
      visible: list[index].file != null,
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const ui.Color.fromARGB(255, 252, 252, 252),
            border: Border.all(color: const Color(0xFF0E6FBE), width: 0.3),
            borderRadius: BorderRadius.circular(17)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                MyIcons.attachFile, 
                color: Color(0xFF0E6FBE), 
                size: 14,
              ),
              const SizedBox(width: 3,),
              Text(
                list[index].file != null ? list[index].file!.length.toString() : "0",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF0E6FBE)
                ),
              )
            ]
          ),
        ),
        onTap: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            builder: (context) {
              List<String> listFileUrl = list[index].file!.map((url) => url).toList();
              return BottomSheetWithList(
                title: "Tệp đính kèm",
                list: listFileUrl,
                isHaveCancelButton: false,
                isHaveLeftIcon: true,
                isHaveRightIcon: true,
                rightIcon: MyIcons.download,
                isListFile: true,
              );
            },
          );
        },
      ),
    );
  }

  Widget buidExpandedTextButton(String requestText, int index) {
    final span = TextSpan(text: requestText);
    final tp = TextPainter(
      text: span, 
      textDirection: ui.TextDirection.ltr
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - 75);
    List<ui.LineMetrics> lines = tp.computeLineMetrics();
    int numberOfLines = lines.length;

    return Visibility(
      visible: numberOfLines > 4,
      child: Center(
        child: SizedBox(
          width: 110,
          height: 18,
          child: FilledButton.icon(
            icon: Icon(
              isExpanded.value[index] ? MyIcons.arrowUp : MyIcons.arrowDown,
              size: 11,
              color: const Color(0xFF063A76),
            ),
            label: Text(
              isExpanded.value[index] ? "Thu gọn" : "Xem thêm",
              style: const TextStyle(
                fontSize: 9.5,
                color: ui.Color(0xFF063A76),
              ),
            ),
            style: FilledButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent
            ),
            onPressed: (){
              var list = isExpanded.value;
              list[index] = list[index] ? false : true;
              isExpanded.value = List.from(list);
            },
          ),
        ),
      ),
    );
  }

  Widget buildFilterChips() {
    return SizedBox(
      height: requestStatusBarHeight,
      child: ListView.separated(
        itemCount: ConstantList.requestStatus.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(width: 5,),
        itemBuilder: (context, index) {
          return ChoiceChip(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
            backgroundColor: Colors.white,
            elevation: 0,
            showCheckmark: false,
            side: const BorderSide(color: Colors.grey, width: 0.5),
            shape: const StadiumBorder(),
            label: Text(
              ConstantList.requestStatus[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: selectedStatusIndex == index ? Colors.white : Colors.black
              ),
            ),
            selected: selectedStatusIndex == index,
            selectedColor: Colors.blue,
            onSelected: (value) {
              if (index != selectedStatusIndex) {
                listRequest.value = [];
                currentPage = 1;
                isLoading = false;
                selectedStatusIndex = value ? index : selectedStatusIndex;
                currentStatus = ConstantList.requestStatus[index];
                setState(() {});
              }
            },
          );
        }, 
      ),
    );
  }

}