//
//  NetworkManager.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 09/03/2025.
//

import Foundation
import Moya
import Combine
enum APIService {
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getAlbums:
            return "/albums"
        case .getPhotos:
            return "/photos"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .getAlbums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.default)
        case .getPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}


extension MoyaProvider {
    func fetchData<T: Decodable>(_ target: APIService, responseType: T.Type) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            self.request(target as! Target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                        promise(.success(decodedData))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
