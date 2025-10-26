import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lavescape/config/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime, DateTime) onDatesSelected;

  const DatePickerField({
    super.key,
    this.startDate,
    this.endDate,
    required this.onDatesSelected,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  bool _showDatePicker = false;
  DateTime _focusedDay = DateTime.now();
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  String _getDateRangeText() {
    if (_startDate == null || _endDate == null) return '';
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String startMonth = monthNames[_startDate!.month - 1];
    String endMonth = monthNames[_endDate!.month - 1];
    if (_startDate!.month == _endDate!.month) {
      return "$startMonth ${_startDate!.day}-${_endDate!.day}";
    }
    return "$startMonth ${_startDate!.day}-$endMonth ${_endDate!.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Date', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => setState(() => _showDatePicker = !_showDatePicker),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Select date range',
              suffixIcon: Icon(
                Icons.calendar_today,
                color: AppTheme.primaryColor,
              ),
              filled: true,
              fillColor: AppTheme.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppTheme.borderGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppTheme.borderGray),
              ),
            ),
            controller: TextEditingController(text: _getDateRangeText()),
          ),
        ),
        SizedBox(height: 12.h),
        if (_showDatePicker)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTheme.borderGray),
            ),
            padding: EdgeInsets.all(16.w),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(day, _startDate) || isSameDay(day, _endDate),
              rangeStartDay: _startDate,
              rangeEndDay: _endDate,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  if (_startDate == null) {
                    _startDate = selectedDay;
                  } else if (_endDate == null) {
                    if (selectedDay.isBefore(_startDate!)) {
                      _endDate = _startDate;
                      _startDate = selectedDay;
                    } else {
                      _endDate = selectedDay;
                    }
                    _showDatePicker = false;
                    widget.onDatesSelected(_startDate!, _endDate!);
                  } else {
                    _startDate = selectedDay;
                    _endDate = null;
                  }
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: AppTheme.white),
                rangeStartDecoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                rangeHighlightColor: AppTheme.primaryColor.withOpacity(0.1),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: Theme.of(context).textTheme.titleLarge!,
              ),
            ),
          ),
      ],
    );
  }
}
