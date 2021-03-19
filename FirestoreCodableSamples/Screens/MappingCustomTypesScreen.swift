//
//  MappingCustomTypesScreen.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 18.03.21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class MappingCustomTypesViewModel: ObservableObject {
  @Published var book: BookWithCoverImages = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  func fetchAndMap() {
    fetchBook(documentId: "hitchhiker-image-urls")
  }
  
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument { document, error in
      if let error = error as NSError? {
        self.errorMessage = "Error getting document: \(error.localizedDescription)"
      }
      else {
        let result = Result { try document?.data(as: BookWithCoverImages.self) }
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
