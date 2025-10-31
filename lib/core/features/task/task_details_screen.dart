import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class TaskDetailsScreen extends StatefulWidget {

  final Map<String, dynamic> task;

    TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final  taskController = Get.put(TaskController());

  @override
  void initState() {

    if(widget.task!=null){

      taskController.nameController.text=widget.task["name"];
      taskController.descController.text=widget.task["description"];

      final startDateString = widget.task["startDate"] ?? '';
      final endDateString = widget.task["endDate"] ?? '';

      taskController.startDate.value = DateTime.tryParse(startDateString) ?? DateTime.now();
      taskController.endDate.value = DateTime.tryParse(endDateString) ?? DateTime.now();


    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {

    taskController.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: HexColor("#EEEFFF"),
      appBar: AppBar(
        //toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:   Text(
          "View Task",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        actions: [

          Padding(
            padding: EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: (){
                taskController.removeTask(widget.task['id']);
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: HexColor("#FF494C").withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30)),
                child: Text("Delete",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: HexColor("#FF494C"))),
              ),
            ),
          )
        ],
      ),
      body: Obx(
              () {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text("Task Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: taskController.nameController,
                          decoration: InputDecoration(
                            hintText: "Enter Your Task Name",
                            hintStyle: const TextStyle(color: Color(0xFFA4A4A4)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Color(0xFFE8E8F2), width: 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Color(0xFF6A4BFF), width: 1.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text("Task Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: taskController.descController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Enter task description...",
                            hintStyle: const TextStyle(color: Color(0xFFA4A4A4)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Color(0xFFE8E8F2), width: 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Color(0xFF6A4BFF), width: 1.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Start Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 15)),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () =>
                                        taskController.pickDate(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFFE8E8F2)),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            taskController.startDate.value == null
                                                ? "Select Date"
                                                : "${taskController.startDate.value!.day}/${taskController.startDate.value!.month}/${taskController.startDate.value!.year}",
                                            style: const TextStyle(
                                                color: Color(0xFFA4A4A4),
                                                fontSize: 12),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xFF6A4BFF),
                                              size: 20),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("End Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 15)),
                                  const SizedBox(height: 8),
                                  Obx(() => InkWell(
                                    onTap: () =>
                                        taskController.pickDate(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFFE8E8F2)),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            taskController.endDate.value == null
                                                ? "Select Date"
                                                : "${taskController.endDate.value!.day}/${taskController.endDate.value!.month}/${taskController.endDate.value!.year}",
                                            style: const TextStyle(
                                                color: Color(0xFFA4A4A4),
                                                fontSize: 12),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Color(0xFF6A4BFF),
                                              size: 20),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A4BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            onPressed: (){

                              if (taskController.nameController.text.trim().isEmpty) {

                                Get.snackbar(
                                  'Missing fields',
                                  'Please name required fields.',
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );


                              }else if(taskController.descController.text.trim().isEmpty){
                                Get.snackbar(
                                  'Missing fields',
                                  'Please description required fields.',
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              }else if(taskController.startDate.value.isNull){
                                Get.snackbar(
                                  'Missing fields',
                                  'Please start Date required fields.',
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );

                              }else if(taskController.endDate.value.isNull){
                                Get.snackbar(
                                  'Missing fields',
                                  'Please end Date required fields.',
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              }else{

                                taskController.editTask(widget.task['id'], "complete");
                              }
                            },
                            child: const Text(
                              "Complete",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
