import 'package:go_router/go_router.dart';
import 'package:loan112_app/Model/CheckBankStatementStatusModel.dart';
import 'package:loan112_app/Model/CreateLeadModel.dart';
import 'package:loan112_app/Model/GenerateLoanOfferModel.dart';
import 'package:loan112_app/Model/UpdateBankAccountModel.dart';
import 'package:loan112_app/Model/UploadSelfieModel.dart';
import 'package:loan112_app/Screens/Repayment/payment_screen.dart';
import 'package:loan112_app/Screens/TermsAndCondition/terms_and_condition.dart';
import 'package:loan112_app/Screens/auth/login_page.dart';
import 'package:loan112_app/Screens/auth/verify_otp.dart';
import 'package:loan112_app/Screens/dashboard/dashboard_page.dart';
import 'package:loan112_app/Screens/dashboard/dashboard_status.dart';
import 'package:loan112_app/Screens/dashboard/dashboard_verify_otp.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/addReferance/add_reference.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/bank_statement.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/newBREJourney/bank_statement_analyzer.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/onlinebankStatement/online_bank_statement.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankStatement/onlinebankStatement/online_banking_message.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/bankingDetails/banking_details.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/checkEligibility/check_eligibility.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/checkEligibility/eligibility_status.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/eKyc/customer_kyc_webview.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/loanOffer/loan_offer.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/loanOffer/loan_offer_failed.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/selfieVerification/selfie_uploaded.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/selfieVerification/selfie_verification.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loanApplicationOptions/utilityBills/utility_bills.dart';
import 'package:loan112_app/Screens/loanApplicationPage/loan_application_page.dart';
import '../Screens/Repayment/paymentstatusPage/payment_status_page.dart';
import '../Screens/Repayment/repayment_page.dart';
import '../Screens/auth/permission_page.dart';
import '../Screens/auth/splash.dart';
import '../Screens/loanApplicationPage/loanApplicationOptions/bankStatement/offlineBankStatement/offline_bank_statement.dart';
import '../Screens/loanApplicationPage/loanApplicationOptions/checkEligibility/eligibility_status_lead.dart';
import '../Screens/loanApplicationPage/loanApplicationOptions/eKyc/aadhar_ekyc.dart';
import '../Screens/loanApplicationPage/loanApplicationOptions/eKyc/ekyc_message.dart';
import '../Screens/loanApplicationPage/loan_application_submit.dart';
import '../Screens/sessionTimeOut/session_timeout.dart';
import '../Screens/supportUi/customer_support.dart';
import '../main.dart';
import 'app_router_name.dart';




