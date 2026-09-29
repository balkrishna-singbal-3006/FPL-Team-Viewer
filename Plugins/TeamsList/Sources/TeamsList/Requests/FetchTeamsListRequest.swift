//
//  FetchTeamsService.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import Foundation

enum FetchTeamsListError: Error {
    case serverError
}

class FetchTeamsListRequest: GETRequestable {
    typealias ResponseType = TeamsListResponse
    
    private static let endpoint: String = "https://fantasy.premierleague.com/api/bootstrap-static/"
    
    var url: URL {
        URL(string: FetchTeamsListRequest.endpoint)!
    }
}
