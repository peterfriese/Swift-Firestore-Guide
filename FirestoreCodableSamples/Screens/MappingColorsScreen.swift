//
//  MappingColorsSCreen.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 19.03.21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ColorEntry: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var color: Color
}

extension ColorEntry {
  static var empty = ColorEntry(name: "", color: Color.red)
  static var sample = [
    ColorEntry(id: "red", name: "Red", color: .red),
    ColorEntry(id: "cerise", name: "Cerise", color: Color(hex: "#d52c67"))
  ]
}

class MappingColorsScreenViewModel: ObservableObject {
  @Published var colorEntries = ColorEntry.sample //[ColorEntry]()
  @Published var newColor = ColorEntry.empty
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
      listenerRegistration = db.collection("colors")
        .addSnapshotListener { [weak self] (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            self?.errorMessage = "No documents in 'colors' collection"
            return
          }
          
          self?.colorEntries = documents.compactMap { queryDocumentSnapshot in
            let result = Result { try queryDocumentSnapshot.data(as: ColorEntry.self) }
            
            switch result {
            case .success(let colorEntry):
              if let colorEntry = colorEntry {
                // A ColorEntry value was successfully initialized from the DocumentSnapshot.
                self?.errorMessage = nil
                return colorEntry
              }
              else {
                // A nil value was successfully initialized from the DocumentSnapshot,
                // or the DocumentSnapshot was nil.
                self?.errorMessage = "Document doesn't exist."
                return nil
              }
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
  
  func addColorEntry() {
    let collectionRef = db.collection("colors")
    do {
      let newDocReference = try collectionRef.addDocument(from: newColor)
      print("ColorEntry stored with new document reference: \(newDocReference)")
    }
    catch {
      print(error)
    }
  }
}

struct MappingColorsScreen: View {
  @StateObject var viewModel = MappingColorsScreenViewModel()
  
  var body: some View {
    SampleScreen("Mapping Colors", introduction: "Mapping colors is easy once we conform Color to Codable.") {
      Form {
        Section(header: Text("Colors")) {
          List(viewModel.colorEntries) { colorEntry in
            Text("\(colorEntry.name) (\(colorEntry.color.toHex ?? ""))")
              .listRowBackground(colorEntry.color)
              .foregroundColor(colorEntry.color.accessibleFontColor)
              .padding(.horizontal, 4)
              .padding(.vertical, 2)
              .background(colorEntry.color)
              .cornerRadius(3.0)
          }
        }
        Section {
          ColorPicker(selection: $viewModel.newColor.color) {
            Label("First, pick color", systemImage: "paintpalette")
          }
          Button(action: viewModel.addColorEntry ) {
            Label("Then add it", systemImage: "plus")
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

struct MappingColorsScreen_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        MappingColorsScreen()
      }
      NavigationView {
        MappingColorsScreen()
      }
      .preferredColorScheme(.dark)
    }
  }
}
