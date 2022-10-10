//
// MappingArraysSCreen.swift
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

class MappingArraysViewModel: ObservableObject {
  @Published var book: BookWithGenre = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  fileprivate func fetchAndMap() {
    fetchBook(documentId: "hitchhiker-genre")
  }
  
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument(as: BookWithGenre.self) { result in
      switch result {
      case .success(let book):
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
  
  func newBook() {
    self.book = .empty
  }
  
  private var genres: Set = ["Action", "Fantasy", "Fairy Tale"]
  
  func addGenre() {
    let unusedGenres = self.genres.subtracting(book.genres)
    if let genre = unusedGenres.first {
      self.book.genres.append(genre)
    }
  }
}

struct MappingArraysScreen: View {
  @StateObject var viewModel = MappingArraysViewModel()
  
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
    SampleScreen("Mapping Arrays", introduction: "Firestore makes mapping arrays easy.") {
      Form {
        Section(header: Text("Book"), footer: messageView) {
          TextField("Title", text: $viewModel.book.title)
          TextField("Number of pages", value: $viewModel.book.numberOfPages, formatter: NumberFormatter())
          TextField("Author", text: $viewModel.book.author)
        }
        Section(header: Text("Genres")) {
          List(viewModel.book.genres, id: \.self) { genre in
            Text(genre)
          }
          Button(action: viewModel.addGenre) {
            Label("Add a genre", systemImage: "plus")
          }
        }
        Section(header: Text("Actions")) {
          Button(action: viewModel.fetchAndMap) {
            Label("Fetch and map a book", systemImage: "square.and.arrow.up")
          }
          
          Button(action: viewModel.updateBook) {
            Label("Udpate book", systemImage: "square.and.arrow.down")
          }
          Button(action: viewModel.newBook) {
            Label("New Book", systemImage: "sparkles")
          }
          Button(action: viewModel.addBook) {
            Label("Add Book", systemImage: "plus")
          }
        }
      }
    }
  }
}

struct MappingArraysScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MappingArraysScreen()
    }
  }
}
