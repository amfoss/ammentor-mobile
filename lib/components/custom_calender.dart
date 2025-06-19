import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

Future<void> showModernCalendarPicker({
  required BuildContext context,
  required DateTime selectedDate,
  required Function(DateTime) onDateSelected,
}) async {
  DateTime focusedDay = selectedDate;
  DateTime selectedDay = selectedDate;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                currentDay: null, 
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white70),
                  rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white70),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.w600,
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white70),
                  todayTextStyle: const TextStyle(color: Colors.white),
                  todayDecoration: const BoxDecoration(), 
                ),
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  onDateSelected(selectedDay);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}