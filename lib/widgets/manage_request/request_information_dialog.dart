import 'package:datn/function/function.dart';
import 'package:datn/model/request/file_data_model.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

Widget requestInforDialog(BuildContext context, int index, Request requestInfo) {

  return Scaffold(
    backgroundColor: Colors.transparent,
    body: LoaderOverlay(
      useDefaultLoading: false,
        overlayColor: Colors.transparent,
        overlayWidgetBuilder: (progress) {
          return const LoadingHud(text: "Đang mở...",);
        },
      child: AlertDialog(
          elevation: 0,
          titlePadding: const EdgeInsets.symmetric(),
          insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  height: 16,
                  decoration: BoxDecoration(
                    color: getColor(requestInfo.status),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                  ),
                ),
                const SizedBox(height: 18,),
                const Text(
                  "Chi tiết yêu cầu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
      
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Mã",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(requestInfo.id.toString()),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Sinh viên",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        requestInfo.student ?? "----",
                      )
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Loại yêu cầu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(requestInfo.requestType ?? "----"),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Yêu cầu",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(
                          getRequestText(requestInfo.info!),
                        ),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
      
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Tệp đính kèm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: requestInfo.file != null ? buildListFileWidget(context, requestInfo.file!) : const Text("----"),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Giấy tờ cần nộp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(requestInfo.documentNeed ?? "----"),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Tình trạng",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),  
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(getStatus(requestInfo.status)),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Lệ phí",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),  
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(requestInfo.fee ?? "----"),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Nơi xử lý",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(requestInfo.processingPlace ?? "----"),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Ngày tạo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(formatDateWithTime(requestInfo.dateCreate)),
                    )
                  ],
                ),
                const Divider(thickness: 0.4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Ngày nhận",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(requestInfo.dateReceive ?? "----"),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
    ),
  );
    
}

Widget buildListFileWidget(BuildContext context, List<FileData> listFile) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: listFile.map((file) {
        return Container(
          height: 25,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: const Color(0xFF0037FF), width: 0.5),
          ),
          child: FilledButton.icon(
            icon: Icon(getIcon(file.filename), size: 12, color: const Color(0xFF0037FF),), 
            label: Text(
              file.filename,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF0037FF),
                fontSize: 11,
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
              context.loaderOverlay.show();
              await openFileFromUrl(
                context: context,
                url: file.url, 
                filename: file.filename
              )
                .then((value) {
                  context.loaderOverlay.hide();
                });
            }, 
          ),
        );
      }).toList()
    );
  }