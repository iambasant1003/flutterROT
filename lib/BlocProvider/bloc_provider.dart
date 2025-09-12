import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan112_app/Cubit/NetworkConnectivityCheck/ConnectivityCubit.dart';
import 'package:loan112_app/Cubit/dashboard_cubit/DashboardCubit.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/AddMoreReferenceCubit.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/JourneyUpdateCubit.dart';
import 'package:loan112_app/Cubit/loan_application_cubit/LoanApplicationCubit.dart';
import 'package:loan112_app/Cubit/repayment_cubit/RepaymentCubit.dart';
import '../Cubit/Loan112TimerCubit.dart';
import '../Cubit/ShowBanStatementAnalyzerStatusCubit.dart';
import '../Cubit/UploadBankStatementStatusCubit.dart';
import '../Cubit/auth_cubit/AuthCubit.dart';
import '../di/di_locator.dart';



final List<BlocProvider> appBlocProviders = [
  BlocProvider<AuthCubit>(
    create: (_) => locator<AuthCubit>(),
  ),
  BlocProvider<LoanApplicationCubit>(
    create: (_) => locator<LoanApplicationCubit>(),
  ),
  BlocProvider<DashboardCubit>(
    create: (_) => locator<DashboardCubit>(),
  ),
  BlocProvider<JourneyUpdateCubit>(
    create: (_) => locator<JourneyUpdateCubit>(),
  ),
  BlocProvider<AddMoreReferenceCubit>(
    create: (_) => locator<AddMoreReferenceCubit>(),
  ),
  BlocProvider<ConnectivityCubit>(
    create: (_) => locator<ConnectivityCubit>(),
  ),
  BlocProvider<RePaymentCubit>(
    create: (_) => locator<RePaymentCubit>(),
  ),
  BlocProvider<ShowBankStatementAnalyzerStatusCubit>(
    create: (_) => locator<ShowBankStatementAnalyzerStatusCubit>(),
  ),
  BlocProvider<Loan112TimerCubit>(
    create: (_) => locator<Loan112TimerCubit>(),
  ),
  BlocProvider<UploadBankStatementStatusCubit>(
    create: (_) => locator<UploadBankStatementStatusCubit>(),
  ),
];
