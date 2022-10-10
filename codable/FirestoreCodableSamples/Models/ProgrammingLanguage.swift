//
// ProgrammingLanguage.swift
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
import FirebaseFirestoreSwift

struct ProgrammingLanguage: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var year: Date
  var reasonWhyILoveThis: String = ""
  
  enum CodingKeys: String, CodingKey {
    case id
    case name = "language_name"
    case year
  }
}

extension ProgrammingLanguage {
  func yearAsString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: date)
  }
  
  var yearAsString: String {
    return yearAsString(date: year)
  }
}

extension ProgrammingLanguage {
  static let empty = ProgrammingLanguage(name: "", year: Date())
  static let sample = [
    ProgrammingLanguage(id: "plankalkuel", name: "Plankalkül", year: Date(), reasonWhyILoveThis: "It sounds fancy"),
    ProgrammingLanguage(id: "swift", name: "Swift", year: Date(), reasonWhyILoveThis: "Extensions & protocols")
  ]
}
