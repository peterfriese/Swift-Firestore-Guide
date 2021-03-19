//
//  BookWithComplexType.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 18.03.21.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct CoverImages: Codable {
  var small: URL
  var medium: URL
  var large: URL
} 

struct BookWithCoverImages: Codable {
  @DocumentID var id: String?
  var title: String
  var numberOfPages: Int
  var author: String
  var cover: CoverImages?
  var color: Color
}

extension BookWithCoverImages {
  static let empty = BookWithCoverImages(title: "", numberOfPages: 0, author: "", cover: nil, color: .black)
}
