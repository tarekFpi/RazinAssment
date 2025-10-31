
import 'package:assignment_asl/core/features/nav/home/model/post_reponse.dart';
import 'package:assignment_asl/core/features/network/dio_client.dart';
import 'package:assignment_asl/core/features/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with StateMixin<List<PostReponseModel>> {

  final dioClient = DioClient.instance;



  var currentPageIndex = 0.obs;

  void changeBottomTab(int index) {
    currentPageIndex.value = index;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

}