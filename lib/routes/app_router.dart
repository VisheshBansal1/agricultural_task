import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/splash_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/otp_screen.dart';

import '../features/home/home_screen.dart';
import '../features/search/search_results_screen.dart';
import '../features/resource/resource_details_screen.dart';
import '../features/resource/date_selection_screen.dart';
import '../features/booking/booking_summary_screen.dart';
import '../features/payment/payment_screen.dart';
import '../features/payment/booking_success_screen.dart';
import '../features/booking/my_bookings_screen.dart';
import '../features/booking/booking_details_screen.dart';
import '../features/profile/notifications_screen.dart';
import '../features/profile/favorites_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/edit_profile_screen.dart';

import '../features/owner/owner_dashboard_screen.dart';
import '../features/owner/my_resources_screen.dart';
import '../features/owner/add_resource_screen.dart';
import '../features/owner/edit_resource_screen.dart';
import '../features/owner/availability_calendar_screen.dart';
import '../features/owner/rental_requests_screen.dart';
import '../features/owner/request_details_screen.dart';

import '../features/admin/admin_login_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/admin/user_management_screen.dart';
import '../features/admin/owner_management_screen.dart';
import '../features/admin/resource_management_screen.dart';
import '../features/admin/category_management_screen.dart';
import '../features/admin/booking_management_screen.dart';
import '../features/admin/payments_screen.dart';
import '../features/admin/reports_screen.dart';
import '../features/admin/notifications_content_screen.dart';
import '../features/admin/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/otp', builder: (context, state) => OtpScreen(role: state.extra as String? ?? 'user')),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/search', builder: (context, state) => SearchResultsScreen(categoryId: state.extra as String?)),
    GoRoute(
      path: '/resource/:id',
      builder: (context, state) => ResourceDetailsScreen(resourceId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/select-dates', builder: (context, state) => const DateSelectionScreen()),
    GoRoute(path: '/booking-summary', builder: (context, state) => const BookingSummaryScreen()),
    GoRoute(path: '/payment', builder: (context, state) => PaymentScreen(bookingId: state.extra as String)),
    GoRoute(path: '/booking-success', builder: (context, state) => BookingSuccessScreen(bookingId: state.extra as String)),
    GoRoute(path: '/my-bookings', builder: (context, state) => const MyBookingsScreen()),
    GoRoute(
      path: '/booking/:id',
      builder: (context, state) => BookingDetailsScreen(bookingId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfileScreen()),

    GoRoute(path: '/owner/dashboard', builder: (context, state) => const OwnerDashboardScreen()),
    GoRoute(path: '/owner/resources', builder: (context, state) => const MyResourcesScreen()),
    GoRoute(path: '/owner/add-resource', builder: (context, state) => const AddResourceScreen()),
    GoRoute(
      path: '/owner/edit-resource/:id',
      builder: (context, state) => EditResourceScreen(resourceId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/owner/availability/:id',
      builder: (context, state) => AvailabilityCalendarScreen(resourceId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/owner/requests', builder: (context, state) => const RentalRequestsScreen()),
    GoRoute(
      path: '/owner/requests/:id',
      builder: (context, state) => RequestDetailsScreen(bookingId: state.pathParameters['id']!),
    ),

    GoRoute(path: '/admin/login', builder: (context, state) => const AdminLoginScreen()),
    GoRoute(path: '/admin/dashboard', builder: (context, state) => const AdminDashboardScreen()),
    GoRoute(path: '/admin/users', builder: (context, state) => const UserManagementScreen()),
    GoRoute(path: '/admin/owners', builder: (context, state) => const OwnerManagementScreen()),
    GoRoute(path: '/admin/resources', builder: (context, state) => const ResourceManagementScreen()),
    GoRoute(path: '/admin/categories', builder: (context, state) => const CategoryManagementScreen()),
    GoRoute(path: '/admin/bookings', builder: (context, state) => const BookingManagementScreen()),
    GoRoute(path: '/admin/payments', builder: (context, state) => const AdminPaymentsScreen()),
    GoRoute(path: '/admin/reports', builder: (context, state) => const ReportsScreen()),
    GoRoute(path: '/admin/content', builder: (context, state) => const NotificationsContentScreen()),
    GoRoute(path: '/admin/settings', builder: (context, state) => const AdminSettingsScreen()),
  ],
);
