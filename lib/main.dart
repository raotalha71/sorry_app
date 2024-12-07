import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Google Fonts package
import 'package:audioplayers/audioplayers.dart'; // Audio Players package

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  // Flashcard Data
  final List<String> flashcards = [
    "My dear Moizza, A beautiful soul , With a beautidul heart.",
    "Who doesn't laugh much, but easily gets hurt.",
    "Yes she is fragile like a snow flake.",
    "I want to protect her from the heat of Society.",
    "If she loves me or not, I'll love her forever.",
  ];

  final List<String> imagePaths = [
    'assets/images/M.jpeg',
    'assets/images/O.jpeg',
    'assets/images/T.jpeg',
    'assets/images/R.jpeg',
    'assets/images/P.jpeg'
  ];

  int currentIndex = 0;
  Offset cardOffset = Offset.zero; // Offset for dragging
  bool isDragging = false; // To track if a drag is active

  // Audio Player
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playMusic() async {
    try {
      await _audioPlayer
          .play(AssetSource('assets/audio/s.mp3')); // Correct asset path
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      cardOffset = Offset.zero; // Reset position
    });
  }

  @override
  void initState() {
    super.initState();
    playMusic(); // Start music automatically on app launch
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose audio resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text(
          "Moizza My Love ",
          style: GoogleFonts.greatVibes(fontSize: 30),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: flashcards.reversed.map((flashcard) {
              int cardIndex = flashcards.indexOf(flashcard);

              if (cardIndex < currentIndex) {
                return const SizedBox.shrink();
              }

              double stackOffset = (cardIndex - currentIndex) * 10.0;
              bool isTopCard = cardIndex == currentIndex;

              return AnimatedContainer(
                duration: Duration(milliseconds: isDragging ? 0 : 300),
                transform: Matrix4.translationValues(
                  isTopCard ? cardOffset.dx : 0,
                  isTopCard ? cardOffset.dy : stackOffset,
                  0,
                ),
                margin: EdgeInsets.only(
                  top: stackOffset,
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade200,
                      blurRadius: 15.0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (isTopCard) {
                      setState(() {
                        cardOffset += details.delta;
                        isDragging = true;
                      });
                    }
                  },
                  onPanEnd: (details) {
                    if (isTopCard) {
                      if (cardOffset.dx.abs() > 110 ||
                          cardOffset.dy.abs() > 100) {
                        setState(() {
                          nextCard();
                          isDragging = false;
                        });
                      } else {
                        setState(() {
                          cardOffset = Offset.zero;
                          isDragging = false;
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image at the top of the card
                      Container(
                        width: 230,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(imagePaths[cardIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Text in the card
                      isTopCard
                          ? Text(
                              flashcard,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.greatVibes(
                                fontSize: 24,
                                color: Colors.deepPurple.shade800,
                                fontWeight: FontWeight.w400,
                                shadows: [
                                  Shadow(
                                    color: Colors.purple.shade300,
                                    offset: const Offset(2, 2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
