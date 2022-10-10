//
// MenuScreen.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 17.03.21.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
          NavigationLink(destination: CustomizeMappingScreen()) {
            Label("Mapping dates and times", systemImage: "calendar.badge.clock")
          }
          NavigationLink(destination: MappingGeoPointsScreen()) {
            Label("Mapping GeoPoints", systemImage: "globe")
          }
          NavigationLink(destination: MappingColorsScreen()) {
            Label("Mapping Colors", systemImage: "paintpalette")
          }
          NavigationLink(destination: MappingEnumsScreen()) {
            Label("Mapping Enums", systemImage: "list.number")
          }
          NavigationLink(destination: CustomizeMappingScreen()) {
            Label("Custom mapping", systemImage: "sparkles.square.fill.on.square")
          }
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
