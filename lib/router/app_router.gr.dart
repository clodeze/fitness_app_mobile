// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddFoodPage]
class AddFoodRoute extends PageRouteInfo<AddFoodRouteArgs> {
  AddFoodRoute({
    Key? key,
    required int day,
    String initialSlot = 'Ужин',
    List<PageRouteInfo>? children,
  }) : super(
         AddFoodRoute.name,
         args: AddFoodRouteArgs(key: key, day: day, initialSlot: initialSlot),
         initialChildren: children,
       );

  static const String name = 'AddFoodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddFoodRouteArgs>();
      return AddFoodPage(
        key: args.key,
        day: args.day,
        initialSlot: args.initialSlot,
      );
    },
  );
}

class AddFoodRouteArgs {
  const AddFoodRouteArgs({
    this.key,
    required this.day,
    this.initialSlot = 'Ужин',
  });

  final Key? key;

  final int day;

  final String initialSlot;

  @override
  String toString() {
    return 'AddFoodRouteArgs{key: $key, day: $day, initialSlot: $initialSlot}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddFoodRouteArgs) return false;
    return key == other.key &&
        day == other.day &&
        initialSlot == other.initialSlot;
  }

  @override
  int get hashCode => key.hashCode ^ day.hashCode ^ initialSlot.hashCode;
}

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    Key? key,
    AuthMode initialMode = AuthMode.registration,
    List<PageRouteInfo>? children,
  }) : super(
         AuthRoute.name,
         args: AuthRouteArgs(key: key, initialMode: initialMode),
         initialChildren: children,
       );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthRouteArgs>(
        orElse: () => const AuthRouteArgs(),
      );
      return AuthPage(key: args.key, initialMode: args.initialMode);
    },
  );
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key, this.initialMode = AuthMode.registration});

  final Key? key;

  final AuthMode initialMode;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, initialMode: $initialMode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthRouteArgs) return false;
    return key == other.key && initialMode == other.initialMode;
  }

  @override
  int get hashCode => key.hashCode ^ initialMode.hashCode;
}

/// generated route for
/// [BodyFatCalculatorPage]
class BodyFatCalculatorRoute extends PageRouteInfo<void> {
  const BodyFatCalculatorRoute({List<PageRouteInfo>? children})
    : super(BodyFatCalculatorRoute.name, initialChildren: children);

  static const String name = 'BodyFatCalculatorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BodyFatCalculatorPage();
    },
  );
}

/// generated route for
/// [CustomFoodPage]
class CustomFoodRoute extends PageRouteInfo<void> {
  const CustomFoodRoute({List<PageRouteInfo>? children})
    : super(CustomFoodRoute.name, initialChildren: children);

  static const String name = 'CustomFoodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomFoodPage();
    },
  );
}

/// generated route for
/// [EmailRegistrationPage]
class EmailRegistrationRoute extends PageRouteInfo<EmailRegistrationRouteArgs> {
  EmailRegistrationRoute({
    Key? key,
    String initialEmail = '',
    List<PageRouteInfo>? children,
  }) : super(
         EmailRegistrationRoute.name,
         args: EmailRegistrationRouteArgs(key: key, initialEmail: initialEmail),
         initialChildren: children,
       );

  static const String name = 'EmailRegistrationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailRegistrationRouteArgs>(
        orElse: () => const EmailRegistrationRouteArgs(),
      );
      return EmailRegistrationPage(
        key: args.key,
        initialEmail: args.initialEmail,
      );
    },
  );
}

class EmailRegistrationRouteArgs {
  const EmailRegistrationRouteArgs({this.key, this.initialEmail = ''});

  final Key? key;

  final String initialEmail;

  @override
  String toString() {
    return 'EmailRegistrationRouteArgs{key: $key, initialEmail: $initialEmail}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EmailRegistrationRouteArgs) return false;
    return key == other.key && initialEmail == other.initialEmail;
  }

  @override
  int get hashCode => key.hashCode ^ initialEmail.hashCode;
}

/// generated route for
/// [ExerciseDetailsPage]
class ExerciseDetailsRoute extends PageRouteInfo<ExerciseDetailsRouteArgs> {
  ExerciseDetailsRoute({
    Key? key,
    required Exercise exercise,
    List<PageRouteInfo>? children,
  }) : super(
         ExerciseDetailsRoute.name,
         args: ExerciseDetailsRouteArgs(key: key, exercise: exercise),
         initialChildren: children,
       );

  static const String name = 'ExerciseDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExerciseDetailsRouteArgs>();
      return ExerciseDetailsPage(key: args.key, exercise: args.exercise);
    },
  );
}

class ExerciseDetailsRouteArgs {
  const ExerciseDetailsRouteArgs({this.key, required this.exercise});

  final Key? key;

  final Exercise exercise;

  @override
  String toString() {
    return 'ExerciseDetailsRouteArgs{key: $key, exercise: $exercise}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ExerciseDetailsRouteArgs) return false;
    return key == other.key && exercise == other.exercise;
  }

