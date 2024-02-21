//
//  FavoritesViewController.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

protocol FavoritesDisplayLogic: AnyObject {
    func display(viewModel: Favorites.Fetch.ViewModel)
}

final class FavoritesViewController: BaseViewController, FavoritesDisplayLogic {
    var interactor: FavoritesBusinessLogic?
    var router: (NSObjectProtocol & FavoritesRoutingLogic & FavoritesDataPassing)?
    
    static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "Images Cache"
        return cache
    } ()
    
    fileprivate var totalResults: Int?
    fileprivate var totalPages: Int?
    fileprivate var tableContent: [FavoriteItem]?
    
    // MARK: UI
    
    private lazy var tableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false

         return tableView
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
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter()
        let router = FavoritesRouter()
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
        fetch()
    }
    
    // MARK: Setup methods

    private func setupView() {
        title = NSLocalizedString("favorites_title", comment: "")
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
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
    
    func fetch() {
        showLoadingIndicator()
        interactor?.fetch()
    }
    
    func display(viewModel: Favorites.Fetch.ViewModel) {
        if let error = viewModel.error {
            DispatchQueue.main.async {
                self.presentErrorAlert(error: error)
            }
            return
        } else if let result = viewModel.results {
            self.tableContent = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideLoadingIndicator()
            }
        } else {
            fetch()
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows =  self.tableContent?.count ?? 0
        if numberOfRows == 0 {
            tableView.setPlaceholder(NSLocalizedString("no_favorites", comment: ""))
        } else {
            tableView.removePlaceholder()
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell,
            let result = self.tableContent?[indexPath.row].toSearchResult()
        else {
            assertionFailure("should not enter here")
            return UITableViewCell()
        }
        cell.setup(result: result)
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let router = router,
            var dataStore = router.dataStore,
            let favoriteItem = self.tableContent?[indexPath.row],
            let favId = favoriteItem.favId
        else {
            return
        }
        dataStore.favId = favId
        router.routeToDetail(source: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove favorite"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard
                let favoriteItem = self.tableContent?[indexPath.row],
                let favId = favoriteItem.favId
            else {
                return
            }
            interactor?.removeFavorite(favId: favId)
        }
    }
}
