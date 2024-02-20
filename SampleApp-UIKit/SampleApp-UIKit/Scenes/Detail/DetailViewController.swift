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
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        titleTextLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleTextLabel
    }()
    
    private lazy var subtitleTextLabel: UILabel = {
        let subtitleTextLabel = UILabel()
        subtitleTextLabel.numberOfLines = 0
        subtitleTextLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleTextLabel
    }()
    
    private lazy var infoTextLabel: UILabel = {
        let infoTextLabel = UILabel()
        infoTextLabel.numberOfLines = 0
        infoTextLabel.font = UIFont.systemFont(ofSize: 15)
        infoTextLabel.textColor = .gray
        infoTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoTextLabel
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
        fetch()
    }
    
    // MARK: Setup methods
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Detail"
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(imgView)

        [imgView, titleTextLabel, subtitleTextLabel, infoTextLabel, likesTextLabel].forEach { scrollViewContainer.addArrangedSubview($0) }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    
    
    private func setupConstraints(multiplier: CGFloat) {
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            
            scrollViewContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollViewContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: multiplier)
            
        ])
    }
    
    // MARK: Fetch and display methods
    
    func fetch() {
        interactor?.fetch()
    }
    
    func display(viewModel: Detail.Fetch.ViewModel) {
        guard let result = viewModel.result else {
            assertionFailure("something went wrong")
            return
        }
        let aspectRatio = Double(result.height) / Double(result.width)
        DispatchQueue.main.async {
            self.titleTextLabel.text = result.alt_description?.capitalizeSentence
            self.subtitleTextLabel.text = result.description
            self.infoTextLabel.text = "Taken by \(result.userName)"
            if let location = result.location {
                self.infoTextLabel.text?.append(" in \(location)")
            }
            if let equipment = result.equipment {
                self.infoTextLabel.text?.append(" with \(equipment).")
            }
            self.likesTextLabel.text = "\(result.likes) likes"
            self.setupConstraints(multiplier: aspectRatio)
            self.imgView.loadImageFromUrl(urlString: viewModel.result?.imgUrl ?? "")
            self.view.layoutIfNeeded()
        }
        
    }
}
