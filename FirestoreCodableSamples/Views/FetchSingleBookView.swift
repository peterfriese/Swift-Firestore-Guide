//
//  ContentView.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 29.01.21.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = BookViewModel()
  
  var body: some View {
    VStack {
      Button(action: fetchBook) {
        Text("Fetch Book")
      }
      if let book = viewModel.book {
        VStack {
          Text(book.title)
          Text("\(book.numberOfPages)")
          Text(book.author)
        }
      }
      else {
        Text("(No book fetched yet)")
      }
    }
  }
  
  func fetchBook() {
    viewModel.fetchBook()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
