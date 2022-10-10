//
// ManuallyMappingSimpleTypesScreen.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 18.03.21.
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

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class ManuallyMappingSimpleTypesViewModel: ObservableObject {
  @Published var book: Book = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  fileprivate func fetchAndMap() {
    fetchBook(documentId: "hitchhiker")
  }
  
  fileprivate func fetchAndMapNonExisting() {
    fetchBook(documentId: "does-not-exist")
  }
  
  fileprivate func fetchAndTryMappingInvalidData() {
    fetchBook(documentId: "invalid-data")
  }
  
  #warning("DO NOT MAP YOUR DOCUMENTS MANUALLY. USE CODABLE INSTEAD.")
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument { document, error in
      if let error = error as NSError? {
        self.errorMessage = "Error getting document: \(error.localizedDescription)"
      }
      else {
        if let document = document {
          let id = document.documentID
          let data = document.data()
          let title = data?["title"] as? String ?? ""
          let numberOfPages = data?["numberOfPages"] as? Int ?? 0
          let author = data?["author"] as? String ?? ""
          self.book = Book(id:id, title: title, numberOfPages: numberOfPages, author: author)
        }
      }
    }
  }
}

struct ManuallyMappingSimpleTypesScreen: View {
  @StateObject var viewModel = ManuallyMappingSimpleTypesViewModel()
  
  @ViewBuilder
  var messageView: some View {
    if let errorMessage = viewModel.errorMessage {
      Text(errorMessage).foregroundColor(.red)
    }
    else {
      EmptyView()
    }
  }
  
  var body: some View {
    SampleScreen("Mapping Simple Types", introduction: "⚠️ Mapping documents manually is possible, but not recommended.") {
      Form {
        Section(header: Text("Book"), footer: messageView) {
          TextField("Title", text: $viewModel.book.title)
          TextField("Number of pages", value: $viewModel.book.numberOfPages, formatter: NumberFormatter())
          TextField("Author", text: $viewModel.book.author)
        }
        Section(header: Text("Actions")) {
          Button("Fetch and map a book") {
            viewModel.fetchAndMap()
          }
          Button("Fetch and map a non-existing book") {
            viewModel.fetchAndMapNonExisting()
          }
          Button("Try mapping book from invalid data") {
            viewModel.fetchAndTryMappingInvalidData()
          }
        }
      }
    }
  }
}

struct ManuallyMappingSimpleTypesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ManuallyMappingSimpleTypesScreen()
    }
  }
}
