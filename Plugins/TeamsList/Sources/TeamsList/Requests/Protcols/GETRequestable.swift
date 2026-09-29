//
//  GETRequestable.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import Foundation

protocol GETRequestable {
  associatedtype ResponseType: Decodable
  
  var url: URL { get }
  func execute() async throws -> ResponseType
}

extension GETRequestable {
    func execute() async throws -> ResponseType {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FetchTeamsListError.serverError
        }

        let decodedResponse = try JSONDecoder().decode(ResponseType.self, from: data)
        return decodedResponse
    }
}
