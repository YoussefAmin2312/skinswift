import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinswift/auth/auth_service.dart';
import 'package:skinswift/home_screen.dart';
import 'package:skinswift/survey_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is NOT logged in -> Start the survey flow
          if (!snapshot.hasData) {
            return const SurveyScreen();
          }

          // User is logged in -> Go to home screen
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                // If there's an error or no data, something is wrong.
                // For safety, log out and let them sign in again.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AuthService().signOut();
                });
                return const Center(child: CircularProgressIndicator());
              }

              final userData = userSnapshot.data!.data() as Map<String, dynamic>;

              return HomeScreen(
                skinType: userData['skinType'] ?? 'Normal',
                skinConcerns: List<String>.from(userData['skinConcerns'] ?? []),
                surveyData: const [], // Survey data is not needed on home screen directly
              );
            },
          );
        },
      ),
    );
  }
} 