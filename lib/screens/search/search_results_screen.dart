import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/search_provider.dart';
import '../../widgets/trip_card.dart';
import '../../widgets/smart_search_bar.dart';
import '../../services/mock_data_service.dart';
import '../map/map_view_screen.dart';
import '../../models/trip.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _isListView = true;
  Trip? _selectedTrip;

  final List<String> _categoryNames = [
    'I\'m Flexible',
    'Camel Riding',
    'Cooking Class',
    'Henna Art',
    'Coffee Brewing',
    'Food Tours',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, _) {
            return SmartSearchBar(
              isSummary: true,
              category: _categoryNames[searchProvider.selectedCategory],
              city: searchProvider.selectedLocation,
              dateRange: "Aug 10-31",
              guests: "${searchProvider.adults} Adults",
              onClear: () {
                searchProvider.reset();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onBack: () => Navigator.pop(context),
            );
          },
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          final filteredTrips = MockDataService.getTripsByCategory(
            _categoryNames[searchProvider.selectedCategory],
          );

          return Stack(
            children: [
              //  LIST VIEW OR MAP VIEW
              _isListView
                  ? (filteredTrips.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60.sp,
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No results found',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              top: 16.h,
                              bottom: 80.h,
                            ),
                            itemCount: filteredTrips.length,
                            itemBuilder: (context, index) {
                              final trip = filteredTrips[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: TripCard(trip: trip),
                              );
                            },
                          ))
                  : MapViewScreen(
                      trips: filteredTrips,
                      onTripSelected: (trip) {
                        setState(() => _selectedTrip = trip);
                      },
                      selectedTrip: _selectedTrip, //  PASS SELECTED TRIP
                    ),

              //  FLOATING BUTTON - ONLY SHOW ON LIST VIEW OR WHEN NO TRIP SELECTED
              if (_isListView || _selectedTrip == null)
                Positioned(
                  bottom: 20.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _isListView = !_isListView);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isListView ? Icons.map : Icons.list,
                              color: AppTheme.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _isListView ? 'Map View' : 'List View',
                              style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
