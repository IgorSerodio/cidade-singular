import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/progress.dart';

class MissionProgressWidget extends StatelessWidget {
  final Progress progress;
  final EdgeInsets margin;
  final VoidCallback? onTap;

  const MissionProgressWidget({
    Key? key,
    required this.progress,
    this.margin = const EdgeInsets.all(16),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = Modular.get();
    final bool isRewardCollected = userStore.user!.accessories.contains(progress.missionReward);
    final bool isMissionCompleted = progress.target == progress.value;

    return GestureDetector(
      onTap: isMissionCompleted && !isRewardCollected ? onTap : null,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ColorFiltered(
          colorFilter: isRewardCollected
              ? const ColorFilter.mode(Colors.black54, BlendMode.srcATop)
              : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
          child: Row(
            children: [
              const SizedBox(width: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 80,
                      child: Image.asset(
                        "assets/images/accessories/${progress.missionReward}.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (isMissionCompleted && !isRewardCollected)
                      const Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                    if (!isMissionCompleted)
                      Text(
                        "${progress.value}/${progress.target}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.missionDescription,
                        softWrap: true,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
