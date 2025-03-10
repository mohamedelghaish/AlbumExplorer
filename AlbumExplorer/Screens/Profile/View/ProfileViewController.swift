//
//  ProfileViewController.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 09/03/2025.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var albumTabelView: UITableView!
    private let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchUserData()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    private func setupUI() {
        albumTabelView.delegate = self
        albumTabelView.dataSource = self
        albumTabelView.registerNib(AlbumCell.self)

    }
        
    private func bindViewModel() {
        viewModel.$user
            .sink { [weak self] user in
                self?.userName.text = user.map { "\($0.name)"}
                self?.userAddress.text = user.map {"\($0.address.city)"}
                if let userId = user?.id {
                    self?.viewModel.fetchAlbums(userId: userId)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$albums
                    .sink { [weak self] albums in
                        DispatchQueue.main.async {
                            self?.albumTabelView.reloadData()
                        }
                    }
                    .store(in: &cancellables)
            }
    }

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AlbumCell.self, for: indexPath)
        cell.albumName?.text = viewModel.albums[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = viewModel.albums[indexPath.row]
        let albumVC = AlbumViewController(albumId: album.id, albumTitle: album.title)
        navigationController?.pushViewController(albumVC, animated: true)
    }

}
