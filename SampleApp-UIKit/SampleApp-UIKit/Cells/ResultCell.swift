//
//  ResultCell.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 20/2/24.
//

import Foundation
import UIKit

final class ResultCell: UITableViewCell {
    
    static let identifier = "ResultCellID"
    
    // MARK: UI
    
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "img_placeholder")
        return imageView
     }()
    
    private lazy var titleTextLabel: UILabel = {
        let titleTextLabel = UILabel()
        titleTextLabel.numberOfLines = 0
        titleTextLabel.font = UIFont.systemFont(ofSize: 16)
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleTextLabel
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    // MARK: Setup methods
    
    private func setupView() {
        backgroundColor = .white
        selectionStyle = .none
        [imgView, titleTextLabel, authorTextLabel, likesTextLabel].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imgView.widthAnchor.constraint(equalToConstant: 80),
            imgView.heightAnchor.constraint(equalToConstant: 80),
            
            titleTextLabel.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 20),
            titleTextLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -16),
            titleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            authorTextLabel.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 20),
            authorTextLabel.rightAnchor.constraint(lessThanOrEqualTo: likesTextLabel.leftAnchor, constant: -10),
            authorTextLabel.topAnchor.constraint(greaterThanOrEqualTo: titleTextLabel.bottomAnchor, constant: 20),
            authorTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            likesTextLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            likesTextLabel.topAnchor.constraint(greaterThanOrEqualTo: titleTextLabel.bottomAnchor, constant: 20),
            likesTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
    }
    
    func setup(result: SearchResult){
        titleTextLabel.text = result.alt_description?.capitalizeSentence
        authorTextLabel.text = result.userName.capitalized
        likesTextLabel.text = String.localizedStringWithFormat(NSLocalizedString("number_of_likes", comment: ""), result.likes)
        imgView.loadImageFromUrl(urlString: result.thumbUrl)
    }
}
