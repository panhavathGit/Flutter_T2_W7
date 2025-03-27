import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/provider/rides_preferences_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../service/ride_prefs_service.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';
import 'package:provider/provider.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  RidePreference get currentPreference =>
      RidePrefService.instance.currentPreference!;

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    final ridePrefProvider = Provider.of<RidesPreferencesProvider>(context, listen: false);

    ridePrefProvider.setCurrentPreferrence(newPreference);

    Navigator.of(context).pop(
      AnimationUtils.createBottomToTopRoute(const RidesScreen()),
    );

    ridePrefProvider.setCurrentPreferrence(newPreference);
  }

   void onPreferencePressed(BuildContext context, RidePreference currentPreference) async {
    RidePreference? newPreference =
         await Navigator.of(context).push<RidePreference>(
       AnimationUtils.createTopToBottomRoute(
         RidePrefModal(initialPreference: currentPreference),
       ),
     );
    // 2 -   Update the state   -- TODO MAKE IT WITH STATE MANAGEMENT
    if (!context.mounted || newPreference == null) {
       return;
     }
 
     final ridePrefProvider =
         Provider.of<RidesPreferencesProvider>(context, listen: false);
 
     // Update preference
     ridePrefProvider.setCurrentPreferrence(newPreference);
    }


  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    final ridePrefProvider = Provider.of<RidesPreferencesProvider>(context);
     RidePreference? currentPreference = ridePrefProvider.currentPreference;
 
     if (currentPreference == null) {
       return const Center(child: CircularProgressIndicator());
     }
 
     RideFilter currentFilter = RideFilter();
     List<Ride> matchingRides =
         RidesService.instance.getRidesFor(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed:  () => onBackPressed(context),
              onPreferencePressed: () =>
                   onPreferencePressed(context, currentPreference),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                   ride: matchingRides[index],
                   onPressed: () {},
                 ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
