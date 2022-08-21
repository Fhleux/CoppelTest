//
//  CompanyCell.swift
//  coppelTest
//
//  Created by Tony on 8/20/22.
//

import Foundation
import UIKit

class CompanyCell: UICollectionViewCell {
    
    static let identifier = String(describing: CompanyCell.self)
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var companyImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moviePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(nameLabel)
        contentView.addSubview(companyImage)
        setConstrainst()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstrainst() {
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        companyImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        companyImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        companyImage.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        companyImage.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10).isActive = true
    }
}
