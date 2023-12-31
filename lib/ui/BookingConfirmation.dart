import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:erazor/theme/theme.dart';
import 'package:erazor/ui/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class BookingConfirmation extends ConsumerStatefulWidget {
  const BookingConfirmation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingConfirmationState();
}

class _BookingConfirmationState extends ConsumerState<BookingConfirmation> {
  void play() async {
    String audioasset = 'assets/audio/audio.mp3';

    final player = AudioPlayer();
    ByteData bytes = await rootBundle.load(audioasset);
    Uint8List audiobytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.play(BytesSource(audiobytes));
    player.onPlayerComplete.listen((event) {
      Routemaster.of(context).replace('/');
    });
  }

  @override
  void initState() {
    super.initState();
    play();
    //navigate(context);
  }

  @override
  Widget build(BuildContext context) {
    //navigate(context);
    // Routemaster.of(context).popUntil((routeData) {
    //   print('routedata ${routeData.fullPath}');
    //   print('routehistory ${Routemaster.of(context).history}');
    //   return routeData.fullPath != '/';
    // });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                play();
              },
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 200,
                color: Blue001,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Thanks, your booking has been confirmed!',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
