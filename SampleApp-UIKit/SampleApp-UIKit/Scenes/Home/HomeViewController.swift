//
//  HomeViewController.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//


import UIKit

protocol HomeDisplayLogic: AnyObject {
    func display(totalResults: Int, totalPages: Int, viewModel: Home.Fetch.ViewModel)
}

final class HomeViewController: BaseViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    var totalResults: Int?
    var totalPages: Int?
    var currentPage: Int = 1
    var tableContent: [SearchResult] = []
    fileprivate var currentQuery: String?
    
    // MARK: UI
    
    private lazy var tableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false

         return tableView
     }()
    
    private lazy var searchBarController: UISearchController = {
        let searchBarController = UISearchController(searchResultsController: nil)
        return searchBarController
    }()

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: Setup methods

    private func setupView() {
        title = NSLocalizedString("search_title", comment: "")
        view.backgroundColor = .white
        let barButton = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(openFavorites))
        barButton.tintColor = .black
        navigationItem.rightBarButtonItem = barButton
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        navigationItem.searchController = searchBarController
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
        
        view.addSubview(tableView)
    }
    
    @objc private func openFavorites() {
        guard let router = router else { return }
        router.routeToFavorites(source: self)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
  
    // MARK: Fetch and display methods
    
    private func fetch(query: String) {
        showLoadingIndicator()
        interactor?.fetch(query: query, page: self.currentPage)
    }
    
    func display(totalResults: Int, totalPages: Int, viewModel: Home.Fetch.ViewModel) {
        if let error = viewModel.error {
            DispatchQueue.main.async {
                self.presentErrorAlert(error: error)
                self.hideLoadingIndicator()
            }
            return
        } else if let results = viewModel.results {
            self.totalResults = totalResults
            self.totalPages = totalPages
            self.tableContent.append(contentsOf: results)
            self.currentPage += 1
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideLoadingIndicator()
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let query = searchBar.text else { return }
        fetch(query: query)
        currentQuery = query
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        currentQuery = nil
        tableContent.removeAll()
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = self.tableContent.count
        if numberOfRows == 0 {
            tableView.setPlaceholder(NSLocalizedString("no_results", comment: ""))
        } else {
            tableView.removePlaceholder()
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell else {
            assertionFailure("should not enter here")
            return UITableViewCell()
        }
        cell.setup(result: self.tableContent[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 
            indexPath.row == self.tableContent.count - 1,
            tableContent.count < totalResults ?? 0,
            let query = currentQuery
        {
            fetch(query: query)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard 
            let router = router,
            var dataStore = router.dataStore
        else {
            return
        }
        dataStore.photoId = self.tableContent[indexPath.row].photoId
        router.routeToDetail(source: self)
    }
}
