//
// MappingCustomTypesScreen.swift
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

class MappingCustomTypesViewModel: ObservableObject {
  @Published var book: BookWithCoverImages = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  fileprivate func fetchAndMap() {
    fetchBook(documentId: "hitchhiker-image-urls")
  }
  
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument(as: BookWithCoverImages.self) { result in
      switch result {
      case .success(let book):
        // A Book value was successfully initialized from the DocumentSnapshot.
        self.book = book
        self.errorMessage = nil
      case .failure(let error):
        // A Book value could not be initialized from the DocumentSnapshot.
        switch error {
        case DecodingError.typeMismatch(_, let context):
          self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
        case DecodingError.valueNotFound(_, let context):
          self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
        case DecodingError.keyNotFound(_, let context):
          self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
        case DecodingError.dataCorrupted(let key):
          self.errorMessage = "\(error.localizedDescription): \(key)"
        default:
          self.errorMessage = "Error decoding document: \(error.localizedDescription)"
        }
      }
    }
  }
  
  fileprivate func updateBook() {
    if let id = book.id {
      let docRef = db.collection("books").document(id)
      do {
        try docRef.setData(from: book)
      }
      catch {
        print(error)
      }
    }
  }
  
  fileprivate func addBook() {
    let collectionRef = db.collection("books")
    do {
      let newDocReference = try collectionRef.addDocument(from: self.book)
      print("Book stored with new document reference: \(newDocReference)")
    }
    catch {
      print(error)
    }
  }
}

struct MappingCustomTypesScreen: View {
  @StateObject var viewModel = MappingCustomTypesViewModel()
  
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
    SampleScreen("Mapping Simple Types", introduction: "Firestore makes mapping simple data types as simple as possible.") {
      Form {
        Section(header: Text("Book"), footer: messageView) {
          TextField("Title", text: $viewModel.book.title)
          TextField("Number of pages", value: $viewModel.book.numberOfPages, formatter: NumberFormatter())
          TextField("Author", text: $viewModel.book.author)
          NavigationLink(destination: CoverImagesScreen(covers: viewModel.book.cover)) {
            Text("Covers")
          }
        }
        Section(header: Text("Actions")) {
          Button(action: viewModel.fetchAndMap) {
            Label("Fetch and map a book", systemImage: "square.and.arrow.up")
          }
          
          Button(action: viewModel.updateBook) {
            Label("Udpate book", systemImage: "square.and.arrow.down")
          }
          Button(action: viewModel.addBook) {
            Label("Add Book", systemImage: "plus")
          }
        }
      }
    }
  }
}

struct CoverImagesScreen: View {
  var covers: CoverImages?
  var body: some View {
    if let covers = covers {
      List {
        Text(covers.small.absoluteString)
        Text(covers.medium.absoluteString)
        Text(covers.large.absoluteString)
      }
    }
    else {
      Text("This book has no cover images")
    }
  }
}

struct MappingCustomTypesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MappingCustomTypesScreen()
    }
  }
}
