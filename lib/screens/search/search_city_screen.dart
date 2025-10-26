import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lavescape/screens/search/widgets/city_search_field.dart';
import 'package:lavescape/screens/search/widgets/date_picker_field.dart';
import 'package:lavescape/screens/search/widgets/guest_picker_field.dart';
import 'package:lavescape/screens/search/widgets/recent_search_item.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/search_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/category_bar.dart';
import '../../widgets/smart_search_bar.dart';
import '../../services/storage_service.dart';
import '../search/search_results_screen.dart';

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key});

  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  late TextEditingController _cityController;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _categoryNames = [
    'I\'m Flexible',
    'Camel Riding',
    'Cooking Class',
    'Henna Art',
    'Coffee Brewing',
    'Food Tours',
  ];

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
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

  String _getGuestText(SearchProvider provider) {
    if (provider.adults == 0 && provider.children == 0) return '';
    List<String> guests = [];
    if (provider.adults > 0) {
      guests.add("${provider.adults} Adult${provider.adults > 1 ? 's' : ''}");
    }
    if (provider.children > 0) {
      guests.add(
        "${provider.children} Child${provider.children > 1 ? 'ren' : ''}",
      );
    }
    return guests.join(', ');
  }

  void _handleSearch(SearchProvider provider) {
    if (_cityController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a city')));
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select dates')));
      return;
    }
    if (provider.adults == 0 && provider.children == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please add guests')));
      return;
    }

    StorageService.addRecentSearch(
      city: _cityController.text,
      title: _categoryNames[provider.selectedCategory],
      date: _getDateRangeText(),
      image: '',
      guest: _getGuestText(provider),
      categoryIndex: provider.selectedCategory,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SearchResultsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmartSearchBar(
        isSummary: false,
        onBack: () => Navigator.pop(context),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                Container(
                  height: 4.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),

                // Category Bar
                CategoryBar(
                  selectedCategory: searchProvider.selectedCategory,
                  onCategoryChanged: (index) =>
                      searchProvider.setCategory(index),
                ),
                SizedBox(height: 20.h),

                // City Search
                CitySearchField(
                  controller: _cityController,
                  onCitySelected: (city) => searchProvider.setLocation(city),
                ),
                SizedBox(height: 24.h),

                // Date Picker
                DatePickerField(
                  startDate: _startDate,
                  endDate: _endDate,
                  onDatesSelected: (start, end) {
                    setState(() {
                      _startDate = start;
                      _endDate = end;
                    });
                  },
                ),
                SizedBox(height: 24.h),

                // Guest Picker
                GuestPickerField(
                  adults: searchProvider.adults,
                  children: searchProvider.children,
                  onAdultsChanged: (count) => searchProvider.setAdults(count),
                  onChildrenChanged: (count) =>
                      searchProvider.setChildren(count),
                ),
                SizedBox(height: 40.h),

                // Recent Searches
                if (StorageService.getRecentSearches().isNotEmpty) ...[
                  Text(
                    'Recent Search',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: StorageService.getRecentSearches().length,
                    itemBuilder: (context, index) {
                      final search = StorageService.getRecentSearches()[index];
                      return RecentSearchItem(search: search);
                    },
                  ),
                  SizedBox(height: 24.h),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 56.h,
                        child: OutlinedButton(
                          onPressed: () {
                            _cityController.clear();
                            searchProvider.reset();
                            setState(() {
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: 'Search',
                        onPressed: () => _handleSearch(searchProvider),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
