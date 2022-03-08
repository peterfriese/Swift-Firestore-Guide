//
//  MappingGeoPointsScreen.swift
//  FirestoreCodableSamples
//
//  Created by Peter Friese on 22.03.21.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestoreSwift

struct Office: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var location: GeoPoint
}

extension Office {
  static var empty = Office(name: "", location: GeoPoint(latitude: 0, longitude: 0))
  static var sample = [
    Office(id: "6PS", name: "Google UK, 6 Pancras Square", location: GeoPoint(latitude: 51.5327652, longitude: -0.1272025)),
    Office(id: "googleplex", name: "Googleplex", location: GeoPoint(latitude: 37.4207294, longitude: -122.084954)),
    Office(id: "sfo", name: "Google San Francisco", location: GeoPoint(latitude: 37.7898829, longitude: -122.3915139)),
    Office(id: "ham", name: "Google Hamburg", location: GeoPoint(latitude: 53.553986, longitude: 9.9856482)),
    Office(id: "nyc", name: "Google New York", location: GeoPoint(latitude: 40.7414688, longitude: -74.0033873)),
  ]
}


class MappingGeoPointsViewModel: ObservableObject {
  @Published var offices = Office.sample // [Office]()
  @Published var selectedOffice = Office.sample[0]
  @Published var selectedOfficeCoordinate: CLLocationCoordinate2D?
  @Published var visibleRegion: MKCoordinateRegion!
  @Published var errorMessage: String?
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  init() {
    $selectedOffice
      //      .compactMap { $0 }
      .map { office in
        CLLocationCoordinate2D(latitude: office.location.latitude,
                               longitude: office.location.longitude)
      }
      .assign(to: &$selectedOfficeCoordinate)

    $selectedOfficeCoordinate
      .compactMap { $0 }
      .map { officeCoordinate in
        MKCoordinateRegion(center: officeCoordinate,
                           span: MKCoordinateSpan(
                            latitudeDelta: 0.005,
                            longitudeDelta: 0.005))
      }
      .assign(to: &$visibleRegion)


    
  }
  
  public func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("locations")
        .addSnapshotListener { [weak self] (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            self?.errorMessage = "No documents in the 'locations' collection"
            return
          }
          
          self?.offices = documents.compactMap { queryDocumentSnapshot in
            let result = Result { try queryDocumentSnapshot.data(as: Office.self) }
            
            switch result {
            case .success(let office):
              // An Office value was successfully initialized from the DocumentSnapshot.
              self?.errorMessage = nil
              return office
            case .failure(let error):
              // An Office value could not be initialized from the DocumentSnapshot.
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
}

struct MappingGeoPointsScreen: View {
  @StateObject var viewModel = MappingGeoPointsViewModel()
  
  var body: some View {
    SampleScreen("Mapping Geopoints", introduction: "GeoPoints are supported natively in Firestore") {
      Form {
        Map(coordinateRegion: $viewModel.visibleRegion, annotationItems: viewModel.offices) { office in
          MapPin(coordinate: CLLocationCoordinate2D(latitude: office.location.latitude, longitude: office.location.longitude), tint: .red)
        }
        .frame(height: 300)
        Section(header: Text("Google Offices")) {
          List(viewModel.offices) { office in
            VStack(alignment: .leading) {
              Text(office.name)
              Text("Lat: \(office.location.latitude), Lon: \(office.location.longitude)")
            }
            .onTapGesture {
              viewModel.selectedOffice = office
            }
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

struct MappingGeoPointsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MappingGeoPointsScreen()
    }
  }
}
