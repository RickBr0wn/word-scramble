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
  
  @State private var errorTitle = ""
  @State private var errorMessage = ""
  @State private var showingError = false
  
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
      .onAppear(perform: startGame)
      .alert(isPresented: $showingError) {
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    }
  }

  func addNewWord() {
    /// Format and store the new word as a variable.
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    /// Handle the case where new word is an empty string.
    guard answer.count > 0 else {
      return
    }
    
    guard isOriginal(word: answer) else {
      wordError(title: "Word already used!", message: "Try to be more original.")
      return
    }
    
    guard isPossible(word: answer) else {
      wordError(title: "Word not recognised!", message: "You can't just make words up you know!")
      return
    }
    
    guard isReal(word: answer) else {
      wordError(title: "Word not possible!", message: "That isn't a real word.")
      return
    }
    
    /// Add the formatted new word to the usedWords array.
    usedWords.insert(answer, at: 0)
    /// Reset the new word.
    newWord = ""
  }
  
  func startGame() {
    /// Create and store a URL pointing to the file that is required from the bundle.
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      /// If the file is not there, this code will not run. Its purpose is to confirm that the file does exist in the bundle, and then create the string which will contain the contents of the file.
      if let startWords = try? String(contentsOf: startWordsURL) {
        /// If the code gets this far, we now have a long string of text, in this example separated with a new line.
        /// The string is then broken down into an array, separated by \n
        let allWords = startWords.components(separatedBy: "\n")
        /// Set rootWord to a random element in the array. Using nil coalecing to protect from an emprty element.
        rootWord = allWords.randomElement() ?? "silkworm"
        /// All completed, just return
        return
      }
    }
    /// If this code is reached, something has gone wrong during the aquisition of the file.
    fatalError("Could not load start.txt from the Bundle.")
  }
  
  func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }
  
  func isPossible(word: String) -> Bool {
    var tempWord = rootWord.lowercased()
    
    for letter in word {
      if let position = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: position)
      } else {
        return false
      }
    }
    return true
  }
  
  func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  func wordError(title: String, message: String) {
    errorTitle = title
    errorMessage = message
    showingError = true
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
