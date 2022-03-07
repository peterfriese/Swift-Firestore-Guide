//
//  BookWithTags.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 18.03.21.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct Tag: Codable, Hashable {
  var title: String
  var color: Color
}

struct BookWithTags: Codable {
  @DocumentID var id: String?
  var title: String
  var numberOfPages: Int
  var author: String
  var tags: [Tag]
}

extension BookWithTags {
  static let empty = BookWithTags(title: "", numberOfPages: 0, author: "", tags: [])
  static let sample = BookWithTags(title: "SwiftUI & Combine",
                                   numberOfPages: 350,
                                   author: "Peter Friese",
                                   tags: [
                                    Tag(title: "Swift", color: Color(hex: "#f05138")),
                                    Tag(title: "SwiftUI", color: Color(hex: "#012495"))
                                   ])
}
