import 'package:assignment_asl/core/features/nav/nav_screen.dart';
import 'package:assignment_asl/core/features/utils/db_helper.dart';
import 'package:assignment_asl/core/features/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  /// edit textFild

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  void pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }

  // 0 = All tasks, 1 = Completed
  var selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  var  tasks = <Map<String, dynamic>>[].obs;
  //var selectedTab = 0.obs; // 0 = All tasks (Todo), 1 = Completed

  Future<void> fetchTasks() async {
    final data = await DBHelper.getTasks();
    tasks.value = data;
  }

  List<Map<String, dynamic>> get filteredTasks {
    final today = DateTime.now();

    return tasks.where((task) {
      final taskDate = DateTime.tryParse(task['startDate'] ?? '');
      if (taskDate == null) return false;

      // Filter by today
      if (taskDate.year != today.year ||
          taskDate.month != today.month ||
          taskDate.day != today.day) return false;

      // Filter by selected tab
      if (selectedTab.value == 0) {
        return task['status']?.toLowerCase() == 'todo';
      } else if (selectedTab.value == 1) {
        return task['status']?.toLowerCase() == 'complete';
      }

      return true; // fallback
    }).toList();
  }


  Future<void> addTask(String name, String desc, String start, String end,String status) async {
    await DBHelper.insertTask({
      'name': name,
      'description': desc,
      'startDate': start,
      'endDate': end,
      'status': status,
    });

    Get.snackbar(
      'created',
      'Task "${nameController.text}" created successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    clear();
    await fetchTasks();
  }



  // Edit existing task

  Future<void> editTask(int id,String status) async {
    // Prepare updated task data
    final updatedTask = {
      'name': nameController.text,
      'description': descController.text,
      'startDate': startDate.value.toString() ,
      'endDate': endDate.value.toString(),
      'status':status, // make sure you have status in your controller
    };

    // Update in DB
    await DBHelper.updateTask(id, updatedTask);

    // Show snackbar
    Get.snackbar(
      'updated',
      'Task updated successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Refresh task list
    await fetchTasks();
    clear();

    Get.off(()=>NavScreen());
   // Get.back();
  }

  // Delete task
  Future<void> removeTask(int id) async {
    await DBHelper.deleteTask(id);

    Get.snackbar(
      'Delete',
      'Task Delete successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    await fetchTasks(); // refresh list

    Get.off(()=>NavScreen());
  }


  void clear(){

     nameController.clear();
     descController.clear();
     endDate.value = null;
    startDate.value = null;
  }



  // Reactive date string
  var formattedDate = ''.obs;

  /// water screen horizontal
  var selectedDate = DateTime.now().obs;
  var daysInMonth = <DateTime>[].obs;


  var currentDate = ''.obs;

  void loadCurrentMonthDates() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final totalDays = DateTime(now.year, now.month + 1, 0).day;

    daysInMonth.value = List.generate(
      totalDays,
          (i) => firstDay.add(Duration(days: i)),
    );

    final formatter = DateFormat('yyyy-MM-dd');
    currentDate.value = formatter.format(now);

  }

  void selectDate(DateTime date) {
    selectedDate.value = date;

    final formatter = DateFormat('yyyy-MM-dd');
    formattedDate.value = formatter.format(selectedDate.value);

    debugPrint("formattedDate:${formattedDate.value}");

    filterTasksByDate(date);

    ///retrive water date  for today
   // retriveWaterCalories(formattedDate.value);
  }


  var filteredDateTasks = <Map<String, dynamic>>[].obs;
  /// Filter tasks where startDate OR endDate matches the selected date
  void filterTasksByDate(DateTime selectedDate) {
    // Optional: show toast for debugging
    Toast.errorToast("Selected: ${DateFormat('yyyy-MM-dd').format(selectedDate)}");

    filteredDateTasks.value = tasks.where((task) {
      try {
        final startDate = DateTime.parse(task['startDate']); // e.g. 2025-10-30
        final endDate = DateTime.parse(task['endDate']);     // e.g. 2025-11-02

        // normalize selected date (ignore time)
        final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

        // ✅ inclusive condition: selectedDate BETWEEN startDate AND endDate
        return (selected.isAtSameMomentAs(startDate) ||
            selected.isAtSameMomentAs(endDate) ||
            (selected.isAfter(startDate) && selected.isBefore(endDate)));
      } catch (e) {
        print("Error filtering task: $e");
        return false;
      }
    }).toList();

    print("Filtered count: ${filteredDateTasks.length}");
  }






  @override
  void onInit() {

    fetchTasks();

    loadCurrentMonthDates();

    // TODO: implement onInit
    super.onInit();
  }


  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }
}