  @override
  int get hashCode => key.hashCode ^ exercise.hashCode;
}

/// generated route for
/// [ExercisePickerPage]
class ExercisePickerRoute extends PageRouteInfo<void> {
  const ExercisePickerRoute({List<PageRouteInfo>? children})
    : super(ExercisePickerRoute.name, initialChildren: children);

  static const String name = 'ExercisePickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExercisePickerPage();
    },
  );
}

/// generated route for
/// [FormaUiKitPage]
class FormaUiKitRoute extends PageRouteInfo<void> {
  const FormaUiKitRoute({List<PageRouteInfo>? children})
    : super(FormaUiKitRoute.name, initialChildren: children);

  static const String name = 'FormaUiKitRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FormaUiKitPage();
    },
  );
}

/// generated route for
/// [GoalPage]
class GoalRoute extends PageRouteInfo<GoalRouteArgs> {
  GoalRoute({
    Key? key,
    required BodyParameters parameters,
    List<PageRouteInfo>? children,
  }) : super(
         GoalRoute.name,
         args: GoalRouteArgs(key: key, parameters: parameters),
         initialChildren: children,
       );

  static const String name = 'GoalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GoalRouteArgs>();
      return GoalPage(key: args.key, parameters: args.parameters);
    },
  );
}

class GoalRouteArgs {
  const GoalRouteArgs({this.key, required this.parameters});

  final Key? key;

  final BodyParameters parameters;

  @override
  String toString() {
    return 'GoalRouteArgs{key: $key, parameters: $parameters}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GoalRouteArgs) return false;
    return key == other.key && parameters == other.parameters;
  }

  @override
  int get hashCode => key.hashCode ^ parameters.hashCode;
}

/// generated route for
/// [GymPage]
class GymRoute extends PageRouteInfo<void> {
  const GymRoute({List<PageRouteInfo>? children})
    : super(GymRoute.name, initialChildren: children);

  static const String name = 'GymRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GymPage();
    },
  );
}

/// generated route for
/// [HealthQuestionnairePage]
class HealthQuestionnaireRoute extends PageRouteInfo<void> {
  const HealthQuestionnaireRoute({List<PageRouteInfo>? children})
    : super(HealthQuestionnaireRoute.name, initialChildren: children);

  static const String name = 'HealthQuestionnaireRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HealthQuestionnairePage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [MainShellPage]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellPage();
    },
  );
}

/// generated route for
/// [NutritionPage]
class NutritionRoute extends PageRouteInfo<void> {
  const NutritionRoute({List<PageRouteInfo>? children})
    : super(NutritionRoute.name, initialChildren: children);

  static const String name = 'NutritionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NutritionPage();
    },
  );
}

/// generated route for
/// [ParametersPage]
class ParametersRoute extends PageRouteInfo<void> {
  const ParametersRoute({List<PageRouteInfo>? children})
    : super(ParametersRoute.name, initialChildren: children);

  static const String name = 'ParametersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ParametersPage();
    },
  );
}

/// generated route for
/// [PasswordResetPage]
class PasswordResetRoute extends PageRouteInfo<void> {
  const PasswordResetRoute({List<PageRouteInfo>? children})
    : super(PasswordResetRoute.name, initialChildren: children);

  static const String name = 'PasswordResetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PasswordResetPage();
    },
  );
}

/// generated route for
/// [PersonalDetailsPage]
class PersonalDetailsRoute extends PageRouteInfo<void> {
  const PersonalDetailsRoute({List<PageRouteInfo>? children})
    : super(PersonalDetailsRoute.name, initialChildren: children);

  static const String name = 'PersonalDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PersonalDetailsPage();
    },
  );
}

/// generated route for
/// [PlanReadyPage]
class PlanReadyRoute extends PageRouteInfo<void> {
  const PlanReadyRoute({List<PageRouteInfo>? children})
    : super(PlanReadyRoute.name, initialChildren: children);

  static const String name = 'PlanReadyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PlanReadyPage();
    },
  );
}

/// generated route for
/// [ProfileDetailPage]
class ProfileDetailRoute extends PageRouteInfo<ProfileDetailRouteArgs> {
  ProfileDetailRoute({
    Key? key,
    required ProfileSection section,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileDetailRoute.name,
         args: ProfileDetailRouteArgs(key: key, section: section),
         initialChildren: children,
       );

  static const String name = 'ProfileDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileDetailRouteArgs>();
      return ProfileDetailPage(key: args.key, section: args.section);
    },
  );
}

class ProfileDetailRouteArgs {
  const ProfileDetailRouteArgs({this.key, required this.section});

  final Key? key;

  final ProfileSection section;

  @override
  String toString() {
    return 'ProfileDetailRouteArgs{key: $key, section: $section}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileDetailRouteArgs) return false;
    return key == other.key && section == other.section;
  }

