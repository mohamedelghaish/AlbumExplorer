//
//  ProfileViewModel.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 09/03/2025.
//

import Foundation
import Combine
import Moya

class ProfileViewModel {
    private let apiProvider = MoyaProvider<APIService>()
    @Published var user: User?
    @Published var albums: [Album] = []
    
    func fetchUserData() {
        apiProvider.fetchData(.getUsers, responseType: [User].self)
            .map { $0.randomElement() }
            .replaceError(with: nil)
            .assign(to: &$user)
    }
    
    func fetchAlbums(userId: Int) {
        apiProvider.fetchData(.getAlbums(userId: userId), responseType: [Album].self)
            .replaceError(with: [])
            .assign(to: &$albums)
    }
}
