//
//  DetailViewController.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol DetailDisplayLogic: AnyObject {
    func display(viewModel: Detail.Fetch.ViewModel)
}

final class DetailViewController: UIViewController, DetailDisplayLogic {
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    
    // MARK: UI
    
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder")
        return imageView
     }()
    
    private lazy var titleTextLabel: UILabel = {
        let titleTextLabel = UILabel()
        titleTextLabel.numberOfLines = 0
        titleTextLabel.font = UIFont.systemFont(ofSize: 16)
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleTextLabel
    }()
    
    private lazy var subtitleTextLabel: UILabel = {
        let subtitleTextLabel = UILabel()
        subtitleTextLabel.numberOfLines = 0
        subtitleTextLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleTextLabel
    }()
    
    private lazy var authorTextLabel: UILabel = {
        let authorTextLabel = UILabel()
        authorTextLabel.font = UIFont.systemFont(ofSize: 14)
        authorTextLabel.textColor = .gray
        authorTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorTextLabel
    }()
    
    private lazy var likesTextLabel: UILabel = {
        let likesTextLabel = UILabel()
        likesTextLabel.font = UIFont.systemFont(ofSize: 14)
        likesTextLabel.textColor = .gray
        likesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return likesTextLabel
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
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
    }
    
    // MARK: Setup methods
    
    private func setupView() {
        view.backgroundColor = .red
        title = "Detail"
        
        [imgView, titleTextLabel, subtitleTextLabel, authorTextLabel, likesTextLabel].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
    }
    
    // MARK: Fetch and display methods
    
    func fetch() {
        interactor?.fetch()
    }
    
    func display(viewModel: Detail.Fetch.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}
