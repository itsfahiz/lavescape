import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuestCounter extends StatelessWidget {
  final String label;
  final String subtitle;
  final int count;
  final Function(int) onChanged;

  const GuestCounter({
    super.key,
    required this.label,
    required this.subtitle,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4.h),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: count > 0 ? () => onChanged(count - 1) : null,
            ),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(count + 1),
            ),
          ],
        ),
      ],
    );
  }
}
