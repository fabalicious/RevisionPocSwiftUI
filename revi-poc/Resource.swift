//
//  Resource.swift
//  revi-poc
//
//  Created by Fabian Knecht on 05.12.2024.
//

import Foundation

struct Resource: Decodable, Identifiable {
    let id: Int //UUID() // Makes it usable in lists
    let message: String    
}
