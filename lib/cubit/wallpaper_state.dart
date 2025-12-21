import 'package:equatable/equatable.dart';
import '../models/wallpaper.dart';
import '../models/api_response.dart';

abstract class WallpaperState extends Equatable {
  const WallpaperState();

  @override
  List<Object> get props => [];
}

class WallpaperInitial extends WallpaperState {
  const WallpaperInitial();
}

class WallpaperLoading extends WallpaperState {
  const WallpaperLoading();
}

class WallpaperLoadingMore extends WallpaperState {
  const WallpaperLoadingMore();
}

class WallpaperLoaded extends WallpaperState {
  final List<Wallpaper> wallpapers;
  final Meta meta;
  final bool hasMore;

  const WallpaperLoaded({
    required this.wallpapers,
    required this.meta,
    required this.hasMore,
  });

  @override
  List<Object> get props => [wallpapers, meta, hasMore];
}

class WallpaperDetailLoaded extends WallpaperState {
  final Wallpaper wallpaper;

  const WallpaperDetailLoaded({required this.wallpaper});

  @override
  List<Object> get props => [wallpaper];
}

class WallpaperEmpty extends WallpaperState {
  final String message;

  const WallpaperEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class WallpaperError extends WallpaperState {
  final String message;

  const WallpaperError(this.message);

  @override
  List<Object> get props => [message];
}