//
//  NetworkManager.swift
//  revi-poc
//
//  Created by Fabian Knecht on 05.12.2024.
//

import Foundation

func getResource(from url: URL) async throws -> [Resource] {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Validate the HTTP response
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    guard (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.resourceUnavailable)
    }
    
    // Validate content type
    if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type")?.lowercased(),
       !contentType.contains("application/json") {
        throw URLError(.cannotDecodeContentData)
    }
    
    // Debugging: Print raw JSON for inspection
    if let jsonString = String(data: data, encoding: .utf8) {
        print("Response JSON: \(jsonString)")
    }
    
    // Decode JSON into Resource
    //return try JSONDecoder().decode(Resource.self, from: data)
    
    // Decode JSON
    do {
        let decodedData = try JSONDecoder().decode([Resource].self, from: data)
        return decodedData
    } catch {
        print("Decoding Error: \(error)")
        throw error
    }
}
