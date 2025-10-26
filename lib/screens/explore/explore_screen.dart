import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lavescape/screens/explore/notifications_screen.dart';
import 'package:lavescape/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/trip_card.dart';
import '../../widgets/category_bar.dart';
import '../../services/mock_data_service.dart';
import '../search/search_city_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.gray,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const ExploreMainScreen();
      case 1:
        return _buildDummyScreen('Reservation', Icons.calendar_today);
      case 2:
        return _buildDummyScreen('Wishlist', Icons.favorite);
      case 3:
        return _buildDummyScreen('Inbox', Icons.mail);
      case 4:
        return _buildProfileScreen();
      default:
        return const ExploreMainScreen();
    }
  }

  Widget _buildDummyScreen(String title, IconData icon) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80.sp, color: AppTheme.primaryColor),
            SizedBox(height: 24.h),
            Text(title, style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 8.h),
            Text('Coming soon', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileField(
                          'Full Name',
                          user?.fullName ?? 'N/A',
                        ),
                        SizedBox(height: 16.h),
                        _buildProfileField('Phone', user?.phoneNumber ?? 'N/A'),
                        SizedBox(height: 16.h),
                        _buildProfileField('Email', user?.email ?? 'N/A'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorRed,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //  CLOSE DIALOG FIRST
                                  Navigator.pop(context);

                                  //  LOGOUT
                                  await Provider.of<AuthProvider>(
                                    context,
                                    listen: false,
                                  ).logout();

                                  //  NAVIGATE TO SPLASH SCREEN
                                  if (mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SplashScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },

                      child: const Text('Logout'),
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

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class ExploreMainScreen extends StatelessWidget {
  const ExploreMainScreen({super.key});

  final List<String> _categoryNames = const [
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
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: AppTheme.gray),
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchCityScreen(),
                ),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppTheme.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          //  USE PROVIDER CATEGORY
          final filteredTrips = MockDataService.getTripsByCategory(
            _categoryNames[searchProvider.selectedCategory],
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  CATEGORY BAR (SYNCED WITH PROVIDER)
                SizedBox(height: 6.h),
                CategoryBar(
                  selectedCategory: searchProvider.selectedCategory,
                  onCategoryChanged: (index) {
                    searchProvider.setCategory(index);
                  },
                ),

                // Featured Section
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
                  child: Text(
                    'Featured',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                //FILTERED TRIP CARDS
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    final trip = filteredTrips[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: TripCard(trip: trip),
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
