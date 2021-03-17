//
//  FirestoreCodableSamplesApp.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 29.01.21.
//

import SwiftUI
import Firebase

@main
struct FirestoreCodableSamplesApp: App {
  init() {
    FirebaseApp.configure()
    
    // connect to Firestore Emulator
    Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)
    let settings = Firestore.firestore().settings
    settings.isPersistenceEnabled = false
    settings.isSSLEnabled = false
    Firestore.firestore().settings = settings
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        MenuScreen()
      }
    }
  }
}
