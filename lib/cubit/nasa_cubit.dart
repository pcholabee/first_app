import 'package:flutter_bloc/flutter_bloc.dart';
import '../requests/api.dart';
import 'nasa_state.dart';

class NasaCubit extends Cubit<NasaState> {
  NasaCubit() : super(const NasaInitial());

  void loadData() async {
    emit(const NasaLoading());
    try {
      final nasaResponse = await ApiService.getPhotos();
      if (nasaResponse.photos.isNotEmpty) {
        emit(NasaLoaded(nasaResponse.photos));
      } else {
        emit(const NasaError('Нет доступных изображений'));
      }
    } catch (e) {
      emit(NasaError('Ошибка: $e'));
    }
  }
}