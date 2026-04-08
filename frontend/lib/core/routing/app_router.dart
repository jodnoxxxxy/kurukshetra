import 'package:go_router/go_router.dart';
import 'package:kurukshetra/features/consumer/models/consumer_product.dart';
import 'package:kurukshetra/features/splash/screens/splash_screen.dart';
import 'package:kurukshetra/features/navigation/screens/main_navigation_screen.dart';
import 'package:kurukshetra/features/auth/screens/login_screen.dart';
import 'package:kurukshetra/features/auth/screens/registration_screen.dart';
import 'package:kurukshetra/features/auth/screens/role_selection_screen.dart';
import 'package:kurukshetra/features/consumer_auth/screens/consumer_login_screen.dart';
import 'package:kurukshetra/features/consumer_auth/screens/consumer_registration_screen.dart';
import 'package:kurukshetra/features/dashboard/screens/dashboard_screen.dart';
import 'package:kurukshetra/features/consumer/marketplace/screens/marketplace_screen.dart';
import 'package:kurukshetra/features/consumer_dashboard/screens/consumer_navigation_screen.dart';
import 'package:kurukshetra/features/consumer/product_details/screens/product_details_screen.dart';
import 'package:kurukshetra/features/consumer/cart/screens/cart_screen.dart';
import 'package:kurukshetra/features/consumer/checkout/screens/checkout_screen.dart';
import 'package:kurukshetra/features/consumer/orders/screens/order_tracking_screen.dart';
import 'package:kurukshetra/features/consumer/farmer_profile/screens/farmer_profile_screen.dart';
import 'package:kurukshetra/features/farmer/listing/screens/add_product_screen.dart';
import 'package:kurukshetra/features/chat/screens/chat_screen.dart';
import 'package:kurukshetra/features/ai/pest/screens/pest_detection_screen.dart';
import 'package:kurukshetra/features/ai/pest/screens/image_upload_screen.dart';
import 'package:kurukshetra/features/ai/pest/screens/detection_result_screen.dart';
import 'package:kurukshetra/features/ai/pest/screens/pest_info_screen.dart';
import 'package:kurukshetra/features/pest_disease/screens/crop_selection_screen.dart' as pest_disease;
import 'package:kurukshetra/features/profile/screens/farmer_profile_drawer_screen.dart';
import 'package:kurukshetra/features/profile/screens/my_farm_screen.dart';
import 'package:kurukshetra/features/profile/screens/reports_screen.dart';
import 'package:kurukshetra/features/profile/screens/orders_sales_screen.dart';
import 'package:kurukshetra/features/profile/screens/farm_analytics_screen.dart';
import 'package:kurukshetra/features/profile/screens/notifications_screen.dart';
import 'package:kurukshetra/features/profile/screens/help_support_screen.dart';
import 'package:kurukshetra/features/profile/screens/about_screen.dart';
import 'package:kurukshetra/features/profile/screens/settings_screen.dart';
import 'package:kurukshetra/features/profile/screens/edit_profile_screen.dart';
import 'package:kurukshetra/features/pest_disease/screens/pest_list_screen.dart';
import 'package:kurukshetra/features/pest_disease/screens/pest_detail_screen.dart';
import 'package:kurukshetra/features/ai/soil/screens/soil_input_screen.dart';
import 'package:kurukshetra/features/ai/soil/screens/soil_analysis_screen.dart';
import 'package:kurukshetra/features/ai/soil/screens/soil_recommendation_screen.dart';
import 'package:kurukshetra/features/ai/crop/screens/crop_selection_screen.dart';
import 'package:kurukshetra/features/ai/crop/screens/advisory_timeline_screen.dart';
import 'package:kurukshetra/features/ai/crop/screens/manual_crop_check_screen.dart';
import 'package:kurukshetra/features/ai/crop/screens/inspection_results_screen.dart';

