//
// CustomizeMappingScreen.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 19.03.21.
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

class CustomizeMappingViewModel: ObservableObject {
  @Published var programmingLanguages = ProgrammingLanguage.sample // [ProgrammingLanguage]()
  @Published var newLanguage = ProgrammingLanguage.empty
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
      listenerRegistration = db.collection("programming-languages")
        .addSnapshotListener { [weak self] (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            self?.errorMessage = "No documents in 'programming-languages' collection"
            return
          }
          
          self?.programmingLanguages = documents.compactMap { queryDocumentSnapshot in
            let result = Result { try queryDocumentSnapshot.data(as: ProgrammingLanguage.self) }
            
            switch result {
            case .success(let programmingLanguage):
              // A ProgrammingLanguage value was successfully initialized from the DocumentSnapshot.
              self?.errorMessage = nil
              return programmingLanguage
            case .failure(let error):
              // A Book value could not be initialized from the DocumentSnapshot.
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
  
  fileprivate func addLanguage() {
    let collectionRef = db.collection("programming-languages")
    do {
      let newDocReference = try collectionRef.addDocument(from: newLanguage)
      print("ProgrammingLanguage stored with new document reference: \(newDocReference)")
    }
    catch {
      print(error)
    }
  }
}

struct CustomizeMappingScreen: View {
  @StateObject var viewModel = CustomizeMappingViewModel()
  
  var body: some View {
    SampleScreen("Customize Mapping", introduction: "We can use Codable's CodingKeys to customize Firestore's mapping") {
      Form {
        Section(header: Text("Programming Languages")) {
          List(viewModel.programmingLanguages) { language in
            HStack {
              Text(language.name)
              Spacer()
              Text("Released: \(language.yearAsString)")
                .font(.caption)
            }
          }
        }
        Section {
          TextField("Language name", text: $viewModel.newLanguage.name)
          TextField("Reason I love this", text: $viewModel.newLanguage.reasonWhyILoveThis)
          DatePicker("Date of release", selection: $viewModel.newLanguage.year, displayedComponents: [.date])
          Button(action: viewModel.addLanguage ) {
            Label("Add new language", systemImage: "plus")
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

struct CustomizeMappingScreen_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        CustomizeMappingScreen()
      }
      NavigationView {
        CustomizeMappingScreen()
      }
      .preferredColorScheme(.dark)
    }
  }
}
