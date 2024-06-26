import 'package:datn/constants/my_icons.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/notification_data/notification_data.dart';
import 'package:datn/screens/request_information/request_information_page.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NotificationPage extends StatefulWidget {
  
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotificationPageState();
  }
  
}

class NotificationPageState extends State<NotificationPage> {

  static const double loadingIndicatorSize = 25;
  static const double requestStatusBarHeight = 45;
  static const int maxLines = 4;

  APIService apiService = APIService();
  ValueNotifier<List<NotificationData>> listNotification = ValueNotifier([]);

  int currentOffset = 1;
  int pageSize = 10;
  int totalNotification = 99;
  String? getErrorText;

  bool isLoading = false;

  ValueNotifier<bool> isLoadMore = ValueNotifier(false);

  final ScrollController _scrollController = ScrollController();

  Future<void> loadListNotification() async {
    isLoading = true;
    isLoadMore.value = true;

    if (currentOffset == 1) {
      listNotification.value.clear();
      listNotification.value = List.from(listNotification.value);
    }

    try {
      await apiService.getListNotification(offset: currentOffset, pageSize: pageSize).then((value) {
        getErrorText = null;

        totalNotification = value.totalNotification;

        listNotification.value.addAll(value.listNotification);
        listNotification.value = List.from(listNotification.value);

        if (listNotification.value.length < totalNotification) {
          currentOffset += 10;
          isLoading = false;
        }
      });
    } catch (e) {
      getErrorText = e.toString();
      MyToast.showToast(
        isError: true,
        errorText: e.toString()
      );
    }
    isLoadMore.value = false;
  }

  deleteNotification({int? notificationId}) async {
    await EasyLoading.show(status: "Đang gỡ");
    
    try {
      await apiService.deleteNotification(notificationId: notificationId).then((value) {

        if (notificationId != null) {
          totalNotification -= 1;
          currentOffset != 1 ? currentOffset -= 1 : currentOffset = 1;
          listNotification.value.removeWhere((noti) => noti.id == notificationId);
          listNotification.value = List.from(listNotification.value);
        } else {
          totalNotification = 0;
          currentOffset = 1;
          listNotification.value.clear();
          listNotification.value = List.from(listNotification.value);
        }

        //Check end of list after delete noti
        //Need to have addPostFrameCallback to check frame after delete
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          _handleScroll();
        });

        MyToast.showToast(
          text: value
        );
      });
    } catch (e) {
      MyToast.showToast(
        isError: true,
        errorText: e.toString()
      );
    }
    await EasyLoading.dismiss();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - loadingIndicatorSize - 8 && !isLoading && listNotification.value.length < totalNotification) {
      loadListNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
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
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: buildAppBar(context),
      body: SafeArea(
        child: buildNotificationListView(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var closeButton = SizedBox(
      width: 100,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF5F5F5),
          foregroundColor: const Color(0xFF464646),
        ),
        onPressed: (){
          Navigator.of(context).pop();
        }, 
        child: const Text("Đóng")
      ),
    );

    var acceptButton = SizedBox(
      width: 100,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          Navigator.of(context).pop();
          await deleteNotification();
        }, 
        child: const Text("Gỡ")
      ),
    );

    return AppBar(
      title: const Text("Thông báo"),
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
      actions: [
        IconButton(
          icon: const Icon(MyIcons.delete),
          onPressed: () {
            !isLoadMore.value 
            ? showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                  iconPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  iconColor: Colors.black,
                  contentTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                  icon: const Icon(MyIcons.remove),
                  content: const Text(
                    "Gỡ toàn bộ thông báo?",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    closeButton,
                    acceptButton
                  ],
                );
              },
            )
            : null;
          }, 
        )
      ],
    );
  }

  Widget buildNotificationListView() {
    currentOffset = 1;

    return FutureBuilder(
      future: loadListNotification(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){

          return ValueListenableBuilder(
            valueListenable: listNotification,
            builder: (context, list, child) {

              if (getErrorText != null) {
                return Center(
                  child: Text(
                    "LỖI: $getErrorText!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: 12
                    ),
                  ),
                );
              }
              if (totalNotification == 0) {
                return const Center(
                  child: Text(
                    "Không có thông báo!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: 12
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(8),
                separatorBuilder: (_, __) => const SizedBox(height: 8,), 
                controller: _scrollController,
                itemCount: list.length + 1,
                itemBuilder: (BuildContext context, int index) {

                  if (index == list.length) {
                    return (listNotification.value.length < totalNotification)
                      ? const Center(
                        child: SizedBox(
                          height: loadingIndicatorSize,
                          width: loadingIndicatorSize,
                          child: CircularProgressIndicator(color: Color(0xFF1E3CFF), strokeWidth: 2.25,)
                        ),
                      )
                      : const Text(
                          "Đã tải toàn bộ thông báo!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10
                          ),
                        );
                    }

                  return buildListNotificationItem(listNotification.value[index], context);
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

  Widget buildListNotificationItem(NotificationData notificationData, BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 2, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB0B0B0).withOpacity(0.3),
              blurRadius: 1.5,
              offset: const Offset(0, 0.35),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: getStatusIcon(statusId: notificationData.newStatusId, size: 28)
                        ),
                        const SizedBox(width: 5,),
                        Flexible(
                          child: Text.rich(
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Yêu cầu "
                                ),
                                TextSpan(
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                  text: notificationData.request?.requestType ?? "NULL"
                                ),
                                const TextSpan(text: " "),
                                TextSpan(
                                  text: notificationData.newStatus?.toLowerCase()
                                )
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                Text(
                  notificationData.timePassed ?? "NULL",
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF848484)
                  ),
                ),
                const SizedBox(width: 5,),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: ValueListenableBuilder(
                    valueListenable: isLoadMore,
                    builder: (context, value, child) {
                      return !isLoadMore.value
                        ? PopupMenuButton(
                          position: PopupMenuPosition.under,
                          padding: EdgeInsets.zero,
                          surfaceTintColor: Colors.white,
                          color: Colors.white,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              height: 30,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              value: 0,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(MyIcons.remove, size: 18,),
                                  SizedBox(width: 5,),
                                  Flexible(
                                    child: Text(
                                      'Gỡ thông báo',
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                deleteNotification(notificationId: notificationData.id);
                              },
                            ),
                          ],
                          child: const Icon(MyIcons.more, size: 18,),
                        )
                        : IconButton(
                          icon: const Icon(MyIcons.more, size: 18,),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          onPressed: () {}, 
                        );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  const SizedBox(width: 33,),
                  Expanded(
                    child: Text(
                      notificationData.request?.info != null ? getRequestText(notificationData.request!.info!) : "NULL",
                      style: const TextStyle(
                        color: Color(0xFF505050),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RequestInformationPage(requestInfo: notificationData.request!,);
        },));
      },
    );
  }
  
}