//
// Article.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 10.10.22.
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
import Firebase
import FirebaseFirestoreSwift

enum Status: String, CaseIterable, Codable {
  case draft
  case inReview = "in review"
  case approved
  case published
}

extension Status {
  var color: Color {
    switch self {
    case .draft:
      return Color.red
    case .inReview:
      return Color.yellow
    case.approved:
      return Color.green
    case .published:
      return Color.blue
    }
  }
}

struct Article: Identifiable, Codable {
  @DocumentID var id: String?
  var title: String
  var status: Status
}

extension Article {
  static let empty = Article(title: "", status: .draft)
  static let sample = [
    Article(id: "codable", title: "Mapping Firestore Data in Swift - The Comprehensive Guide", status: Status.draft),
    Article(id: "lifecycle", title: "Firebase and the new SwiftUI 2 Application Life Cycle", status: Status.approved),
    Article(id: "drill-down", title: "SwiftUI Drill-down Navigation", status: .draft),
    Article(id: "asyncawait", title: "Using async/await in SwiftUI", status: .published),
  ]
}
