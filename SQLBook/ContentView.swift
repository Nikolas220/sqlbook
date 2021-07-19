//
//  ContentView.swift
//  BookSQL
//
//  Created by Nikolas Caceres on 7/16/21.
//

import SwiftUI

struct ContentView: View {
    @State var addingBook = false
    @State var books: [Book] = []
    @State var showBook = false
    @State var currBook = ""
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(books) { book in
//                        DB_Manager().openBook(name: book.name, book: book)
                        NavigationLink(destination: BookView(book: book), label: {
                            Text("\(book.name)")
                        })
//                        Button("\(book.name)", action: {
//                            self.showBook = true
//                            self.currBook = book.name
//                        })
//                        .sheet(isPresented: $showBook) {
//                            BookView(book: Book())
//                        }
                    }
                    .onDelete(perform: removeRows)
                }
            }
            .onAppear(perform: {
                self.books = DB_Manager().getTitles()
            })
            .navigationBarItems(trailing: NavigationLink(destination: AddBook(), label: {
                Image(systemName: "plus")
            }))
            .navigationBarTitle("Your Books")
//            .navigationBarItems(trailing: Button(action: {
//                self.addingBook = true
//            }) {
//                Image(systemName: "plus")
//            }
//            ).sheet(isPresented: $addingBook) {
//                AddBook()
//            }
//                trailing: Button(action: {
//                self.addingBook = true
//            }) {
//                Image(systemName: "plus")
//            }
//            ).sheet(isPresented: $addingBook) {
//                AddBook()
//            }
        }
    }
    func removeRows(at offsets: IndexSet) {
        //Need to update the database
        for row in offsets {
            DB_Manager().deleteBook(book: books[row])
        }
        
        books.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
