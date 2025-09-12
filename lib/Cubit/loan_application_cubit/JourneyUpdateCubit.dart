import 'package:flutter_bloc/flutter_bloc.dart';

class JourneyUpdateCubit extends Cubit<Map<String, dynamic>> {
  JourneyUpdateCubit() : super({});


  void updateJourneyTabs(Map<String, dynamic> newTabs) {
    emit(newTabs);
  }


  void clear() {
    emit({});
  }
}
