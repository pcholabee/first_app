import 'package:flutter_bloc/flutter_bloc.dart';
import '../requests/api.dart';
import '../models/api_response.dart';
import 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  WallpaperCubit() : super(const WallpaperInitial());

  int _currentPage = 1;
  String _currentSort = 'date_added';
  String _currentQuery = '';
  bool _hasMore = true;

  // Загрузить обои
  Future<void> loadWallpapers({
    String query = '',
    String sorting = 'date_added',
    String category = '111',
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
        emit(const WallpaperLoading());
      } else {
        emit(const WallpaperLoadingMore());
      }

      _currentSort = sorting;
      _currentQuery = query;

      print('🔄 Cubit: Загрузка обоев');

      final WallhavenResponse response = await WallhavenApiService.searchWallpapers(
        query: query,
        sorting: sorting,
        categories: category,
        page: _currentPage,
      );

      _hasMore = _currentPage < response.meta.lastPage;

      if (response.data.isEmpty) {
        emit(const WallpaperEmpty('Обои не найдены'));
      } else {
        emit(WallpaperLoaded(
          wallpapers: response.data,
          meta: response.meta,
          hasMore: _hasMore,
        ));
      }
    } catch (e) {
      print('❌ Cubit: Ошибка: $e');
      emit(WallpaperError('Ошибка загрузки: $e'));
    }
  }

  // Загрузить еще
  Future<void> loadMore() async {
    if (!_hasMore) return;

    final currentState = state;
    if (currentState is WallpaperLoaded) {
      _currentPage++;
      
      try {
        final WallhavenResponse response = await WallhavenApiService.searchWallpapers(
          query: _currentQuery,
          sorting: _currentSort,
          page: _currentPage,
        );

        _hasMore = _currentPage < response.meta.lastPage;

        final allWallpapers = [
          ...currentState.wallpapers,
          ...response.data,
        ];

        emit(WallpaperLoaded(
          wallpapers: allWallpapers,
          meta: response.meta,
          hasMore: _hasMore,
        ));
      } catch (e) {
        _currentPage--;
        print('❌ Cubit: Ошибка загрузки еще: $e');
      }
    }
  }

  // Обновить
  Future<void> refreshWallpapers() async {
    await loadWallpapers(refresh: true);
  }

  // Поиск
  Future<void> searchWallpapers(String query) async {
    await loadWallpapers(query: query, sorting: 'relevance', refresh: true);
  }

  // Сортировка
  Future<void> sortBy(String sorting) async {
    await loadWallpapers(sorting: sorting, refresh: true);
  }

  // Получить по ID
  Future<void> getWallpaperById(String id) async {
    emit(const WallpaperLoading());
    
    try {
      final wallpaper = await WallhavenApiService.getWallpaperById(id);
      emit(WallpaperDetailLoaded(wallpaper: wallpaper));
    } catch (e) {
      emit(WallpaperError('Ошибка загрузки: $e'));
    }
  }
}