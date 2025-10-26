import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lavescape/config/theme.dart';
import 'package:lavescape/providers/search_provider.dart';
import 'package:lavescape/screens/search/search_results_screen.dart';
import 'package:lavescape/services/mock_data_service.dart';
import 'package:provider/provider.dart';

class RecentSearchItem extends StatelessWidget {
  final Map<String, dynamic> search;

  const RecentSearchItem({super.key, required this.search});

  //  GET TRIP IMAGE BY TITLE
  String _getTripImageUrl() {
    try {
      final title = search['title'] ?? '';
      final trips = MockDataService.getMockTrips();

      if (trips.isEmpty) return '';

      final trip =
          trips
              .where((t) => t.name.toLowerCase().contains(title.toLowerCase()))
              .firstOrNull ??
          trips.first;

      return trip.imageUrl;
    } catch (e) {
      print('Error getting trip image: $e');
      return '';
    }
  }

  //  HANDLE RECENT SEARCH TAP
  void _handleRecentSearchTap(BuildContext context) {
    try {
      final searchProvider = Provider.of<SearchProvider>(
        context,
        listen: false,
      );

      //  SET SEARCH VALUES FROM SAVED DATA
      searchProvider.setLocation(search['city'] ?? '');
      searchProvider.setCategory(search['categoryIndex'] ?? 0);

      // Parse adults and children from guest string
      final guestStr = search['guest'] ?? '';
      if (guestStr.isNotEmpty) {
        final parts = guestStr.split(',');
        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.contains('Adult')) {
            final count =
                int.tryParse(trimmed.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            searchProvider.setAdults(count);
          } else if (trimmed.contains('Child')) {
            final count =
                int.tryParse(trimmed.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            searchProvider.setChildren(count);
          }
        }
      }

      //  NAVIGATE TO RESULTS
      Future.delayed(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchResultsScreen(),
            ),
          );
        }
      });
    } catch (e) {
      print('Error handling recent search: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading recent search')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getTripImageUrl();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () => _handleRecentSearchTap(context),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppTheme.borderGray),
          ),
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              //  IMAGE CONTAINER
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppTheme.lightGray,
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.lightGray,
                            child: Icon(
                              Icons.location_on,
                              color: AppTheme.gray,
                            ),
                          );
                        },
                      )
                    : Icon(Icons.location_on, color: AppTheme.gray),
              ),
              SizedBox(width: 12.w),

              //  TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      search['title'] ?? 'Trip',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Date
                    Text(
                      search['date'] ?? 'Aug 10-31',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.sp, color: AppTheme.gray),
                    ),

                    // City
                    if ((search['city'] ?? '').isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          search['city'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme.gray,
                            fontStyle: FontStyle.italic,
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
