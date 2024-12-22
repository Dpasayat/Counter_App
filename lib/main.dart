import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterUI(),
    );
  }
}

class CounterUI extends StatefulWidget {
  const CounterUI({super.key});

  @override
  _CounterUIState createState() => _CounterUIState();
}

class _CounterUIState extends State<CounterUI> {
  int topCounter = 0;
  int bottomCounter = 0;

  bool isTopDecrementPressed = false;
  bool isTopIncrementPressed = false;
  bool isBottomDecrementPressed = false;
  bool isBottomIncrementPressed = false;

  TextEditingController topPlayerController = TextEditingController();
  TextEditingController bottomPlayerController = TextEditingController();

  void _incrementTopCounter() {
    _provideFeedback();
    setState(() {
      topCounter++;
    });
  }

  void _decrementTopCounter() {
    _provideFeedback();
    setState(() {
      topCounter--;
    });
  }

  void _incrementBottomCounter() {
    _provideFeedback();
    setState(() {
      bottomCounter++;
    });
  }

  void _decrementBottomCounter() {
    _provideFeedback();
    setState(() {
      bottomCounter--;
    });
  }

  void _resetCounters() {
    setState(() {
      topCounter = 0;
      bottomCounter = 0;
      topPlayerController.clear();
      bottomPlayerController.clear();
    });
  }

  void _provideFeedback() {
    // Trigger vibration
    HapticFeedback.lightImpact();
    // Play system sound
    SystemSound.play(SystemSoundType.click);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCounters,
            tooltip: "Reset Counters",
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Navigate to the name entry screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PlayerNamesScreen()),
            ).then((names) {
              if (names != null) {
                topPlayerController.text = names[0];
                bottomPlayerController.text = names[1];
              }
            });
          },
          tooltip: "Edit Player Names",
        ),
      ),
      body: Column(
        children: [
          // Player Name (Top)
          PlayerNameInput(
            controller: topPlayerController,
            backgroundColor: Colors.red[400]!,
            placeholder: 'Top Player',
          ),
          // Top Counter
          Expanded(
            child: CounterSection(
              backgroundColor: Colors.red[400]!,
              counterValue: topCounter,
              onIncrement: _incrementTopCounter,
              onDecrement: _decrementTopCounter,
              isIncrementPressed: isTopIncrementPressed,
              isDecrementPressed: isTopDecrementPressed,
              onIncrementPress: (bool pressed) {
                setState(() {
                  isTopIncrementPressed = pressed;
                });
              },
              onDecrementPress: (bool pressed) {
                setState(() {
                  isTopDecrementPressed = pressed;
                });
              },
            ),
          ),
          // Player Name (Bottom)
          PlayerNameInput(
            controller: bottomPlayerController,
            backgroundColor: Colors.blue[400]!,
            placeholder: 'Bottom Player',
          ),
          // Bottom Counter
          Expanded(
            child: CounterSection(
              backgroundColor: Colors.blue[400]!,
              counterValue: bottomCounter,
              onIncrement: _incrementBottomCounter,
              onDecrement: _decrementBottomCounter,
              isIncrementPressed: isBottomIncrementPressed,
              isDecrementPressed: isBottomDecrementPressed,
              onIncrementPress: (bool pressed) {
                setState(() {
                  isBottomIncrementPressed = pressed;
                });
              },
              onDecrementPress: (bool pressed) {
                setState(() {
                  isBottomDecrementPressed = pressed;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerNamesScreen extends StatefulWidget {
  const PlayerNamesScreen({super.key});

  @override
  _PlayerNamesScreenState createState() => _PlayerNamesScreenState();
}

class _PlayerNamesScreenState extends State<PlayerNamesScreen> {
  TextEditingController topPlayerController = TextEditingController();
  TextEditingController bottomPlayerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Player Names'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context,
                  [topPlayerController.text, bottomPlayerController.text]);
            },
            tooltip: "Save Names",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: topPlayerController,
              style: GoogleFonts.anta(
                color: Colors.black,
                fontSize: 30, //font size for top player
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Top Player Name',
                hintStyle: TextStyle(color: Colors.black38),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: bottomPlayerController,
              style: GoogleFonts.anta(
                color: Colors.black,
                fontSize: 30, //font size for bottom player
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Bottom Player Name',
                hintStyle: TextStyle(color: Colors.black38),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerNameInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Color backgroundColor;

  const PlayerNameInput({
    super.key,
    required this.controller,
    required this.backgroundColor,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: GoogleFonts.anta(color: Colors.white, fontSize: 30),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
    );
  }
}

class CounterSection extends StatelessWidget {
  final Color backgroundColor;
  final int counterValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isIncrementPressed;
  final bool isDecrementPressed;
  final ValueChanged<bool> onIncrementPress;
  final ValueChanged<bool> onDecrementPress;

  const CounterSection({
    super.key,
    required this.backgroundColor,
    required this.counterValue,
    required this.onIncrement,
    required this.onDecrement,
    required this.isIncrementPressed,
    required this.isDecrementPressed,
    required this.onIncrementPress,
    required this.onDecrementPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        children: [
          // Left side (Decrement button with feedback)
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => onDecrementPress(true),
              onTapUp: (_) {
                onDecrement();
                onDecrementPress(false);
              },
              onTapCancel: () => onDecrementPress(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                color: isDecrementPressed
                    ? Color.fromARGB(255, 219, 208, 208).withOpacity(0.6)
                    : backgroundColor,
                child: const Center(
                  child: Icon(Icons.remove, size: 40, color: Colors.white),
                ),
              ),
            ),
          ),
          // Counter value
          Text(
            '$counterValue',
            style: GoogleFonts.anta(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Right side (Increment button with feedback)
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => onIncrementPress(true),
              onTapUp: (_) {
                onIncrement();
                onIncrementPress(false);
              },
              onTapCancel: () => onIncrementPress(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                color: isIncrementPressed
                    ? const Color.fromARGB(255, 235, 238, 235).withOpacity(0.6)
                    : backgroundColor,
                child: const Center(
                  child: Icon(Icons.add, size: 40, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
