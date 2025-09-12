
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan112_app/Repository/dashboard_repository.dart';
import 'package:loan112_app/Repository/loan_application_Repository.dart';
import 'package:loan112_app/Repository/repayment_repository.dart';
import 'package:loan112_app/Services/http_client_php.dart';
import '../Repository/auth_Repository.dart';
import '../Services/http_client.dart';

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

