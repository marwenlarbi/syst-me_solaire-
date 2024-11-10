import 'package:flutter/material.dart';
import 'planet_card.dart';
import 'planet.dart';
import 'planet_detail_screen.dart';
import 'quiz_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService = ApiService();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Planet>> planets;

  @override
  void initState() {
    super.initState();
    planets =
        widget.apiService.fetchPlanets(); // Fetch planets data from the API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'النظام الشمسي',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                  blurRadius: 5, color: Colors.black26, offset: Offset(2, 2)),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image for the space theme
          Positioned.fill(
            child: Image.asset(
              'assets/images/backend.jpeg', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: kToolbarHeight + 16),
                Text(
                  'استكشاف النظام الشمسي',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 5,
                          color: Colors.black26,
                          offset: Offset(2, 2)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Planet>>(
                    future: planets,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 216, 226, 232))));
                      } else if (snapshot.hasData) {
                        List<Planet> planetsData = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                          ),
                          itemCount: planetsData.length,
                          itemBuilder: (context, index) {
                            return PlanetCard(
                              planet: planetsData[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlanetDetailScreen(
                                      planet: planetsData[index]),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                            child: Text('No data available',
                                style: TextStyle(color: Colors.white)));
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Animated button with visual effects
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuizScreen(apiService: widget.apiService)),
                      );
                    },
                    child: Text(
                      'اختبار النظام الشمسي',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 22, 118, 243),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      textStyle:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