  @override
  int get hashCode => key.hashCode ^ section.hashCode;
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [ScannerCameraPage]
class ScannerCameraRoute extends PageRouteInfo<ScannerCameraRouteArgs> {
  ScannerCameraRoute({
    Key? key,
    required int day,
    List<PageRouteInfo>? children,
  }) : super(
         ScannerCameraRoute.name,
         args: ScannerCameraRouteArgs(key: key, day: day),
         initialChildren: children,
       );

  static const String name = 'ScannerCameraRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScannerCameraRouteArgs>();
      return ScannerCameraPage(key: args.key, day: args.day);
    },
  );
}

class ScannerCameraRouteArgs {
  const ScannerCameraRouteArgs({this.key, required this.day});

  final Key? key;

  final int day;

  @override
  String toString() {
    return 'ScannerCameraRouteArgs{key: $key, day: $day}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ScannerCameraRouteArgs) return false;
    return key == other.key && day == other.day;
  }

  @override
  int get hashCode => key.hashCode ^ day.hashCode;
}

/// generated route for
/// [ScannerFallbackPage]
class ScannerFallbackRoute extends PageRouteInfo<ScannerFallbackRouteArgs> {
  ScannerFallbackRoute({
    Key? key,
    required ScannerFallbackType type,
    required int day,
    List<PageRouteInfo>? children,
  }) : super(
         ScannerFallbackRoute.name,
         args: ScannerFallbackRouteArgs(key: key, type: type, day: day),
         initialChildren: children,
       );

  static const String name = 'ScannerFallbackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScannerFallbackRouteArgs>();
      return ScannerFallbackPage(key: args.key, type: args.type, day: args.day);
    },
  );
}

class ScannerFallbackRouteArgs {
  const ScannerFallbackRouteArgs({
    this.key,
    required this.type,
    required this.day,
  });

  final Key? key;

  final ScannerFallbackType type;

  final int day;

  @override
  String toString() {
    return 'ScannerFallbackRouteArgs{key: $key, type: $type, day: $day}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ScannerFallbackRouteArgs) return false;
    return key == other.key && type == other.type && day == other.day;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode ^ day.hashCode;
}

/// generated route for
/// [ScannerPage]
class ScannerRoute extends PageRouteInfo<ScannerRouteArgs> {
  ScannerRoute({Key? key, required int day, List<PageRouteInfo>? children})
    : super(
        ScannerRoute.name,
        args: ScannerRouteArgs(key: key, day: day),
        initialChildren: children,
      );

  static const String name = 'ScannerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScannerRouteArgs>();
      return ScannerPage(key: args.key, day: args.day);
    },
  );
}

class ScannerRouteArgs {
  const ScannerRouteArgs({this.key, required this.day});

  final Key? key;

  final int day;

  @override
  String toString() {
    return 'ScannerRouteArgs{key: $key, day: $day}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ScannerRouteArgs) return false;
    return key == other.key && day == other.day;
  }

  @override
  int get hashCode => key.hashCode ^ day.hashCode;
}

/// generated route for
/// [StartPage]
class StartRoute extends PageRouteInfo<void> {
  const StartRoute({List<PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StartPage();
    },
  );
}

/// generated route for
/// [WorkoutGeneratorPage]
class WorkoutGeneratorRoute extends PageRouteInfo<void> {
  const WorkoutGeneratorRoute({List<PageRouteInfo>? children})
    : super(WorkoutGeneratorRoute.name, initialChildren: children);

  static const String name = 'WorkoutGeneratorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkoutGeneratorPage();
    },
  );
}

/// generated route for
/// [WorkoutPage]
class WorkoutRoute extends PageRouteInfo<void> {
  const WorkoutRoute({List<PageRouteInfo>? children})
    : super(WorkoutRoute.name, initialChildren: children);

  static const String name = 'WorkoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkoutPage();
    },
  );
}

/// generated route for
/// [WorkoutSessionPage]
class WorkoutSessionRoute extends PageRouteInfo<WorkoutSessionRouteArgs> {
  WorkoutSessionRoute({
    Key? key,
    required int index,
    List<PageRouteInfo>? children,
  }) : super(
         WorkoutSessionRoute.name,
         args: WorkoutSessionRouteArgs(key: key, index: index),
         initialChildren: children,
       );

  static const String name = 'WorkoutSessionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WorkoutSessionRouteArgs>();
      return WorkoutSessionPage(key: args.key, index: args.index);
    },
  );
}

class WorkoutSessionRouteArgs {
  const WorkoutSessionRouteArgs({this.key, required this.index});

  final Key? key;

  final int index;

  @override
  String toString() {
    return 'WorkoutSessionRouteArgs{key: $key, index: $index}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkoutSessionRouteArgs) return false;
    return key == other.key && index == other.index;
  }

  @override
  int get hashCode => key.hashCode ^ index.hashCode;
}

/// generated route for
/// [WorkoutSummaryPage]
class WorkoutSummaryRoute extends PageRouteInfo<void> {
  const WorkoutSummaryRoute({List<PageRouteInfo>? children})
    : super(WorkoutSummaryRoute.name, initialChildren: children);

  static const String name = 'WorkoutSummaryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkoutSummaryPage();
    },
  );
}
