//
//  Extensions.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 10/03/2025.
//

import Foundation
import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        cell.selectionStyle = .none
        
        return cell
    }
    func registerNib<T: UITableViewCell>(_: T.Type) {
        let name = String(describing: T.self)
        register(UINib(nibName: name, bundle: Bundle(for: T.self)), forCellReuseIdentifier: name)
    }
}


extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        let name = String(describing: T.self)
        register(UINib(nibName: name, bundle: Bundle(for: T.self)), forCellWithReuseIdentifier: name)
    }
    
    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                             for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        
        return cell
    }
}
