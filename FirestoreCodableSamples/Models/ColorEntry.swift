//
//  ColorEntry.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 19.03.21.
//

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
