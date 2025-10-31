
import 'package:assignment_asl/core/features/nav/home/model/post_reponse.dart';
import 'package:assignment_asl/core/features/network/dio_client.dart';
import 'package:assignment_asl/core/features/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController with StateMixin<List<PostReponseModel>> {

  final dioClient = DioClient.instance;


  var currentPageIndex = 0.obs;
  void changeBottomTab(int index) {
    currentPageIndex.value = index;
  }


  // Reactive selected date
  var selectedDate = DateTime.now().obs;

  // Function to update the selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Optional: nicely formatted date string (e.g. "21 Sept, 2025")
  String get formattedSelectedDate {
    return DateFormat('dd MMM, yyyy').format(selectedDate.value);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

}