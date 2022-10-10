//
// Color+FontColor.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 19.03.21.
// 
// This code is from Apple's ScrumDinger tutorial.
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

extension Color {
  // MARK: - font colors
  /// This color is either black or white, whichever is more accessible when viewed against the scrum color.
  var accessibleFontColor: Color {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
    return isLightColor(red: red, green: green, blue: blue) ? .black : .white
  }
  
  private func isLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
    let lightRed = red > 0.65
    let lightGreen = green > 0.65
    let lightBlue = blue > 0.65
    
    let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
    return lightness >= 2
  }
}
