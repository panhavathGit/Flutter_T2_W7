import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'async_value.dart';
class RidesPreferencesProvider extends ChangeNotifier {
   RidePreference? _currentPreference;
   // Initialize pastPreferences as AsyncValue.loading() to handle the loading state
   AsyncValue<List<RidePreference>> pastPreferences = AsyncValue.loading();
 
   final RidePreferencesRepository repository;
 
   RidesPreferencesProvider({required this.repository}) {
     // Fetch past preferences when the provider is created
     _fetchPastPreferences();
   }
 
   void _fetchPastPreferences() async {
     pastPreferences = AsyncValue.loading();
     notifyListeners();
 
     try {
       List<RidePreference> pastPrefs = await repository.getPastPreferences();
       print(pastPrefs); // Useful for debugging
 
       pastPreferences = AsyncValue.success(pastPrefs);
     } catch (e) {
       pastPreferences = AsyncValue.error(e);
     }
 
     notifyListeners();
   }
 
   RidePreference? get currentPreference => _currentPreference;
 
    void _addPreference(RidePreference preference) async {
     // Safely check if the preference already exists in the list
     if (pastPreferences.data != null &&
         !pastPreferences.data!.contains(preference)) {
       await repository.addPreference(preference);
       _fetchPastPreferences(); // Refresh the preferences after adding a new one
     }
   }

   // History is returned from newest to oldest preference
   List<RidePreference> get preferencesHistory {
     // Safely check for null before accessing data
     return pastPreferences.data?.reversed.toList() ?? [];
   }

   void setCurrentPreferrence(RidePreference pref) async {
     if (_currentPreference != pref) {
       _currentPreference = pref;
       _addPreference(pref);
       notifyListeners();
    }
 }
}
