//
//  MappingArraysSCreen.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 18.03.21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class MappingArraysViewModel: ObservableObject {
  @Published var book: BookWithGenre = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  func fetchAndMap() {
    fetchBook(documentId: "hitchhiker-genre")
  }
  
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument { document, error in
      if let error = error as NSError? {
        self.errorMessage = "Error getting document: \(error.localizedDescription)"
      }
      else {
        let result = Result { try document?.data(as: BookWithGenre.self) }
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
  }
  
  func updateBook() {
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
  
  func addBook() {
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
