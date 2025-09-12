import 'package:flutter_bloc/flutter_bloc.dart';

class AddMoreReferenceCubit extends Cubit<bool> {
  AddMoreReferenceCubit() : super(false);


  void updateReference(bool newTabs) {
    emit(newTabs);
  }


  void clear() {
    emit(false);
  }
}