final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(path: AppRouterName.login, builder: (context, state) => LogInPage()),
    GoRoute(path: AppRouterName.permissionPage, builder: (context, state) => PermissionPage()),
    GoRoute(path: AppRouterName.verifyOtp,builder:(context,state){
      final phone = state.extra as String;
      return VerifyOTP(mobileNumber: phone);
    }),
    GoRoute(path: AppRouterName.dashboardPage,builder: (context,state)=> DashBoardPage()),
    GoRoute(path: AppRouterName.loanApplicationPage,builder: (context,state)=> LoanApplicationPage()),
    GoRoute(path: AppRouterName.checkEligibilityPage,builder: (context,state){
      bool existingUser = state.extra as bool;
      return CheckEligibility(isExistingCustomer: existingUser);
    }),
    GoRoute(path: AppRouterName.eligibilityFailed,builder: (context,state){
      final model = state.extra as CreateLeadModel;
      return EligibilityStatusLead(createLeadModel: model);
    }),
    GoRoute(path: AppRouterName.eligibilityStatus,builder: (context,state){
      final model = state.extra as UploadSelfieModel;
      return EligibilityStatus(createLeadModel: model);
    }),
    GoRoute(path: AppRouterName.loanOfferFailed,builder: (context,state){
      final model = state.extra as GenerateLoanOfferModel;
      return LoanOfferFailed(generateLoanOfferModel: model);
    }),
    GoRoute(path: AppRouterName.bankStatement,builder: (context,state)=> BankStatementScreen()),
    GoRoute(path: AppRouterName.onlineBankStatement,builder: (context,state)=> OnlineBankingOption()),
    GoRoute(path: AppRouterName.onlineBankStatementMessage,builder: (context,state){
      CheckBankStatementStatusModel checkBankStatusModel = state.extra as CheckBankStatementStatusModel;
      return OnlineBankingMessageScreen(checkBankStatementStatusModel: checkBankStatusModel);
    }),
    GoRoute(path: AppRouterName.aaDarKYCScreen,builder: (context,state)=> AadharKycScreen()),
    GoRoute(path: AppRouterName.eKycMessageScreen,builder: (context,state) => EkycMessageScreen()),
    GoRoute(path: AppRouterName.offlineBankStatement,builder: (context,state) => FetchOfflineBankStatement()),
    GoRoute(path: AppRouterName.selfieScreenPath,builder: (context,state) => SelfieCameraPage()),
    GoRoute(path: AppRouterName.selfieUploadedPage,builder: (context,state){
      final pathOfImage = state.extra as String;
      return SelfieUploadedPage(imagePath: pathOfImage);
    }),
    GoRoute(path: AppRouterName.loanOfferPage,builder: (context,state){
      int isEnhance = state.extra as int;
      return LoanOfferScreen(enhance: isEnhance);
    }),
    GoRoute(path: AppRouterName.addReference,builder: (context,state) => AddReferenceScreen()),
    GoRoute(path: AppRouterName.utilityBillScreen,builder: (context,state) => UtilityBillScreen()),
    GoRoute(path: AppRouterName.bankDetailsScreen,builder: (context,state) => BankingDetailScreen()),
    GoRoute(path: AppRouterName.dashBoardStatus,builder: (context,state) => DashboardStatusScreen()),
    GoRoute(path: AppRouterName.customerKYCWebview,builder:(context,state){
      final webUrl = state.extra as String;
      return CustomerKycWebview(kycWebUrl: webUrl);
    }),
    GoRoute(path: AppRouterName.repaymentPage,builder: (context,state) => RepaymentPage()),
    GoRoute(path: AppRouterName.dashBoardOTP,builder: (context,state) => DashboardVerifyOTP()),
    GoRoute(path: AppRouterName.loanApplicationSubmit,builder: (context,state){
      BankAccountPost bankAccountPost = state.extra as BankAccountPost;
      return LoanApplicationSubmit(bankAccountPost: bankAccountPost);
    }),
    GoRoute(path: AppRouterName.paymentOptionScreen,builder: (context,state){
      var  dataPassed = state.extra as Map<String,dynamic>;
      var loanDetails = dataPassed['loanData'];
      var amount = dataPassed['amount'];
      return PaymentOptionScreen(
          getLoanHistoryModel: loanDetails,
          partAmount: amount
      );
    }),
    GoRoute(path: AppRouterName.customerSupport,builder: (context,state){
      return CustomerSupportUiScreen();
    }),
    GoRoute(path: AppRouterName.paymentStatusPage,builder: (context,state) {
      return PaymentStatusPage();
    }),
    GoRoute(path: AppRouterName.termsAndConditionWebview,builder: (context,state){
      String webUrl = state.extra as String;
      return TermsAndConditionScreen(webUrl: webUrl);
    }),
    GoRoute(path: AppRouterName.bankStatementAnalyzer,builder: (context,state) {
      int timerValue = state.extra as int;
      return BankStatementAnalyzer(timerValue: timerValue);
    }),
    GoRoute(path: AppRouterName.sessionTimeOut,builder: (context,state) => SessionTimeOutLoan112()),
  ],
  observers: [
    routeObserver
  ]
);






