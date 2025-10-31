
import 'package:assignment_asl/core/features/nav/home/home_controller.dart';
import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:assignment_asl/core/features/task/task_details_screen.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:assignment_asl/core/features/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final homeController = Get.put(HomeController());

  final taskController = Get.put(TaskController());


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        extendBody: true,
         backgroundColor: const Color(0xfff8f9ff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(12), // <-- custom height here
          child: AppBar(
            backgroundColor: const Color(0xfff8f9ff),
            elevation: 0,
          ),
        ),
      body: Obx(
          () {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good morning Liam!",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey[600])),

                          const SizedBox(height: 6),

                          Text(homeController.formattedSelectedDate,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const Icon(Icons.notifications_none_rounded, size: 28),
                    ],
                  ),
              
                  const SizedBox(height: 20),
              
                  // Summary Section
                  Text("Summary",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _summaryCard("Assigned tasks", "${taskController.selectedTab.value==0?taskController.filteredTasks.length:0}", HexColor('#EEEFFF'),
                            HexColor('#855EA9')),
                      ),
              
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: _summaryCard("Completed tasks", "${taskController.selectedTab.value==1?taskController.filteredTasks.length:0}",
                            Colors.green.shade50, Colors.green),
                      ),
                    ],
                  ),
              
                  const SizedBox(height: 25),
              
                  // Today tasks section
                  Text("Today tasks",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),
              
                  const SizedBox(height: 12),
              
                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => taskController.changeTab(0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: taskController.selectedTab.value == 0
                                    ? HexColor("#613BE7")
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "All tasks",
                                  style: GoogleFonts.poppins(
                                    color: taskController.selectedTab.value == 0
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => taskController.changeTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: taskController.selectedTab.value == 1
                                    ? HexColor("#613BE7")
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Completed",
                                  style: GoogleFonts.poppins(
                                    color: taskController.selectedTab.value == 1
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
              
                  const SizedBox(height: 16),
              
                  // Task list
                  Obx(() {
                    final taskList = taskController.filteredTasks;
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

                            Get.to(()=>TaskDetailsScreen(task: task));
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
              ),
            ),
          );
        }
      ),


    );
  }




  Widget _summaryCard(
      String title, String count, Color bgColor, Color borderColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(count,
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold, color: borderColor)),
        ],
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
