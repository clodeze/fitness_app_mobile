import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Key;

import '../features/auth/auth_components.dart' show AuthMode;
import '../features/auth/auth_page.dart';
import '../features/auth/email_registration_page.dart';
import '../features/auth/password_reset_page.dart';
import '../features/dashboard/main_shell_page.dart';
import '../features/dashboard/home_page.dart';
import '../features/dashboard/nutrition_page.dart';
import '../features/dashboard/scanner_result_page.dart';
import '../features/dashboard/scanner_camera_page.dart';
import '../features/dashboard/scanner_fallback_page.dart';
import '../features/dashboard/add_food_page.dart';
import '../features/dashboard/custom_food_page.dart';
import '../features/dashboard/exercise_library_page.dart';
import '../features/dashboard/exercise_catalog.dart' show Exercise;
import '../features/dashboard/workout_page.dart';
import '../features/dashboard/workout_generator_page.dart';
import '../features/dashboard/workout_session_page.dart';
import '../features/dashboard/profile_page.dart';
import '../features/dashboard/profile_detail_page.dart';
import '../features/questionnaire/goal_page.dart';
import '../features/questionnaire/parameters_page.dart';
import '../features/questionnaire/personal_details_page.dart';
import '../features/questionnaire/health_questionnaire_page.dart';
import '../features/questionnaire/plan_ready_page.dart';
import '../features/questionnaire/body_fat_calculator_page.dart';
import '../features/questionnaire/questionnaire_data.dart' show BodyParameters;
import '../features/start/start_page.dart';
import '../ui_kit/forma_ui_kit_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: StartRoute.page, path: '/', initial: true),
    AutoRoute(page: AuthRoute.page, path: '/auth'),
    AutoRoute(page: PasswordResetRoute.page, path: '/auth/reset'),
    AutoRoute(page: EmailRegistrationRoute.page, path: '/registration/email'),
    AutoRoute(page: ParametersRoute.page, path: '/questionnaire/parameters'),
    AutoRoute(page: PersonalDetailsRoute.page, path: '/questionnaire/personal'),
    AutoRoute(
      page: HealthQuestionnaireRoute.page,
      path: '/questionnaire/health',
    ),
    AutoRoute(page: PlanReadyRoute.page, path: '/questionnaire/plan'),
    AutoRoute(
      page: BodyFatCalculatorRoute.page,
      path: '/questionnaire/body-fat',
    ),
    AutoRoute(page: GoalRoute.page, path: '/questionnaire/goal'),
    AutoRoute(
      page: MainShellRoute.page,
      path: '/home',
      children: [
        AutoRoute(page: HomeRoute.page, path: '', initial: true),
        AutoRoute(page: NutritionRoute.page, path: 'nutrition'),
        AutoRoute(page: GymRoute.page, path: 'gym'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    AutoRoute(page: ScannerRoute.page, path: '/scanner'),
    AutoRoute(page: ScannerCameraRoute.page, path: '/scanner/camera'),
    AutoRoute(page: ScannerFallbackRoute.page, path: '/scanner/fallback'),
    AutoRoute(page: AddFoodRoute.page, path: '/food/add'),
    AutoRoute(page: CustomFoodRoute.page, path: '/food/custom'),
    AutoRoute(page: ProfileDetailRoute.page, path: '/profile/detail'),
    AutoRoute(page: WorkoutRoute.page, path: '/workout'),
    AutoRoute(page: WorkoutGeneratorRoute.page, path: '/workout/generator'),
    AutoRoute(page: ExerciseDetailsRoute.page, path: '/workout/exercise'),
    AutoRoute(page: WorkoutSessionRoute.page, path: '/workout/session'),
    AutoRoute(page: WorkoutSummaryRoute.page, path: '/workout/summary'),
    AutoRoute(page: ExercisePickerRoute.page, path: '/exercises/pick'),
    AutoRoute(page: FormaUiKitRoute.page, path: '/ui-kit'),
  ];
}
