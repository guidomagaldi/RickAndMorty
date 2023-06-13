//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 6/6/23.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var dataSource: [CharacterData]?
    private var filteredData = [String]()
    private var isSearchActive = false
    private var isLoadingData = false
    private var searchTimer: Timer?
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    var viewModel: CharacterViewModelProtocol?
    
    // MARK: - Initialization
    
    init(viewModel: CharacterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStackView()
        setupSearchBar()
        setupTableView()
        setupActivityIndicator(location: .center)
        activityIndicatorStart()
        viewModel?.getCharacters(resetPage: false)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "app_title".localized
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        stackView.addArrangedSubview(tableView)
    }
    
    private func setupSearchBar() {
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(searchBar)
    }
    
    private func bindViewModel() {
        self.viewModel?.onDataChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorStop()
                self?.tableView.reloadData()
                self?.isSearchActive = false
            }
        }
        
        self.viewModel?.onMoreDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorStop()
                self?.isLoadingData = false
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.characters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            fatalError("Unable to dequeue CharacterTableViewCell")
        }
        if let character = viewModel?.characters[indexPath.row], let viewModel = viewModel {
            cell.setupCell(character: character, viewModel: viewModel)
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let characters = viewModel?.characters else { return }
        
        // Check if the last cell is being displayed and if there are more characters to load
        if indexPath.row == characters.count - 1 && !isSearchActive && !isLoadingData {
            isLoadingData = true
            isSearchActive = true
            
            // Load additional characters
            viewModel?.loadMoreCharacters()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let character = viewModel?.characters[indexPath.row] else { return }
        
        if let viewModel = viewModel {
            let detailViewController = DetailViewController(character: character, viewModel: viewModel)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          // Invalidate existing timer
          searchTimer?.invalidate()
          
          // Initialize a new timer
          searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
              self?.performSearch(searchText: searchText)
          }
      }
    
    private func performSearch(searchText: String) {
         if isSearchActive {
             return
         }
         
         activityIndicatorStart()
         
         if searchText.isEmpty {
             viewModel?.getCharacters(resetPage: true)
             isSearchActive = false

         } else {
             viewModel?.fetchSearchResults(query: searchText)
             isSearchActive = true
         }
     }
    
}

// MARK: - ActivityIndicatorProtocol

extension MainViewController: ActivityIndicatorProtocol {}
