//
//  File.swift
//  coppelTest
//
//  Created by Tony on 8/18/22.
//

import Foundation
import UIKit

class MoviesCell: UICollectionViewCell {
    
    let movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moviePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    fileprivate let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 14
        view.layer.shadowOpacity = 1.0
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = UIColor(hexString: "#56B366")
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "motnh  DD, YYYY"
        label.textColor = UIColor(hexString: "#56B366")
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = UIColor(hexString: "#56B366")
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let start : UIImageView = {
        let image = UIImageView()
        image.image = UIImage.init(named: "star")?.withTintColor(UIColor(hexString: "#56B366"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "description"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setConstraints() {
        movieImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        movieImage.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        movieImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        shadowView.topAnchor.constraint(equalTo: movieImage.topAnchor,constant: 4).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: movieImage.leadingAnchor,constant: 4).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: movieImage.trailingAnchor,constant: -4).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: movieImage.bottomAnchor,constant: -4).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: start.leadingAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        ratingLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        start.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        start.widthAnchor.constraint(equalToConstant: 10).isActive = true
        start.heightAnchor.constraint(equalToConstant: 10).isActive = true
        start.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -2).isActive=true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = UIColor(hexString: "#19272D")
        contentView.layer.cornerRadius = 16
        contentView.addSubview(shadowView)
        contentView.addSubview(movieImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(start)
        contentView.addSubview(descriptionLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
