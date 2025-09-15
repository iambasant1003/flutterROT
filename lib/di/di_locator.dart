import 'package:get_it/get_it.dart';
import '../Cubit/Loan112TimerCubit.dart';
import '../Cubit/ShowBanStatementAnalyzerStatusCubit.dart';
import '../Cubit/UploadBankStatementStatusCubit.dart';
import '../Cubit/auth_cubit/AuthCubit.dart';
import '../Cubit/dashboard_cubit/DashboardCubit.dart';
import '../Cubit/loan_application_cubit/AddMoreReferenceCubit.dart';
import '../Cubit/loan_application_cubit/JourneyUpdateCubit.dart';
import '../Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import '../Cubit/repayment_cubit/RepaymentCubit.dart';
import '../Repository/auth_Repository.dart';
import '../Repository/dashboard_repository.dart';
import '../Repository/loan_application_Repository.dart';
import '../Repository/repayment_repository.dart';
import '../Services/http_client.dart';
import '../Services/http_client_php.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiClass>(() => ApiClass());
  locator.registerLazySingleton<ApiClassPhp>(()=>ApiClassPhp());
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(locator<ApiClass>(),locator<ApiClassPhp>()));
  locator.registerFactory(() => AuthCubit(locator<AuthRepository>()));
  locator.registerLazySingleton<LoanApplicationRepository>(()=> LoanApplicationRepository(locator<ApiClass>(),locator<ApiClassPhp>()));
  locator.registerFactory(()=> LoanApplicationCubit(locator<LoanApplicationRepository>()));

  locator.registerLazySingleton<DashBoardRepository>(()=> DashBoardRepository(locator<ApiClassPhp>()));
  locator.registerFactory(()=> DashboardCubit(locator<DashBoardRepository>()));
  locator.registerFactory(()=> JourneyUpdateCubit());
  locator.registerFactory(()=> AddMoreReferenceCubit());


  locator.registerLazySingleton<RepaymentRepository>(()=> RepaymentRepository(locator<ApiClassPhp>()));
  locator.registerFactory(()=> RePaymentCubit(locator<RepaymentRepository>()));
  locator.registerFactory(()=> ShowBankStatementAnalyzerStatusCubit());
  locator.registerFactory(()=> Loan112TimerCubit());
  locator.registerFactory(()=> UploadBankStatementStatusCubit());

}

