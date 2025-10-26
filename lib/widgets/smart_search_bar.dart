import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme.dart';

class SmartSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSummary;
  final String? category;
  final String? city;
  final String? dateRange;
  final String? guests;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final VoidCallback? onTapFilter;

  const SmartSearchBar({
    super.key,
    this.isSummary = false,
    this.category,
    this.city,
    this.dateRange,
    this.guests,
    this.onClear,
    this.onBack,
    this.onTapFilter,
  });

  @override
  Size get preferredSize => Size.fromHeight(isSummary ? 72.h : 56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.white),
                onPressed: onBack ?? () => Navigator.pop(context),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: isSummary ? 50.h : 40.h,
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 10.w, //  MORE RIGHT PADDING
                        top: 4.h,
                        bottom: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: isSummary
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // LINE 1: CATEGORY ONLY - CENTER ALIGNED
                                if (category != null && category!.isNotEmpty)
                                  Flexible(
                                    child: Center(
                                      child: Text(
                                        category!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: AppTheme.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 3.h),
                                //  LINE 2: CITY • DATE • GUESTS
                                Flexible(
                                  child: Row(
                                    children: [
                                      if (city != null && city!.isNotEmpty)
                                        Expanded(
                                          child: Text(
                                            city!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppTheme.gray,
                                            ),
                                          ),
                                        ),
                                      if (dateRange != null &&
                                          dateRange!.isNotEmpty) ...[
                                        SizedBox(width: 3.w),
                                        Text(
                                          "•",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                            color: AppTheme.gray,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Text(
                                            dateRange!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppTheme.gray,
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (guests != null &&
                                          guests!.isNotEmpty) ...[
                                        SizedBox(width: 3.w),
                                        Text(
                                          "•",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                            color: AppTheme.gray,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Text(
                                            guests!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppTheme.gray,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppTheme.gray,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    "Search",
                                    style: TextStyle(
                                      color: AppTheme.gray,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: onTapFilter,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: Icon(
                                      Icons.tune,
                                      color: AppTheme.gray,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    //  CLOSE ICON INSIDE CONTAINER ON RIGHT
                    if (isSummary)
                      Positioned(
                        right: 8.w,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: onClear,
                            child: Icon(
                              Icons.close,
                              color: AppTheme.black,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
