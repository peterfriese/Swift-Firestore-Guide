//
// Introduction.swift
// FirestoreCodableSamples
//
// Created by Peter Friese on 17.03.21.
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

struct SampleScreen<Content: View>: View {
  var title: String
  var introduction: Text
  var content: () -> Content
  
  init(_ title: String, introduction: String, @ViewBuilder content: @escaping () -> Content) {
    self.title = title
    self.introduction = Text(introduction)
    self.content = content
  }
  
  init(_ title: String, _ introduction: Text, @ViewBuilder content: @escaping () -> Content) {
    self.title = title
    self.introduction = introduction
    self.content = content
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      introduction
        .font(.subheadline)
        .foregroundColor(Color(UIColor.secondaryLabel))
        .padding()
      content()
    }
    .navigationBarTitle(title)
  }
}

struct SampleScreen_Previews: PreviewProvider {
  static let multiLineIntro =
    """
This is a multiline string
Just checking out
Third line.
"""
  static var previews: some View {
    NavigationView {
      SampleScreen("Demo",
                   introduction: multiLineIntro
      ) {
        List {
          Text("Sample")
        }
      }
    }
    .previewLayout(.sizeThatFits)
  }
}
