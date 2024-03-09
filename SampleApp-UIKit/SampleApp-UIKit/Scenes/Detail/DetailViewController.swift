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

final class DetailViewController: BaseViewController, DetailDisplayLogic {
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    var currentResult: DetailResult?
    
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
        imageView.image = UIImage(named: "img_placeholder")
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
        let worker = AppDetailWorker()
        worker.apiClient = AppAPIClient()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
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
        title = NSLocalizedString("detail_title", comment: "")
        setupBarButton()
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(imgView)

        [imgView, titleTextLabel, subtitleTextLabel, infoTextLabel, likesTextLabel].forEach { scrollViewContainer.addArrangedSubview($0) }
    }
    
    private func setupBarButton(photoId: String? = nil) {
        var image = UIImage(systemName: "bookmark.circle")
        if
            let photoId = photoId,
            let interactor = interactor,
            interactor.isFavorite(photoId: photoId)
        {
            image = UIImage(systemName: "bookmark.circle.fill")
        }
        
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action:  #selector(addRemoveFavorite))
        barButton.tintColor = .black
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupConstraints(multiplier: CGFloat) {
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
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
    
    private func fetch() {
        showLoadingIndicator()
        interactor?.fetch()
    }
    
    func display(viewModel: Detail.Fetch.ViewModel) {
        if let error = viewModel.error {
            DispatchQueue.main.async {
                self.presentErrorAlert(error: error)
                self.hideLoadingIndicator()
            }
            return
        } else {
            guard let result = viewModel.result else {
                assertionFailure("something went wrong")
                return
            }
            currentResult = result
            DispatchQueue.main.async {
                self.loadDetail()
            }
        }
    }
    
    private func loadDetail() {
        guard let result = currentResult else {
            assertionFailure("CurrentResult shouldn't be nil")
            return
        }
        let aspectRatio = Double(result.height) / Double(result.width)
        titleTextLabel.text = result.alt_description?.capitalizeSentence
        subtitleTextLabel.text = result.description
        infoTextLabel.text = String.localizedStringWithFormat(NSLocalizedString("taken_by", comment: ""), result.userName.capitalized)
        if let location = result.location {
            infoTextLabel.text?.append(String.localizedStringWithFormat(NSLocalizedString("taken_in", comment: ""), location))
        }
        if let equipment = result.equipment {
            infoTextLabel.text?.append(String.localizedStringWithFormat(NSLocalizedString("taken_with", comment: ""), equipment))
        }
        infoTextLabel.text?.append(".")
        likesTextLabel.text = String.localizedStringWithFormat(NSLocalizedString("number_of_likes", comment: ""), result.likes)
        setupConstraints(multiplier: aspectRatio)
        imgView.loadImageFromUrl(urlString: result.imgUrl)
        setupBarButton(photoId: result.id)
        view.layoutIfNeeded()
        hideLoadingIndicator()
    }
    
    @objc private func addRemoveFavorite() {
        guard let result = currentResult, let interactor = interactor else { return }
        interactor.addRemoveFavorite(favorite: result) { [weak self] result in
            self?.presentFavoriteAlert(result: result)
        }
        self.setupBarButton(photoId: result.id)
    }
}
