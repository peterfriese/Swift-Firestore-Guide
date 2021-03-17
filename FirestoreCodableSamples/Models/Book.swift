//
//  Person.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 29.01.21.
//

import Foundation

public struct Book: Codable {
  var title: String
  var numberOfPages: Int
  var author: String
}

extension Book {
  static let empty = Book(title: "", numberOfPages: 0, author: "")
}
