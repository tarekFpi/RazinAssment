import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:assignment_asl/core/features/task/task_create_screen.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllTaskScreen extends StatefulWidget {

  AllTaskScreen({Key? key}) : super(key: key);

  @override
  State<AllTaskScreen> createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {


  final taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      extendBody: true,
      backgroundColor: HexColor("#EEEFFF"),
      appBar: AppBar(
        //toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:Text(
          "All Task ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [

          Padding(
            padding: EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: (){
               Get.to(()=>CreateTaskPage());
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: HexColor("#613BE7").withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30)),
                child: Text("Create New",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: HexColor("#613BE7"))),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Days Row
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        taskController.daysInMonth.length,
                            (index) {
                          final date = taskController.daysInMonth[index];
                          final isSelected =
                              taskController.selectedDate.value.day == date.day &&
                                  taskController.selectedDate.value.month == date.month &&
                                  taskController.selectedDate.value.year == date.year;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () => taskController.selectDate(date),
                              child: Container(
                                width: 60,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? HexColor("##613BE7")
                                      :   HexColor("#EBF2FF").withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat.E().format(date), // e.g. Mon
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : HexColor("#613BE7"),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      DateFormat.d().format(date), // e.g. 12
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : HexColor("#613BE7"),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),


                SizedBox(
                  height: 24,
                ),
                // Task list
                Obx(() {
                  final taskList = taskController.filteredDateTasks;
                  if (taskList.isEmpty) {
                    return SizedBox(
                        height: MediaQuery.sizeOf(context).height/4,
                        child: Center(child: Text("No tasks for today",style: TextStyle(color: Colors.red,
                            fontSize: 18
                        ),)));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      final task = taskList[index];

                      return InkWell(
                        onTap: (){

                        },
                        child: TaskCard(
                          title: task['name'],
                          description: task['description'],
                          date: task['startDate'],
                          status: task['status'],
                          statusColor: task['status'] == "Todo" ? Colors.purple : Colors.grey,
                        ),
                      );
                    },
                  );
                })
              ],
            );
          }),
        ),
      ),


    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String status;
  final Color statusColor;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {

    final dateformate = DateTime.tryParse(date) ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(description,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),

                  Text(DateFormat('MMMM d, yyyy').format(dateformate),
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[700])),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: HexColor("#613BE7").withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(status,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: HexColor("#613BE7"))),
              )
            ],
          )
        ],
      ),
    );
  }
}
