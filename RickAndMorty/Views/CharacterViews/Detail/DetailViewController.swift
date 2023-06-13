//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 9/6/23.
//

import UIKit

class DetailViewController: UIViewController {
    private let character: CharacterData
    private let viewModel: CharacterViewModelProtocol
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
        imageView.layer.insertSublayer(gradientLayer, at: 0)
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = character.name
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 2
        label.text = "Species: \(character.species ?? "")"
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 2
        label.text = "Status: \(character.status ?? "")"
        return label
    }()
    
    private lazy var originLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 2
        label.text = "Origin: \(character.origin?.name ?? "")"
        return label
    }()
    
    init(character: CharacterData, viewModel: CharacterViewModelProtocol) {
        self.character = character
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.setNavigationBarHidden(false, animated: false)
        animateTitleLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        loadImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(speciesLabel)
        view.addSubview(statusLabel)
        view.addSubview(originLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            speciesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speciesLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 8),
            
            originLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            originLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            originLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    private func loadImage() {
        if let imageUrl = character.image {
            viewModel.fetchImage(urlString: imageUrl) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
    
    private func animateTitleLabel() {
        titleLabel.alpha = 0.0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1.0
            self.titleLabel.transform = .identity
        }, completion: nil)
    }
}
