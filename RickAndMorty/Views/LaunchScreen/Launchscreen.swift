//
//  Launchscreen.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 10/6/23.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController, ActivityIndicatorProtocol {
  
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActivityIndicator(location: .bottom)
        activityIndicatorStart()
        navigateToMainView()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func navigateToMainView() {
        let viewModel = CharacterFactory.makeCharacterViewModel()
        let mainViewController = MainViewController(viewModel: viewModel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.pushViewController(mainViewController, animated: true)
            self.activityIndicatorStop()
        }
    }}
