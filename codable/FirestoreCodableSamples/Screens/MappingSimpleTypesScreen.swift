//
// MappingSimpleTypesScreen.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 17.03.21.
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

class MappingSimpleTypesViewModel: ObservableObject {
  @Published var book: Book = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  /// Use this to alteratively use async/await or callback-based implementations
  let useAsync = false
  
  fileprivate func fetchAndMap() {
    if useAsync {
      Task {
        await fetchBookAsync(documentId: "hitchhiker")
      }
    }
    else {
      fetchBook(documentId: "hitchhiker")
    }
  }
  
  fileprivate func fetchAndMapNonExisting() {
    if useAsync {
      Task {
        await fetchBookAsync(documentId: "does-not-exist")
      }
    }
    else {
      fetchBook(documentId: "does-not-exist")
    }
  }
  
  fileprivate func fetchAndTryMappingInvalidData() {
    if useAsync {
      Task {
        await fetchBookAsync(documentId: "invalid-data")
      }
    }
    else {
      fetchBook(documentId: "invalid-data")
    }
  }
  
  /// Alternative implementation that shows how to use async/await to call `getDocument`
  /// This needs to be marked as @MainActor so that we can safely access the errorMessage
  /// published property when encountering an error.
  @MainActor
  private func fetchBookAsync(documentId: String) async {
    let docRef = db.collection("books").document(documentId)
    do {
      self.book = try await docRef.getDocument(as: Book.self)
    }
    catch {
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
  
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument(as: Book.self) { result in
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
  
  private func fetchBookOptional(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    // If you expect that a document might *not exist*, use an optional type (Book?.self)
    // and then perform an `if let book = book` dance to handle this case.
    docRef.getDocument(as: Book?.self) { result in
      switch result {
      case .success(let book):
        if let book = book {
          // A Book value was successfully initialized from the DocumentSnapshot.
          self.book = book
          self.errorMessage = nil
        }
        else {
          // A nil value was successfully initialized from the DocumentSnapshot,
          // or the DocumentSnapshot was nil.
          self.errorMessage = "Document doesn't exist."
        }
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

struct MappingSimpleTypesScreen: View {
  @StateObject var viewModel = MappingSimpleTypesViewModel()
  
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
        }
        Section(header: Text("Actions")) {
          Button(action: viewModel.fetchAndMap) {
            Label("Fetch and map a book", systemImage: "square.and.arrow.up")
          }
          Button(action: viewModel.fetchAndMapNonExisting) {
            Label("Fetch and map a non-existing book", systemImage: "square.and.arrow.up")
          }
          Button(action: viewModel.fetchAndTryMappingInvalidData) {
            Label("Try mapping book from invalid data", systemImage: "square.and.arrow.up")
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

struct MappingSimpleTypesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MappingSimpleTypesScreen()
    }
  }
}
