import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lavescape/config/theme.dart';
import 'package:lavescape/services/mock_data_service.dart';

class CitySearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onCitySelected;

  const CitySearchField({
    super.key,
    required this.controller,
    required this.onCitySelected,
  });

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  bool _showDropdown = false;

  List<String> _getFilteredCities() {
    final allCities = MockDataService.getPopularCities();
    final query = widget.controller.text.toLowerCase();
    return allCities
        .where((city) => city.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('City', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 12.h),
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: 'Search city...',
            prefixIcon: const Icon(Icons.location_on),
          ),
          onChanged: (value) => setState(() => _showDropdown = true),
        ),
        SizedBox(height: 16.h),

        // Dropdown or Popular Cities
        if (widget.controller.text.isNotEmpty && _showDropdown)
          _buildFilteredCitiesDropdown()
        else
          _buildPopularCities(),
      ],
    );
  }

  Widget _buildFilteredCitiesDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.borderGray),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4.r),
        ],
      ),
      child: _getFilteredCities().isEmpty
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'No cities found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getFilteredCities().length,
              itemBuilder: (context, index) {
                final city = _getFilteredCities()[index];
                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: AppTheme.primaryColor,
                    size: 18.sp,
                  ),
                  title: Text(
                    city,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    widget.controller.text = city;
                    widget.onCitySelected(city);
                    setState(() => _showDropdown = false);
                  },
                );
              },
            ),
    );
  }

  Widget _buildPopularCities() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: MockDataService.getPopularCities().map((city) {
        return GestureDetector(
          onTap: () {
            widget.controller.text = city;
            widget.onCitySelected(city);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppTheme.borderGray),
            ),
            child: Text(city, style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      }).toList(),
    );
  }
}
