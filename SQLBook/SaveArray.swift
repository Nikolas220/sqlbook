//
//  SaveArray.swift
//  SQLBook
//
//  Created by Nikolas Caceres on 7/17/21.
//

import Foundation

class SaveArray: ObservableObject {
    //dummy class that is used so that way an outer function can alter the array that is passed into PickDefinition
    @Published var currentArray: [String] = []
}
