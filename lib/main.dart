import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

late RiveFile riveFile;
late Artboard benefitOneArtboard;

Future<void> main() async {
  await _loadRiveFileFromDisk();

  runApp(const MainApp());
}

Future _loadRiveFileFromDisk() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveFile.initialize();
  final riveAnimationData = await rootBundle.load('assets/tidyplan_ui.riv');
  riveFile = RiveFile.import(riveAnimationData);

  benefitOneArtboard = riveFile.artboardByName('benefit-1-view')!;

  final stateMachineController = StateMachineController.fromArtboard(
    benefitOneArtboard,
    'State Machine 1',
  );

  stateMachineController!.addEventListener((event) {
    print('🔥🔥🔥 Event Fired 🔥🔥🔥 - ${event.name}');
  });

  benefitOneArtboard.addController(stateMachineController);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // ------- 👇👇👇👇 Uncomment bellow to see broken event code 👇👇👇👇 --------
        body: Rive(
          artboard: benefitOneArtboard.instance(),
          useArtboardSize: true,
          fit: BoxFit.cover,
          enablePointerEvents: true,
        ),
        // ------- 👇👇👇👇 Uncomment bellow to see working event 👇👇👇👇 --------
        // body: RiveAnimation.asset(
        //   'assets/tidyplan_ui.riv',
        //   artboard: 'benefit-1-view',
        //   onInit: (artboard) {
        //     final stateMachineController = StateMachineController.fromArtboard(
        //       artboard,
        //       'State Machine 1',
        //     );

        //     stateMachineController!.addEventListener((event) {
        //       print('🔥🔥🔥 Event Fired 🔥🔥🔥 - ${event.name}');
        //     });

        //     artboard.addController(stateMachineController);
        //   },
        // ),
      ),
    );
  }
}
