//
//  Person.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 29.01.21.
//

import Foundation
import FirebaseFirestoreSwift

public struct Book: Codable {
  @DocumentID var id: String?
  var title: String
  var numberOfPages: Int
  var author: String
}

extension Book {
  static let empty = Book(title: "", numberOfPages: 0, author: "")
}
