//
//  MappingArraysWithNestedTypes.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 18.03.21.
//

import SwiftUI

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class MappingArraysWithNestedTypesViewModel: ObservableObject {
  @Published var book: BookWithTags = .empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  
  func fetchAndMap() {
    fetchBook(documentId: "hitchhiker-tags")
  }
  
  private func fetchBook(documentId: String) {
    let docRef = db.collection("books").document(documentId)
    
    docRef.getDocument(as: BookWithTags.self) { result in
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
  
  private var tags: Set = [
    Tag(title: "Space", color: Color(hex: "#131a2d")),
    Tag(title: "Tea", color: Color(hex: "#d8bfbf")),
    Tag(title: "Improbability", color: Color(hex: "#fd1d48")),
  ]

  func addTag() {
    let unusedTags = self.tags.subtracting(book.tags)
    if let tag = unusedTags.first {
      self.book.tags.append(tag)
    }
  }
}

struct MappingArraysWithNestedTypesScreen: View {
  @StateObject var viewModel = MappingArraysWithNestedTypesViewModel()
  
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
        Section(header: Text("Tags")) {
          List(viewModel.book.tags, id: \.self) { tag in
            Text(tag.title)
              .foregroundColor(tag.color.accessibleFontColor)
              .padding(.horizontal, 4)
              .padding(.vertical, 2)
              .background(tag.color)
              .cornerRadius(3.0)
          }
          Button(action: viewModel.addTag) {
            Label("Add a tag", systemImage: "plus")
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

struct MappingArraysWithNestedTypesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MappingArraysWithNestedTypesScreen()
    }
  }
}

