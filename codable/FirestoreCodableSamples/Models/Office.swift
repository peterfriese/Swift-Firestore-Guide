//
// Office.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 10.10.22.
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

import Foundation
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
