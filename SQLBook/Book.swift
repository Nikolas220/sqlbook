//
//  Book.swift
//  SQLBook
//
//  Created by Nikolas Caceres on 7/16/21.
//

import Foundation

class Book: Identifiable, ObservableObject {
    public var id: Int64 = 0
    public var name: String = ""
    @Published var words: [String] = []
    @Published var definitions: [String] = []
    
}
