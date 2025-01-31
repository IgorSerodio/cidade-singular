import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/progress.dart';
import '../../util/colors.dart';

class MissionProgressWidget extends StatelessWidget {
  final MapEntry<Progress, Mission> missionProgress;
  final EdgeInsets margin;
  final VoidCallback? onTap;

  const MissionProgressWidget({
    Key? key,
    required this.missionProgress,
    this.margin = const EdgeInsets.all(16),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = Modular.get();
    final bool isRewardCollected = userStore.user!.accessories.contains(missionProgress.value.reward);
    final bool isMissionCompleted = missionProgress.key.target == missionProgress.key.value;

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
                        "assets/images/accessories/${missionProgress.value.reward}.png",
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
                        "${missionProgress.key.value}/${missionProgress.key.target}",
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
                  child: Text(
                    missionProgress.value.description,
                    softWrap: true,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
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
