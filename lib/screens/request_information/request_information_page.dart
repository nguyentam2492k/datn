import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RequestInformationPage extends StatefulWidget {

  final Request requestInfo;

  const RequestInformationPage({
    super.key, 
    required this.requestInfo
  });

  @override
  State<StatefulWidget> createState() {
    return RequestInformationPageState();
  }
}

class RequestInformationPageState extends State<RequestInformationPage> {
  late Request requestInfo;
  late int index;

  @override
  void initState() {
    super.initState();
    requestInfo = widget.requestInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Thông tin"),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 1.5,
                      offset: const Offset(0, 0.35),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getStatusIcon(statusId: requestInfo.statusId),
                          const SizedBox(width: 8,),
                          Text(requestInfo.status, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: getColor(requestInfo.statusId)),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Loại yêu cầu",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.requestType ?? "----", style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Yêu cầu",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          flex: 3,
                          child: Text(
                              getRequestText(requestInfo.info!,),
                              style: const TextStyle(fontSize: 15),
                            ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 1.5,
                      offset: const Offset(0, 0.35),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Mã",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.id.toString(), style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Sinh viên",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(
                              requestInfo.user?.name ?? "----",
                              style: const TextStyle(fontSize: 15),
                            )
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Tệp đính kèm",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: requestInfo.file != null ? buildListFileWidget(context, requestInfo.file!) : const Text("----", style: TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Giấy tờ cần nộp",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.documentNeed ?? "----", style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Lệ phí",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),  
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.fee ?? "----", style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Nơi xử lý",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.processingPlace ?? "----", style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Hạn hoàn thành",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.expireIn != null ? requestInfo.expireIn! : "----", style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Ngày tạo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.dateCreate, style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.3,),
                    Container(
                      constraints: const BoxConstraints(minHeight: 32),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Ngày nhận",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 3,
                            child: Text(requestInfo.dateReceive ?? "----", style: const TextStyle(fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildListFileWidget(BuildContext context, List<String> listFileUrl) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: listFileUrl.map((fileUrl) {
        return Container(
          height: 28,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: const Color(0xFF0037FF), width: 0.4),
          ),
          child: FilledButton.icon(
            icon: Icon(getIcon(getFileNameFromUrl(fileUrl)), size: 13, color: const Color(0xFF0037FF),), 
            label: Text(
              getFileNameFromUrl(fileUrl),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF0037FF),
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            ),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              elevation: 0,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            onPressed: () async {
              await EasyLoading.show(status: "Đang mở");

              try {
                await FileServices().openFileFromUrl(
                url: fileUrl, 
                filename: getFileNameFromUrl(fileUrl)
              )
                .then((value) async {
                  await EasyLoading.dismiss();
                });
              } catch (e) {
                MyToast.showToast(
                  isError: true,
                  errorText: "LỖI: ${e.toString()}"
                );
              }
            }, 
          ),
        );
      }).toList()
    );
  }