
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/auth_Repository.dart';
import '../Repository/dashboard_repository.dart';
import '../Repository/loan_application_Repository.dart';
import '../Repository/repayment_repository.dart';
import '../Services/http_client.dart';
import '../Services/http_client_php.dart';

final appRepositoryProviders = [
  RepositoryProvider<AuthRepository>(
    create: (_) => AuthRepository(ApiClass(),ApiClassPhp()),
  ),
  RepositoryProvider<LoanApplicationRepository>(
    create: (_) => LoanApplicationRepository(ApiClass(),ApiClassPhp()),
  ),
  RepositoryProvider<DashBoardRepository>(
    create: (_) => DashBoardRepository(ApiClassPhp()),
  ),
  RepositoryProvider<RepaymentRepository>(
    create: (_) => RepaymentRepository(ApiClassPhp()),
  ),
];

