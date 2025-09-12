import 'package:flutter_bloc/flutter_bloc.dart';

extension CubitExtension<T> on Cubit<T> {
  void safeEmit(void Function() callBack) {
    if (!isClosed) {
      callBack();
    }
  }
}

//Way to calling:
//safeEmit(() => emit(CustomerDetailsSuccess()));