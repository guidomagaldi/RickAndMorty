//
//  ActivityIndicator.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 8/6/23.
//

import Foundation
import UIKit

protocol ActivityIndicatorProtocol {
    var activityIndicator: UIActivityIndicatorView { get }
    func setupActivityIndicator(location: ActivityIndicatorLocation)
    func activityIndicatorStart()
    func activityIndicatorStop()
}

enum ActivityIndicatorLocation {
    case center
    case bottom
}

extension ActivityIndicatorProtocol where Self: UIViewController {
    func setupActivityIndicator(location: ActivityIndicatorLocation) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        switch location {
        case .center:
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48)
            ])
        }

    }
    
    func activityIndicatorStart() {
        activityIndicator.startAnimating()
    }
    
    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
    }
}
