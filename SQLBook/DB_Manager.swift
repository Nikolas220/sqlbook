//
//  DB_Manager.swift
//  BookSQL
//
//  Created by Nikolas Caceres on 7/16/21.
//

import Foundation


import SQLite

class DB_Manager {
    private var db: Connection!
    
    private var books: Table!
    private var id: Expression<Int64>!
    private var title: Expression<String>!
    
    
    init() {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            db = try Connection("\(path)/my_users.sqlite3")
            books = Table("books")
            
            id = Expression<Int64>("id")
            title = Expression<String>("title")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                try db.run(books.create {
                    (t) in
                    t.column(id, primaryKey: true)
                    t.column(title)
                })
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addBook(name: String) {
        do {
            try db.run(books.insert(title <- name))
        } catch {
            print("hello")
            print(error.localizedDescription)
        }
    }
    public func getTitles() -> [Book] {
        var titles: [Book] = []
        
        books = books.order(id.asc)
        do {
            for book in try db.prepare(books) {
                let tempBook: Book = Book()
                tempBook.id = book[id]
                print(book[id])
                tempBook.name = book[title]
                titles.append(tempBook)
            }
        } catch {
            print(error.localizedDescription)
        }
        return titles
    }
    
    public func openBook(name: String, book: Book) {
        var currentBook = Table(name)
        let ids = Expression<Int64>("id")
        let definitions = Expression<String>("title")
        let words = Expression<String>("words")
        
        var wordsArray: [String] = []
        var definitionsArray: [String] = []
        do {
            try db.run(currentBook.create(ifNotExists:true) { t in
                t.column(ids, primaryKey: true)
                t.column(words)
                t.column(definitions)
            })
        } catch {
            print("hello")
        }
        currentBook = currentBook.order(id.asc)
        do {
            for data in try db.prepare(currentBook) {
                wordsArray.append(data[words])
                definitionsArray.append(data[definitions])
            }
        } catch {
            print("hello")
        }
        book.definitions = definitionsArray
        book.words = wordsArray
//        var returningBook = Book()
//        returningBook.name = name
//        returningBook.definitions = definitionsArray
//        returningBook.words = wordsArray
//        return returningBook
    }
    
    public func addWords(name: String, word: String, definition: String) {
        var currentBook = Table(name)
        let ids = Expression<Int64>("id")
        let definitions = Expression<String>("title")
        let words = Expression<String>("words")
        
        do {
            try db.run(currentBook.insert(words <- word, definitions <- definition))
        } catch {
            print("hello")
            print(error.localizedDescription)
        }
    }
    public func deleteBook(book: Book) {
        let deletingBook = books.filter(id == book.id)
//        try db.run(deletingBook.delete())
        do {
            if try db.run(deletingBook.delete()) > 0 {
                var deletingTable = Table(book.name)
                do {
                    try db.run(deletingTable.drop(ifExists: true))
                } catch {
                    print("not found")
                }
            } else {
                print("book not found")
            }
        } catch {
            print("delete failed")
        }
        
    }
}
