import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(6, (index) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: Center(child: Text('Container $index')),
                );
              }),
            ),
            SizedBox(height: 20),
            
            Column(
              children: [
                Text('ФИО: Лидихо Станислав Александрович', style: TextStyle(fontSize: 20)),
                Text('Год рождения: 2004', style: TextStyle(fontSize: 20)),
                Text('Группа: ИСТУ-22-1', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 20),
            
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.star),
                    Icon(Icons.favorite),
                    Icon(Icons.home),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.person),
                    Icon(Icons.email),
                    Icon(Icons.phone),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            
            Stack(
              alignment: Alignment.center,
              children: [
                Container(color: Colors.black, width: 150, height: 150),
                Container(color: Colors.yellow, width: 100, height: 100),
                Container(color: Colors.white, width: 50, height: 50),
              ],
            ),
            SizedBox(height: 20),
            
            Wrap(
              spacing: 8.0,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.amber,
                  child: Text('ФИО: Лидихо Станислав Александрович'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.lightBlue,
                  child: Text('Год рождения: 2004'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.lightGreen,
                  child: Text('Группа: ИСТУ-22-1'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.purpleAccent,
                  child: Text('Специальность: ИСТУ'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.orangeAccent,
                  child: Text('Курс: 4'),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/1.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/2.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/3.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/4.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/5.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/6.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 