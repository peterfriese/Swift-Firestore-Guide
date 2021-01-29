//
//  FirestoreService.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 29.01.21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class BookViewModel: ObservableObject {
  @Published var book: Book?
  
  private var db = Firestore.firestore()
  
  func fetchBook() {
    let docRef = db.collection("books").document("hitchhiker")
    
    docRef.getDocument { document, error in
      let result = Result { try document?.data(as: Book.self) }
      switch result {
      case .success(let book):
        if let book = book {
          // A Book value was successfully initialized from the DocumentSnapshot.
          self.book = book
        }
        else {
          // A nil value was successfully initialized from the DocumentSnapshot,
          // or the DocumentSnapshot was nil.
          print("Document doesn't exist ")
        }
      case .failure(let error):
        // A Book value could not be initialized from the DocumentSnapshot.
        print("Error decoding city: \(error.localizedDescription)")
      }
    }
  }
  
}
