import 'package:flutter_bloc/flutter_bloc.dart';
import '../requests/api.dart';
import 'nasa_state.dart';

class NasaCubit extends Cubit<NasaState> {
  NasaCubit() : super(NasaInitial());

  void loadData(String rover, int sol) async {
    emit(NasaLoading());
    try {
      final nasaResponse = await ApiService.getPhotos(rover, sol);
      emit(NasaLoaded(nasaResponse.photos));
    } catch (e) {
      emit(NasaError('Ошибка загрузки: $e'));
    }
  }
}