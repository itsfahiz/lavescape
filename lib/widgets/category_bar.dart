import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/theme.dart';

class CategoryBar extends StatefulWidget {
  final int selectedCategory;
  final Function(int) onCategoryChanged;

  const CategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  final List<Map<String, String>> _categories = [
    {"title": "I'm Flexible", "icon": "assets/icons/flexible.svg"},
    {"title": "Camel Riding", "icon": "assets/icons/camel_riding.svg"},
    {"title": "Cooking Class", "icon": "assets/icons/cooking_class.svg"},
    {"title": "Henna Art", "icon": "assets/icons/henna_art.svg"},
    {"title": "Coffee Brewing", "icon": "assets/icons/coffee_brewing.svg"},
    {"title": "Food Tours", "icon": "assets/icons/food_tours.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = widget.selectedCategory == index;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: GestureDetector(
              onTap: () {
                widget.onCategoryChanged(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: isSelected
                          ? Border.all(color: AppTheme.primaryColor, width: 2)
                          : Border.all(color: AppTheme.borderGray),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        _categories[index]['icon']!,
                        height: 24.h,
                        width: 24.w,
                        colorFilter: ColorFilter.mode(
                          isSelected ? AppTheme.primaryColor : AppTheme.gray,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  SizedBox(
                    width: 56.w,
                    child: Text(
                      _categories[index]['title']!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 7.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
