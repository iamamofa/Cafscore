import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/standings_item.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../domain/entities/standings.dart';
import '../../domain/entities/team_rank.dart';
import '../cubit/soccer_cubit.dart';
import '../cubit/soccer_state.dart';
import '../widgets/leagues_header.dart';

class StandingsScreen extends StatelessWidget {
  StandingsScreen({Key? key}) : super(key: key);
  Standings? standings;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SoccerCubit, SoccerStates>(
      listener: (context, state) {
        if (state is SoccerStandingsLoaded) standings = state.standings;
      },
      builder: (context, state) {
        SoccerCubit cubit = context.read<SoccerCubit>();

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            LeaguesView(leagues: cubit.filteredLeagues, getFixtures: false),
            const SizedBox(height: AppSize.s5),
            if (state is SoccerStandingsLoading)
              const Center(
                  child: LinearProgressIndicator(color: AppColors.deepOrange)),
            if (standings != null)
              ...List.generate(
                standings!.standings.length,
                (index) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StandingsHeaders(),
                      const SizedBox(height: AppSize.s10),
                      ...List.generate(standings!.standings[index].length,
                          (teamIndex) {
                        TeamRank team = standings!.standings[index][teamIndex];
                        return StandingsItem(teamRank: team);
                      }),
                      const SizedBox(height: AppSize.s10),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
