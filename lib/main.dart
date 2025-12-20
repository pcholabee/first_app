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
      title: 'Random Cats',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => NasaCubit()..loadData(),
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
        title: const Text('Random Cat Images'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<NasaCubit>().loadData();
            },
          ),
        ],
      ),
      body: BlocBuilder<NasaCubit, NasaState>(
        builder: (context, state) {
          if (state is NasaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NasaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<NasaCubit>().loadData(),
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          } else if (state is NasaLoaded) {
            return _buildPhotoList(state.photos);
          }
          return const Center(child: Text('Нет данных'));
        },
      ),
    );
  }

  Widget _buildPhotoList(List<Photo> photos) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              Image.network(
                photo.url,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 300,
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
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('ID: ${photo.id}'),
              ),
            ],
          ),
        );
      },
    );
  }
}