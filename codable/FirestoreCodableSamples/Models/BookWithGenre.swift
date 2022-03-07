//
//  BookWithGenre.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 18.03.21.
//

import Foundation
import FirebaseFirestoreSwift

public struct BookWithGenre: Codable {
  @DocumentID var id: String?
  var title: String
  var numberOfPages: Int
  var author: String
  var genres: [String]
}

extension BookWithGenre {
  static let empty = BookWithGenre(title: "", numberOfPages: 0, author: "", genres: [])
  static let sample = BookWithGenre(title: "SwiftUI & Combine", numberOfPages: 350, author: "Peter Friese", genres: ["IT", "Programming Languages"])
}
