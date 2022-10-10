//
// MappingEnumsScreen.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 22.03.21.
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



class MappingEnumsViewModel: ObservableObject {
  @Published var articles = Article.sample // [Article]()
  @Published var newArticle = Article.empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  fileprivate  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  fileprivate func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("articles")
        .addSnapshotListener { [weak self] (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            self?.errorMessage = "No documents in 'articles' collection"
            return
          }
          
          self?.articles = documents.compactMap { queryDocumentSnapshot in
            let result = Result { try queryDocumentSnapshot.data(as: Article.self) }
            
            switch result {
            case .success(let article):
              // An Article value was successfully initialized from the DocumentSnapshot.
              self?.errorMessage = nil
              return article
            case .failure(let error):
              // An Article value could not be initialized from the DocumentSnapshot.
              switch error {
              case DecodingError.typeMismatch(_, let context):
                self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
              case DecodingError.valueNotFound(_, let context):
                self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
              case DecodingError.keyNotFound(_, let context):
                self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
              case DecodingError.dataCorrupted(let key):
                self?.errorMessage = "\(error.localizedDescription): \(key)"
              default:
                self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
              }
              return nil
            }
          }
        }
    }
  }
  
  fileprivate func addArticle() {
    let collectionRef = db.collection("articles")
    do {
      let newDocReference = try collectionRef.addDocument(from: newArticle)
      print("Article stored with new document reference: \(newDocReference)")
    }
    catch {
      print(error)
    }
  }
}

struct MappingEnumsScreen: View {
  @StateObject var viewModel = MappingEnumsViewModel()
  
  var body: some View {
    SampleScreen("Mapping Enums", introduction: "Enums can be mapped easily if their elements are codable") {
      Form {
        Section(header: Text("Articles")) {
          List(viewModel.articles) { article in
            VStack(alignment: .leading) {
              Text(article.title)
              Text("Status: \(article.status.rawValue)")
                .foregroundColor(article.status.color.accessibleFontColor)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(article.status.color)
                .cornerRadius(3.0)
            }
          }
        }
        Section {
          TextField("Title", text: $viewModel.newArticle.title)
          Picker("Status", selection: $viewModel.newArticle.status) {
            ForEach(Status.allCases, id: \.self) { status in
              Text(status.rawValue)
            }
          }
          Button(action: viewModel.addArticle ) {
            Label("Add new article", systemImage: "plus")
          }
        }
      }
    }
    .onAppear() {
      viewModel.subscribe()
    }
    .onDisappear() {
      viewModel.unsubscribe()
    }
  }
}

struct MappingEnumsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MappingEnumsScreen()
    }
  }
}
