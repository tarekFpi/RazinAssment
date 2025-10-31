import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:assignment_asl/core/features/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskPage extends StatefulWidget {
  CreateTaskPage({Key? key}) : super(key: key);

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {

  final   taskController = Get.put(TaskController());

  @override
  void dispose() {

    taskController.nameController.clear();
    taskController.descController.clear();
    taskController.endDate.value = null;
    taskController.startDate.value = null;

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //backgroundColor: HexColor("#EEEFFF"),
      backgroundColor: const Color(0xfff8f9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f9ff),
        toolbarHeight: 70,
        elevation: 0,
        title: const Text(
          "Create new task",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
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

                            //taskController.createTask
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

                              taskController.addTask(
                                taskController.nameController.text,
                                taskController.descController.text,
                                taskController.startDate.value.toString(),
                                taskController.endDate.value.toString(),
                                "todo",
                              );
                            }
                          },
                          child: const Text(
                            "Create new task",
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
