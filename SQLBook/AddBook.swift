//
//  AddBook.swift
//  BookSQL
//
//  Created by Nikolas Caceres on 7/16/21.
//

import SwiftUI

struct AddBook: View {
//    @ObservedObject var library: Library
    @State var name = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        Form {
            TextField("Title: ", text: $name)
        }
        Button(action: {
            DB_Manager().addBook(name: self.name)
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Add Book")
        })
//            .navigationBarTitle("Add Book")
//            .navigationBarItems(trailing: Button("Save") {
//                if self.name != " " {
//                    DB_Manager().addBook(name: self.name)
//                    self.presentationMode.wrappedValue.dismiss()
//                }
//            })
        
    }
    
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
    }
}
