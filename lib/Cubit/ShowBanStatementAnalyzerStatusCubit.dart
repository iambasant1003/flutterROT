
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowBankStatementAnalyzerStatusCubit extends Cubit<bool> {
  ShowBankStatementAnalyzerStatusCubit() : super(false);

  void show() => emit(true);
  void hide() => emit(false);
  void toggle() => emit(!state);
}
