//
//  MenuScreen.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 17.03.21.
//

import SwiftUI

struct MenuScreen: View {
  var body: some View {
    SampleScreen("Firestore & Codable",
                 introduction: "Learn how to map data from Firestore using Swift's Codable API. \n\n"
                  + "To run this demo, install the Firebase Emulator Suite and run the 'start.sh' script in the root folder of this project.")
    {
      Form {
        Section(header: Text("Mapping manually")) {
          NavigationLink(destination: ManuallyMappingSimpleTypesScreen()) {
            Label("Manually mapping simple types", systemImage: "hand.draw")
          }
        }
        Section(header: Text("Mapping simple types")) {
          NavigationLink(destination: MappingSimpleTypesScreen()) {
            Label("Mapping simple types", systemImage: "list.bullet.rectangle")
          }
        }
        Section(header: Text("Mapping complex types")) {
          NavigationLink(destination: MappingCustomTypesScreen()) {
            Label("Mapping custom types", systemImage: "rectangle.3.offgrid")
          }
          NavigationLink(destination: MappingArraysScreen()) {
            Label("Mapping arrays", systemImage: "square.stack.3d.down.forward")
          }
          NavigationLink(destination: MappingArraysWithNestedTypesScreen()) {
            Label("Mapping arrays w/ custom types", systemImage: "square.stack.3d.down.forward")
          }
          Label("Mapping dates and times", systemImage: "calendar.badge.clock")
          Label("Mapping GeoPoints", systemImage: "globe")
          NavigationLink(destination: MappingColorsScreen()) {
            Label("Mapping Colors", systemImage: "paintpalette")
          }
          Label("Mapping Enums", systemImage: "list.number")
        }
        Section(header: Text("Custom mapping")) {
          Label("Omit fields", systemImage: "eye.slash")
          Label("Adjust field names", systemImage: "dial.max")
        }
      }
    }
  }
}

struct MenuScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MenuScreen()
    }
  }
}
