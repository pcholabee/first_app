import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/nasa_cubit.dart';
import 'cubit/nasa_state.dart';
import 'models/photo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA Spirit Rover',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => NasaCubit()..loadData('spirit', 50),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spirit Rover - Сол 50'),
      ),
      body: BlocBuilder<NasaCubit, NasaState>(
        builder: (context, state) {
          if (state is NasaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NasaError) {
            return Center(child: Text(state.message));
          } else if (state is NasaLoaded) {
            return _buildPhotoList(state.photos);
          }
          return const Center(child: Text('Нет данных'));
        },
      ),
    );
  }

  Widget _buildPhotoList(List<Photo> photos) {
    if (photos.isEmpty) {
      return const Center(child: Text('Фотографии не найдены'));
    }

    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              Image.network(
                photo.imgSrc,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: 200,
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${photo.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Сол: ${photo.sol}'),
                    Text('Камера: ${photo.camera.fullName}'),
                    Text('Дата на Земле: ${photo.earthDate}'),
                    Text('Марсоход: ${photo.rover.name}'),
                    Text('Статус: ${photo.rover.status}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}