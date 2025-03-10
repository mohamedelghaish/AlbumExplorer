//
//  AlbumViewController.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 10/03/2025.
//

import UIKit
import Combine

class AlbumViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let albumId: Int
    private let albumTitle: String
    private let viewModel = AlbumViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init(albumId: Int, albumTitle: String) {
        self.albumId = albumId
        self.albumTitle = albumTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = albumTitle
        setupUI()
        bindViewModel()
        viewModel.fetchPhotos(albumId: albumId)
    }

    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(PhotoCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
        searchBar.delegate = self
        searchBar.placeholder = "Search in images.."
    }
    private func bindViewModel() {
        viewModel.$filteredPhotos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalWidth(0.5)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.5)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 1, bottom: 0, trailing: 1)
                
                return section
            
        }
    }

}

extension AlbumViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PhotoCell.self, for: indexPath)
        cell.configure(with: viewModel.filteredPhotos[indexPath.row])
        return cell
    }
}

extension AlbumViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterPhotos(query: searchText)
    }
}

