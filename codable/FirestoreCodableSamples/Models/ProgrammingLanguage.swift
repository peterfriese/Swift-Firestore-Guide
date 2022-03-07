//
//  ProgrammingLanguage.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 19.03.21.
//

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
