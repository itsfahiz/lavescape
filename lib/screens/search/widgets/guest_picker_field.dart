import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lavescape/config/theme.dart';
import 'guest_counter.dart';

class GuestPickerField extends StatefulWidget {
  final int adults;
  final int children;
  final Function(int) onAdultsChanged;
  final Function(int) onChildrenChanged;

  const GuestPickerField({
    super.key,
    required this.adults,
    required this.children,
    required this.onAdultsChanged,
    required this.onChildrenChanged,
  });

  @override
  State<GuestPickerField> createState() => _GuestPickerFieldState();
}

class _GuestPickerFieldState extends State<GuestPickerField> {
  bool _showGuestPicker = false;

  String _getGuestText() {
    if (widget.adults == 0 && widget.children == 0) return '';
    List<String> guests = [];
    if (widget.adults > 0) {
      guests.add("${widget.adults} Adult${widget.adults > 1 ? 's' : ''}");
    }
    if (widget.children > 0) {
      guests.add("${widget.children} Child${widget.children > 1 ? 'ren' : ''}");
    }
    return guests.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Guest', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _showGuestPicker = !_showGuestPicker),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Select guests',
                    filled: true,
                    fillColor: AppTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppTheme.borderGray),
                    ),
                  ),
                  controller: TextEditingController(text: _getGuestText()),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: AppTheme.white),
                onPressed: () =>
                    setState(() => _showGuestPicker = !_showGuestPicker),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (_showGuestPicker)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTheme.borderGray),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                GuestCounter(
                  label: 'Adults',
                  subtitle: 'Ages 13 or above',
                  count: widget.adults,
                  onChanged: widget.onAdultsChanged,
                ),
                SizedBox(height: 24.h),
                GuestCounter(
                  label: 'Children',
                  subtitle: 'Ages 3 or below',
                  count: widget.children,
                  onChanged: widget.onChildrenChanged,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
