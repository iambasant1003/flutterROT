import 'package:flutter_bloc/flutter_bloc.dart';

class UploadBankStatementStatusCubit extends Cubit<bool> {
  UploadBankStatementStatusCubit() : super(false); // initially hidden

  void showSuccess() => emit(true);
  void hideSuccess() => emit(false);
  void toggle() => emit(!state);
}
