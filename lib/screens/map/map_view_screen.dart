import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme.dart';
import '../../models/trip.dart';
import '../../widgets/trip_card.dart';

class MapViewScreen extends StatefulWidget {
  final List<Trip>? trips;
  final Function(Trip?)? onTripSelected;
  final Trip? selectedTrip;

  const MapViewScreen({
    super.key,
    this.trips,
    this.onTripSelected,
    this.selectedTrip,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  Trip? _selectedTrip;

  @override
  void initState() {
    super.initState();
    _selectedTrip = widget.selectedTrip;
  }

  @override
  void didUpdateWidget(MapViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTrip != oldWidget.selectedTrip) {
      _selectedTrip = widget.selectedTrip;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTrips = widget.trips ?? [];

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.lightGray,
          child: displayTrips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 80.sp,
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'No trips on map',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 80.sp,
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                    SizedBox(height: 20.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: displayTrips
                          .map((trip) => _buildMapPin(trip))
                          .toList(),
                    ),
                  ],
                ),
        ),

        // FLOATING TRIP CARD AT BOTTOM - ONLY WHEN TRIP SELECTED
        if (_selectedTrip != null)
          Positioned(
            bottom: 20.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16.r,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: TripCard(trip: _selectedTrip!),
                    ),
                  ),

                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedTrip = null);
                        widget.onTripSelected?.call(null);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                        child: Icon(Icons.close, size: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMapPin(Trip trip) {
    final isSelected = _selectedTrip?.id == trip.id;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedTrip = trip);
        widget.onTripSelected?.call(trip);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderGray,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8.r,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 14.sp,
              color: isSelected ? AppTheme.white : AppTheme.primaryColor,
            ),
            SizedBox(width: 4.w),
            Text(
              '\$${trip.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.white : AppTheme.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
