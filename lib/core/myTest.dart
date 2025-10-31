import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- MAIN APPLICATION SETUP ---
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Call initializeDateFormatting() if you need other locales besides default
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figma Redesign Demo',
      theme: ThemeData(
        // Use a light, modern theme
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade50,
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

// --- TASK MODEL ---

enum TaskStatus { todo, complete }

class Task {
  final String title;
  final String description;
  final DateTime date;
  final TaskStatus status;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });
}

// --- DATA SOURCE ---

final List<Task> dummyTasks = [
  Task(
    title: 'Homepage Redesign',
    description:
    'Redesign the homepage of our website to improve user engagement and align with our updated brand...',
    date: DateTime.parse('2023-10-15'),
    status: TaskStatus.todo,
  ),
  Task(
    title: 'E-commerce Checkout Process Redesign',
    description:
    'Redesign the checkout process for our e-commerce platform, focusing on improving conver...',
    date: DateTime.parse('2023-12-10'),
    status: TaskStatus.complete,
  ),
  Task(
    title: 'E-commerce Checkout Process Redesign',
    description:
    'Redesign the checkout process for our e-commerce platform, focusing on improving conver...',
    date: DateTime.parse('2023-12-10'),
    status: TaskStatus.complete,
  ),
  Task(
    title: 'Marketing Campaign Launch',
    description:
    'Prepare all assets and schedule posts for the new product marketing campaign...',
    date: DateTime.parse('2025-11-05'),
    status: TaskStatus.todo,
  ),
];

// --- MAIN SCREEN WIDGET ---

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  DateTime _selectedDate = DateTime.now();
  final ScrollController _calendarScrollController = ScrollController();
  final DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  final DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  late int _totalDays;
  final double _itemWidth = 71.0; // Based on Figma design suggestion

  @override
  void initState() {
    super.initState();
    _totalDays = _endDate.difference(_startDate).inDays;

    // Scroll to today's date on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToDate(_selectedDate, animate: false);
    });
  }

  int _indexOfDate(DateTime date) {
    return date.difference(_startDate).inDays;
  }

  void _scrollToDate(DateTime date, {bool animate = true}) {
    final index = _indexOfDate(date);
    const double padding = 8.0;

    // Calculate the offset to position the selected item in the center
    final double centerOffset = (MediaQuery.of(context).size.width / 2) - (_itemWidth / 2);
    final double itemOffset = index * (_itemWidth + padding * 2);
    final double scrollOffset = itemOffset - centerOffset;


    if (animate) {
      _calendarScrollController.animateTo(
        scrollOffset.clamp(0.0, _calendarScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _calendarScrollController.jumpTo(scrollOffset.clamp(0.0, _calendarScrollController.position.maxScrollExtent));
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day); // Normalize time
    });
    _scrollToDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. Horizontal Calendar Section
          HorizontalCalendar(
            startDate: _startDate,
            endDate: _endDate,
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
            scrollController: _calendarScrollController,
            itemWidth: _itemWidth,
          ),

          // 2. Task List Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              itemCount: dummyTasks.length,
              itemBuilder: (context, index) {
                final task = dummyTasks[index];
                // In a real app, you would filter tasks by _selectedDate here
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 16.0, right: 16.0),
                  child: TaskCard(task: task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET 1: HORIZONTAL CALENDAR ---

class HorizontalCalendar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final ScrollController scrollController;
  final double itemWidth;

  const HorizontalCalendar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.onDateSelected,
    required this.scrollController,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    final int totalDays = endDate.difference(startDate).inDays + 1;

    return Container(
      height: 120, // Height to accommodate the date item and padding
      color: Colors.white, // Background color for the calendar strip
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: totalDays,
        itemBuilder: (context, index) {
          final currentDate = startDate.add(Duration(days: index));
          final bool isSelected = currentDate.day == selectedDate.day &&
              currentDate.month == selectedDate.month &&
              currentDate.year == selectedDate.year;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => onDateSelected(currentDate),
              child: DateItem(
                date: currentDate,
                isSelected: isSelected,
                width: itemWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- WIDGET 1a: DATE ITEM (CALENDAR CELL) ---

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final double width;

  const DateItem({
    super.key,
    required this.date,
    required this.isSelected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Colors from Figma design (Purple/Indigo theme)
    const Color selectedColor = Color(0xFF6A5ACD); // A distinct purple
    const Color unselectedBgColor = Colors.white;
    const Color unselectedTextColor = Color(0xFF6A5ACD); // Purple text
    const Color selectedTextColor = Colors.white;

    final String dayOfWeek = DateFormat.E().format(date).substring(0, 3); // Mon, Tue, etc.
    final String dayOfMonth = DateFormat.d().format(date);

    return Container(
      width: width,
      height: 90, // Item height
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : unselectedBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? selectedColor : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: selectedColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Day of the week (e.g., 'Mon')
          Text(
            dayOfWeek,
            style: TextStyle(
              color: isSelected ? selectedTextColor : unselectedTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Day number (e.g., '21')
          Text(
            dayOfMonth,
            style: TextStyle(
              color: isSelected ? selectedTextColor : unselectedTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET 2: TASK CARD ---

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Determine colors for the status pill
    Color pillColor;
    Color pillTextColor;
    String pillText;

    if (task.status == TaskStatus.todo) {
      pillColor = const Color(0xFFEDE7F6); // Light Purple
      pillTextColor = const Color(0xFF6A5ACD); // Purple
      pillText = 'Todo';
    } else {
      pillColor = const Color(0xFFE8F5E9); // Light Green
      pillTextColor = const Color(0xFF4CAF50); // Green
      pillText = 'Complete';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white, // White background for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              task.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // Date and Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date with Clock Icon
                Row(
                  children: [
                    Icon(
                      Icons.schedule, // Clock icon
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMMM d, yyyy').format(task.date),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),

                // Status Pill
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: pillColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pillText,
                    style: TextStyle(
                      color: pillTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}