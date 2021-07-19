//
//  AddWord.swift
//  SQLBook
//
//  Created by Nikolas Caceres on 7/16/21.
//

import SwiftUI

import Foundation

let headers = [
    "x-rapidapi-key": "a3f2a2910cmsh25f6d175525afecp12414cjsna354e617750a",
    "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
]

struct AddWord: View {
    @ObservedObject var book: Book
    @Binding var presentingAddingWord: Bool

    @StateObject var currentArray = SaveArray()
    @State var addingDefinition = false
    @State var word = ""
    @State var definition = ""
    @State var allDefinitions: [String] = []

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                TextField("Word: ", text: $word)
            }
            .navigationBarTitle("Add word")
            .navigationBarItems(trailing: Button("Add") {
                if self.word != "" {
                    book.words.append(self.word)

                    getDef(self.word, book, currentArray)
                    addingDefinition = true

//                    print(book.definitions)
//                    print(allDefinitions)
                }
            }).sheet(isPresented: $addingDefinition) {
                
                PickDefinition(definitions: currentArray, book: book, word: self.word, presentAddingWord: $presentingAddingWord)
            }

        }
    }
    func getDef(_ word: String, _ book: Book, _ definitionsArray: SaveArray) {
        //Connect to the API and get the definition
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)") as! URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error)
            } else {
                do {
                    //Parsing the JSON
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                    //getting the dictionary
                    let dict = dictionary?["results"] as? [Any]
                    
                    //Updating the array so it has all the definitions that the API gave to us
                    DispatchQueue.main.async {
                        definitionsArray.currentArray = createArray((dict!))
                    }
//                    print(currentArray.currentArray)
                    //Pass the array to the new view where the user will select the one they want
//                    PickDefinition(definitions: allDef, book: self.book, word: self.word)
                    
                    
                    
//                    print(dict)
//                    print(createArray(dict!))
//                    let dictDef = dict?[0] as? [String: Any]
                    
//                    print(dictDef?["definition"] as! String)
//                    book.definitions.append(dictDef?["definition"] as! String)
//                    DB_Manager().addWords(name: self.book.name, word: self.word, definition: dictDef?["definition"] as! String)
                    //dict is the array of all the dictionaries that have the different definitions
//                    PickDefinition(definitions: dict ?? [Any]())
//
//                    DispatchQueue.main.async {
//                        book.definitions.append(dictDef?["definition"] as! String)
//                    }
//
                }
                catch {
                    print("Error parsing")
                }
            }
        })
    
        dataTask.resume()

    }
    func createArray(_ array: [Any]) -> [String] {
        //Get all the definitions given from the api and put it into a string array so you can display it for user to select the correct definiton for their context
        var definitions = [String]()
        for object in array {
            let dictDef = object as? [String: Any]
            definitions.append(dictDef?["definition"] as! String)
        }
        return definitions
    }
}
//
//struct AddWord_Previews: PreviewProvider {
//    static var previews: some View {
//        AddWord(book: Book(), presentingAddingWord: false)
//    }
//}