import 'package:kurukshetra/features/sop/screens/sop_crop_selection_screen.dart';
import 'package:kurukshetra/features/sop/screens/sop_steps_screen.dart';
import 'package:kurukshetra/features/sop/screens/sop_detail_screen.dart';
import 'package:kurukshetra/features/market_prices/screens/crop_selection_screen.dart' as market_prices;
import 'package:kurukshetra/features/market_prices/screens/market_price_screen.dart';
import 'package:kurukshetra/features/market_prices/screens/market_detail_screen.dart';
import 'package:kurukshetra/features/market_prices/screens/price_trend_screen.dart';
import 'package:kurukshetra/features/fertilizer_calculator/screens/fertilizer_input_screen.dart';
import 'package:kurukshetra/features/fertilizer_calculator/screens/fertilizer_result_screen.dart';
import 'package:kurukshetra/features/climate_technology/screens/climate_dashboard_screen.dart';
import 'package:kurukshetra/features/climate_technology/screens/climate_advisory_screen.dart' as old_climate;
import 'package:kurukshetra/features/climate_advisory/screens/climate_advisory_screen.dart';
import 'package:kurukshetra/features/climate_technology/screens/climate_detail_screen.dart';
import 'package:kurukshetra/features/dbt/screens/dbt_screen.dart';
import 'package:kurukshetra/features/warehouse/screens/warehouse_screen.dart';
import 'package:kurukshetra/features/messaging/screens/conversations_list_screen.dart';
import 'package:kurukshetra/features/messaging/screens/chat_thread_screen.dart';
import 'package:kurukshetra/features/home/screens/add_crop_screen.dart';
import 'package:kurukshetra/features/admin/screens/admin_login_screen.dart';
import 'package:kurukshetra/features/admin/screens/admin_dashboard_screen.dart';
import 'package:kurukshetra/features/profile/screens/land_records_screen.dart';
import 'package:kurukshetra/features/profile/screens/crop_history_screen.dart';
import 'package:kurukshetra/features/profile/screens/organic_certification_screen.dart';
import 'package:kurukshetra/features/profile/screens/payment_details_screen.dart';
import 'package:kurukshetra/features/crop_advisory/screens/crop_input_screen.dart';
import 'package:kurukshetra/features/crop_advisory/screens/crop_recommendation_screen.dart';
import 'package:kurukshetra/features/crop_advisory/screens/crop_timeline_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/consumer-login',
        builder: (context, state) => const ConsumerLoginScreen(),
      ),
      GoRoute(
        path: '/consumer-register',
        builder: (context, state) => const ConsumerRegistrationScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const FarmerDashboardScreen(),
      ),
      GoRoute(
        path: '/soil-analysis',
        builder: (context, state) => const SoilInputScreen(),
      ),
      GoRoute(
        path: '/soil-health/analysis',
        builder: (context, state) => const SoilAnalysisScreen(),
      ),
      GoRoute(
        path: '/soil-health/recommendations',
        builder: (context, state) => const SoilRecommendationScreen(),
      ),
      GoRoute(
        path: '/pest-detection',
        builder: (context, state) => const PestDetectionScreen(),
      ),
      GoRoute(
        path: '/pest-detection/upload',
        builder: (context, state) {
          final source = state.uri.queryParameters['source'] ?? 'camera';
          return ImageUploadScreen(source: source);
        },
      ),
      GoRoute(
        path: '/pest-detection/result',
        builder: (context, state) => const DetectionResultScreen(),
      ),
      GoRoute(
        path: '/pest-detection/info',
        builder: (context, state) => const PestInfoScreen(),
      ),
      GoRoute(
        path: '/pest-detection/library',
        builder: (context, state) => const PestLibraryScreen(),
      ),
      GoRoute(
        path: '/pest-disease',
        builder: (context, state) => const pest_disease.CropSelectionScreen(),
      ),
      GoRoute(
        path: '/pest-disease/list',
        builder: (context, state) => const PestListScreen(),
      ),
      GoRoute(
        path: '/pest-disease/detail',
        builder: (context, state) => const PestDetailScreen(),
      ),
      GoRoute(
        path: '/crop-recommendation',
        builder: (context, state) => const CropSelectionScreen(),
      ),
      GoRoute(
        path: '/advisory-timeline',
        builder: (context, state) => const AdvisoryTimelineScreen(),
      ),
      GoRoute(
        path: '/crops/manual-check',
        builder: (context, state) {
          final fieldId = state.uri.queryParameters['fieldId'];
          final cropId = state.uri.queryParameters['cropId'];
          return ManualCropCheckScreen(fieldId: fieldId, cropId: cropId);
        },
      ),
      GoRoute(
        path: '/crops/inspection-results/:fieldId',
        builder: (context, state) {
          final fieldId = state.pathParameters['fieldId']!;
          return InspectionResultsScreen(fieldId: fieldId);
        },
      ),
      GoRoute(
        path: '/consumer-dashboard',
        builder: (context, state) => const ConsumerNavigationScreen(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra as ConsumerProduct;
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: '/farmer-profile',
        builder: (context, state) {
          final product = state.extra as ConsumerProduct;
          return FarmerProfileScreen(seedProduct: product);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final totalAmount = state.extra as double?;
          return CheckoutScreen(totalAmount: totalAmount ?? 0.0);
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderTrackingScreen(),
      ),
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/sop',
        builder: (context, state) => const SopCropSelectionScreen(),
      ),
      GoRoute(
        path: '/sop/steps',
        builder: (context, state) => const SopStepsScreen(),
      ),
      GoRoute(
        path: '/sop/step-detail',
        builder: (context, state) => const SopDetailScreen(),
      ),
      GoRoute(
        path: '/fertilizer-calculator',
        builder: (context, state) => const FertilizerInputScreen(),
      ),
      GoRoute(
        path: '/fertilizer-result',
        builder: (context, state) => const FertilizerResultScreen(),
      ),
      GoRoute(
        path: '/climate-tech',
        builder: (context, state) => const ClimateDashboardScreen(),
      ),
      GoRoute(
        path: '/climate-tech/advisories',
        builder: (context, state) => const ClimateAdvisoryScreen(),
      ),
      GoRoute(
        path: '/climate-tech/advisory-detail',
        builder: (context, state) => const ClimateDetailScreen(),
      ),
      GoRoute(
        path: '/dbt',
        builder: (context, state) => const DbtScreen(),
      ),
      GoRoute(
        path: '/warehouse',
        builder: (context, state) => const WarehouseScreen(),
      ),
      GoRoute(
        path: '/market-prices',
        builder: (context, state) => const market_prices.MarketCropSelectionScreen(),
      ),
      GoRoute(
        path: '/market-prices/list',
        builder: (context, state) => const MarketPriceScreen(),
      ),
      GoRoute(
        path: '/market-prices/detail',
        builder: (context, state) => const MarketDetailScreen(),
      ),
      GoRoute(
        path: '/market-prices/trends',
        builder: (context, state) => const PriceTrendScreen(),
      ),

      GoRoute(
        path: '/messaging',
        builder: (context, state) => const ConversationsListScreen(),
      ),
      GoRoute(
        path: '/messaging/thread',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ChatThreadScreen(
            conversationId: extras['conversationId'] as String,
            participantName: extras['participantName'] as String,
            participantRole: extras['participantRole'] as String,
            participantId: extras['participantId'] as String,
          );
        },
      ),
      // --- Crop Management ---
      GoRoute(
        path: '/add-crop',
        builder: (context, state) => const AddCropScreen(),
      ),
      // --- Drawer Routes ---
      GoRoute(
        path: '/profile/farmer',
        builder: (context, state) => const FarmerProfileDrawerScreen(),
      ),
      GoRoute(
        path: '/profile/farm',
        builder: (context, state) => const MyFarmScreen(),
      ),
      GoRoute(
        path: '/profile/reports',
        builder: (context, state) => const FarmReportsScreen(),
      ),
      GoRoute(
        path: '/profile/orders',
        builder: (context, state) => const OrdersSalesScreen(),
      ),
      GoRoute(
        path: '/profile/analytics',
        builder: (context, state) => const FarmAnalyticsScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile/help',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/profile/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/land-records',
        builder: (context, state) => const LandRecordsScreen(),
      ),
      GoRoute(
        path: '/profile/crop-history',
        builder: (context, state) => const CropHistoryScreen(),
      ),
      GoRoute(
        path: '/profile/organic',
        builder: (context, state) => const OrganicCertificationScreen(),
      ),
      GoRoute(
        path: '/profile/payment',
        builder: (context, state) => const PaymentDetailsScreen(),
      ),
      // --- Admin Routes ---
      GoRoute(
        path: '/admin-login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      // --- New Crop Advisory System ---
      GoRoute(
        path: '/crop-advisory-new',
        builder: (context, state) => const CropInputScreen(),
      ),
      GoRoute(
        path: '/crop-advisory-new/recommendations',
        builder: (context, state) => const CropRecommendationScreen(),
      ),
      GoRoute(
        path: '/crop-advisory-new/timeline',
        builder: (context, state) => const CropTimelineScreen(),
      ),
    ],
  );
}
