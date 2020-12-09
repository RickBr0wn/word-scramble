//
//  ContentView.swift
//  WordScramble
//
//  Created by Rick Brown on 08/12/2020.
//

import SwiftUI

struct ContentView: View {
  @State private var usedWords = [String]()
  @State private var rootWord = ""
  @State private var newWord = ""
  
  var body: some View {
    NavigationView {
      VStack {
        TextField("Enter your word", text: $newWord, onCommit: addNewWord)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
          .padding()
        
        List(usedWords, id: \.self) {
          Image(systemName: "\($0.count).circle")
          Text($0)
        }
      }
      .navigationBarTitle(rootWord)
    }
  }
  
  func addNewWord() {
    /// Format and store the new word as a variable.
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    /// Handle the case where new word is an empty string.
    guard answer.count > 0 else {
      return
    }
    /// Add the formatted new word to the usedWords array.
    usedWords.insert(answer, at: 0)
    /// Reset the new word.
    newWord = ""
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
