//
//  AlbumViewModel.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 10/03/2025.
//

import Foundation
import Combine
import Moya

class AlbumViewModel {
    private let apiProvider = MoyaProvider<APIService>()
    @Published var photos: [Photo] = []
    @Published var filteredPhotos: [Photo] = []

    private var cancellables = Set<AnyCancellable>()

//    func fetchPhotos(albumId: Int) {
//        apiProvider.fetchData(.getPhotos(albumId: albumId), responseType: [Photo].self)
//            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] photos in
//                self?.photos = photos
//                self?.filteredPhotos = photos
//                
//            })
//            .store(in: &cancellables)
//    }
    func fetchPhotos(albumId: Int) {
        apiProvider.fetchData(.getPhotos(albumId: albumId), responseType: [Photo].self)
            .receive(on: DispatchQueue.main) // Ensure UI updates on the main thread
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] photos in
                self?.photos = photos
                self?.filteredPhotos = photos
            })
            .store(in: &cancellables)
    }


    func filterPhotos(query: String) {
        filteredPhotos = query.isEmpty ? photos : photos.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
}
