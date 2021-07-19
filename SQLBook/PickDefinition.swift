//
//  PickDefinition.swift
//  SQLBook
//
//  Created by Nikolas Caceres on 7/17/21.
//

import SwiftUI

struct PickDefinition: View {
    
    //This view shows all the options to the user of definitons they can choose from based on the context
    @ObservedObject var definitions: SaveArray
    var book: Book
    var word: String
    @Binding var presentAddingWord: Bool
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(0 ..< definitions.currentArray.count) { index in
                        Button("\(self.definitions.currentArray[index])", action: {
                            print("hello")
                            DB_Manager().addWords(name: self.book.name, word: self.word, definition: self.definitions.currentArray[index])
                            book.definitions.append(self.definitions.currentArray[index])
                            self.presentationMode.wrappedValue.dismiss()
                            presentAddingWord = false

                        })
                    }
                }
            }
//            .onDisappear {
//                presentAddingWord = false
//            }
            .navigationTitle("Choose")
            
        }
    }

}

//
//struct PickDefinition_Previews: PreviewProvider {
//    static var previews: some View {
//        PickDefinition(definitions: SaveArray(), book: Book(), word: "")
//    }
//}
