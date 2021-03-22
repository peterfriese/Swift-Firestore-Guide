//
//  MappingEnumsScreen.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 22.03.21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

enum Status: String, CaseIterable, Codable {
  case draft
  case inReview = "in review"
  case approved
  case published
}

extension Status {
  var color: Color {
    switch self {
    case .draft:
      return Color.red
    case .inReview:
      return Color.yellow
    case.approved:
      return Color.green
    case .published:
      return Color.blue
    }
  }
}

struct Article: Identifiable, Codable {
  @DocumentID var id: String?
  var title: String
  var status: Status
}

extension Article {
  static let empty = Article(title: "", status: .draft)
  static let sample = [
    Article(id: "codable", title: "Mapping Firestore Data in Swift - The Comprehensive Guide", status: Status.draft),
    Article(id: "lifecycle", title: "Firebase and the new SwiftUI 2 Application Life Cycle", status: Status.approved),
    Article(id: "drill-down", title: "SwiftUI Drill-down Navigation", status: .draft),
    Article(id: "asyncawait", title: "Using async/await in SwiftUI", status: .published),
  ]
}

class MappingEnumsViewModel: ObservableObject {
  @Published var articles = Article.sample // [Article]()
  @Published var newArticle = Article.empty
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  public func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
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
              if let article = article {
                // An Article value was successfully initialized from the DocumentSnapshot.
                self?.errorMessage = nil
                return article
              }
              else {
                // A nil value was successfully initialized from the DocumentSnapshot,
                // or the DocumentSnapshot was nil.
                self?.errorMessage = "Document doesn't exist."
                return nil
              }
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
  
  func addArticle() {
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
