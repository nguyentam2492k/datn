import 'package:datn/constants/my_icons.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/notification_data/notification_data.dart';
import 'package:datn/screens/request_information/request_information_page.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotificationPageState();
  }
  
}

class NotificationPageState extends State<NotificationPage> {

  static const double loadingIndicatorSize = 20;
  static const double requestStatusBarHeight = 45;
  static const int maxLines = 4;

  APIService apiService = APIService();
  ValueNotifier<List<NotificationData>> listNotification = ValueNotifier([]);

  int currentPage = 1;
  int pageSize = 10;
  int totalNotification = 99;
  String? getErrorText;

  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  Future<void> loadListNotification() async {
    isLoading = true;

    if (currentPage == 1) {
      listNotification.value = [];
    }

    try {
      await apiService.getListNotification(pageIndex: currentPage, pageSize: pageSize).then((value) {
        getErrorText = null;

        totalNotification = value.totalNotification;

        listNotification.value.addAll(value.listNotification);
        listNotification.value = List.from(listNotification.value);
        
        if (listNotification.value.length < totalNotification) {
          currentPage += 1;
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
  }

  deleteNotification({int? notificationId}) {
    print("XOÁ $notificationId");
  }

  void _handleScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - loadingIndicatorSize && !isLoading && listNotification.value.length < totalNotification) {
      loadListNotification();
    }
  }

  @override
  void initState() {
    super.initState();
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
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: buildAppBar(),
      body: SafeArea(
        child: buildNotificationListView(),
      ),
    );
  }

  AppBar buildAppBar() {
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
            deleteNotification();
          }, 
        )
      ],
    );
  }

  Widget buildNotificationListView() {
    currentPage = 1;

    return FutureBuilder(
      future: loadListNotification(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          
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

          return ValueListenableBuilder(
            valueListenable: listNotification,
            builder: (context, list, child) {

              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(8),
                separatorBuilder: (_, __) => const SizedBox(height: 8,), 
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
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 10),
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
                  child: PopupMenuButton(
                    position: PopupMenuPosition.under,
                    padding: EdgeInsets.zero,
                    surfaceTintColor: Colors.white,
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
                        onTap: () {
                          deleteNotification(notificationId: notificationData.id);
                        },
                      ),
                    ],
                    child: const Icon(MyIcons.more, size: 20,),
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