/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

import 'package:driver/app/presentation/pages/account/sounds/bloc/sounds_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class SoundScreen extends StatelessWidget {
  const SoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SoundsBloc()..add(SoundsInitialEvent()), child: const SoundView());
  }
}

class SoundView extends StatefulWidget {
  const SoundView({super.key});

  @override
  State<SoundView> createState() => _SoundViewState();
}

class _SoundViewState extends State<SoundView> {
  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    if (player.playerState.playing) {
      player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<SoundsBloc, SoundsState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.notification_sound), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                state.sounds.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (state.playingSound == '') {
                            context.read<SoundsBloc>().add(SoundsPlayingEvent(sound: state.sounds[index].sound!));
                            await player.setAsset(state.sounds[index].sound!);
                            await player.setVolume(1.0);
                            await player.play();
                          } else if (state.playingSound == state.sounds[index].sound && player.playerState.playing) {
                            await player.pause();
                          } else if (state.playingSound == state.sounds[index].sound && !player.playerState.playing) {
                            await player.play();
                          } else {
                            context.read<SoundsBloc>().add(SoundsPlayingEvent(sound: state.sounds[index].sound!));
                            await player.setAsset(state.sounds[index].sound!);
                            await player.setVolume(1.0);
                            await player.play();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(state.playingSound == state.sounds[index].sound ? Icons.pause : Icons.play_arrow, size: 14, color: Theme.of(context).canvasColor),
                            kAppSpacerHorizontal(width: 5),
                            Text(state.sounds[index].name!, style: kAppLblTinyFontBold(context)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => context.read<SoundsBloc>().add(SoundsSelectEvent(sound: state.sounds[index].sound!)),
                        child: Icon(
                          state.savedBell == state.sounds[index].sound ? Icons.radio_button_checked_outlined : Icons.circle_outlined,
                          size: 14,
                          color: state.savedBell == state.sounds[index].sound ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
// DONE //