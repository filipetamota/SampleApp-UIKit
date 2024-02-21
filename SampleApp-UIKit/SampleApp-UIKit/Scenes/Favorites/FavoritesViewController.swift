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

final class FavoritesViewController: UIViewController, FavoritesDisplayLogic {
    var interactor: FavoritesBusinessLogic?
    var router: (NSObjectProtocol & FavoritesRoutingLogic)?
    
    static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "Images Cache"
        return cache
    } ()
    
    fileprivate var totalResults: Int?
    fileprivate var totalPages: Int?
    fileprivate var tableContent: Favorites.Fetch.ViewModel?
    
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
    }
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
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
        interactor?.fetch()
    }
    
    func display(viewModel: Favorites.Fetch.ViewModel) {
        self.tableContent = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
  
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableContent?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell,
            let result = self.tableContent?.results?[indexPath.row].toSearchResult()
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
          //  var dataStore = router.dataStore,
            let photoId = self.tableContent?.results?[indexPath.row].id
        else {
            return
        }
      //  dataStore.photoId = photoId
       // router.routeToDetail(source: self)
    }
}
