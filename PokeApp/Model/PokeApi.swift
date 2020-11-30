//
//  PokeApi.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import Alamofire

struct PokeApi: URLRequestConvertible {
    var path: String
    var params: [String: Any]?
    var method: HTTPMethod = .get

    var baseURLString: String {
        return "https://pokeapi.co/api/v2/"
    }

    init(_ path: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) {
        self.path = path
        self.method = method
        params = parameters
    }

    func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch method {
        case .post, .put, .delete:
            return try JSONEncoding.default.encode(urlRequest, with: params)
        default:
            return try URLEncoding.default.encode(urlRequest, with: params)
        }
    }
}
