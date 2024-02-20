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

final class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "List Images Cache"
        return cache
    } ()
    
    fileprivate var totalResults: Int?
    fileprivate var totalPages: Int?
    fileprivate var tableContent: Home.Fetch.ViewModel?
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: Setup methods

    func setupView() {
        title = "Main"
        view.backgroundColor = .white
        
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        navigationItem.searchController = searchBarController
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
        
        view.addSubview(tableView)
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
    
    func fetch(query: String) {
        interactor?.fetch(query: query)
    }
    
    func display(totalResults: Int, totalPages: Int, viewModel: Home.Fetch.ViewModel) {
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.tableContent = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
  
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let query = searchBar.text else { return }
        fetch(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = String()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableContent?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell,
            let result = self.tableContent?.results?[indexPath.row]
        else {
            assertionFailure("should not enter here")
            return UITableViewCell()
        }
        cell.setup(result: result)
        return cell
    }
    
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard 
            let router = router,
            var dataStore = router.dataStore,
            let photoId = self.tableContent?.results?[indexPath.row].id
        else {
            return
        }
        dataStore.photoId = photoId
        router.routeToDetail(source: self)
    }
}
