import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/theme.dart';
import '../../providers/search_provider.dart';
import '../../widgets/custom_button.dart';
import 'search_results_screen.dart';

class SearchSelectionScreen extends StatefulWidget {
  const SearchSelectionScreen({super.key});

  @override
  State<SearchSelectionScreen> createState() => _SearchSelectionScreenState();
}

class _SearchSelectionScreenState extends State<SearchSelectionScreen> {
  late TextEditingController _locationController;
  late PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Search Details'),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return Column(
            children: [
              // Progress Indicator
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        height: 4.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? AppTheme.primaryColor
                              : AppTheme.borderGray,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentStep = index);
                  },
                  children: [
                    _buildLocationStep(context),
                    _buildDateStep(context),
                    _buildGuestStep(context),
                  ],
                ),
              ),

              // Navigation Buttons
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(),
                          onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentStep > 0) SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        text: _currentStep == 2 ? 'Search' : 'Next',
                        onPressed: () {
                          if (_currentStep < 2) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SearchResultsScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLocationStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where are you going?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          SizedBox(height: 20.h),
          Text('Location', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8.h),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Search destination...',
              prefixIcon: const Icon(Icons.location_on),
            ),
            onChanged: (value) {
              Provider.of<SearchProvider>(
                context,
                listen: false,
              ).setLocation(value);
            },
          ),
          SizedBox(height: 20.h),
          Text(
            'Popular Destinations',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children:
                ['Dubai', 'Bali', 'Paris', 'Tokyo', 'New York', 'Barcelona']
                    .map(
                      (dest) => GestureDetector(
                        onTap: () {
                          _locationController.text = dest;
                          Provider.of<SearchProvider>(
                            context,
                            listen: false,
                          ).setLocation(dest);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppTheme.borderGray),
                          ),
                          child: Text(
                            dest,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStep(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'When are you traveling?',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 20.h),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: searchProvider.selectedDate ?? DateTime.now(),
                selectedDayPredicate: (day) {
                  return isSameDay(searchProvider.selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  searchProvider.setDate(selectedDay);
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
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuestStep(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Who\'s traveling?',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 40.h),

              // Adults
              _buildGuestSelector(
                context,
                'Adults',
                searchProvider.adults,
                (value) => searchProvider.setAdults(value),
              ),
              SizedBox(height: 24.h),

              // Children
              _buildGuestSelector(
                context,
                'Children',
                searchProvider.children,
                (value) => searchProvider.setChildren(value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuestSelector(
    BuildContext context,
    String label,
    int count,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppTheme.borderGray),
          ),
          child: Row(
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
        ),
      ],
    );
  }
}
