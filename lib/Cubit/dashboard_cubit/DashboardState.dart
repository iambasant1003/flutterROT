

import 'package:equatable/equatable.dart';


import '../../Model/DashBoarddataModel.dart';
import '../../Model/DeleteCustomerModel.dart';
import '../../Model/DeleteProfileOTPVerifyModel.dart';


abstract class DashboardState extends Equatable {}

class DashBoardInitial extends DashboardState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DashBoardLoading extends DashboardState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DashBoardSuccess extends DashboardState {
  final DashBoarddataModel dashBoardModel;
  DashBoardSuccess(this.dashBoardModel);

  @override
  // TODO: implement props
  List<Object?> get props => [dashBoardModel];
}

class DashBoardError extends DashboardState{
  final DashBoarddataModel dashBoardModel;
  DashBoardError(this.dashBoardModel);

  @override
  // TODO: implement props
  List<Object?> get props => [dashBoardModel];
}

class DeleteCustomerSuccess extends DashboardState{
  final DeleteCustomerModel deleteCustomerModel;
  DeleteCustomerSuccess(this.deleteCustomerModel);

  @override
  // TODO: implement props
  List<Object?> get props => [deleteCustomerModel];
}

class DeleteCustomerFailed extends DashboardState{
  final DeleteCustomerModel deleteCustomerModel;
  DeleteCustomerFailed(this.deleteCustomerModel);

  @override
  // TODO: implement props
  List<Object?> get props => [deleteCustomerModel];
}

class DeleteOTPVerified extends DashboardState{
  final DeleteProfileOTPVerifyModel deleteProfileOTPVerifyModel;
  DeleteOTPVerified(this.deleteProfileOTPVerifyModel);

  @override
  // TODO: implement props
  List<Object?> get props => [deleteProfileOTPVerifyModel];
}

class DeleteOTPFailed extends DashboardState{
  final DeleteProfileOTPVerifyModel deleteProfileOTPVerifyModel;
  DeleteOTPFailed(this.deleteProfileOTPVerifyModel);

  @override
  // TODO: implement props
  List<Object?> get props => [deleteProfileOTPVerifyModel];
}

