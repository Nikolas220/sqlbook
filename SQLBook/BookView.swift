//
//  BookView.swift
//  LearnBook
//
//  Created by Nikolas Caceres on 7/8/21.
//

import SwiftUI

struct BookView: View {
    @ObservedObject var book: Book
    @State var addingWord = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            //Displays all the words and the definitions of a certain book
            List(Array(zip(book.words, book.definitions)), id: \.self.0) { (word, definition) in
                Text("\(word) - \(definition)")
            }
        }
        .onAppear(perform: {
            DB_Manager().openBook(name: book.name, book: self.book)
        })
        .navigationBarTitle("\(book.name)")
//        .navigationBarItems(trailing: NavigationLink(destination: AddWord(book: self.book), label: {
//            Image(systemName: "plus")
//        }))
        .navigationBarItems(trailing: Button(action: {
            self.addingWord = true
        }) {
            Image(systemName: "plus")
        }
        ).sheet(isPresented: $addingWord) {
            AddWord(book: self.book, presentingAddingWord: $addingWord)
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: Book())
    }
}
