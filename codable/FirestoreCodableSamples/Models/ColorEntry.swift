//
// ColorEntry.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 19.03.21.
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

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct ColorEntry: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var color: Color
}

extension ColorEntry {
  static var empty = ColorEntry(name: "", color: Color.red)
  static var sample = [
    ColorEntry(id: "red", name: "Red", color: .red),
    ColorEntry(id: "cerise", name: "Cerise", color: Color(hex: "#d52c67"))
  ]
}
