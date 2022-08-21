//
//  ProfileViewController.swift
//  coppelTest
//
//  Created by Tony on 8/19/22.
//

import UIKit
import Combine

fileprivate let avatarSize = CGFloat(130)

class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    fileprivate var profile = User()
    
    fileprivate let usernameLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#56B366")
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var avatarView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = avatarSize/2
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupConstraints() {
        let navigationBarOffset = navigationController?.navigationBar.frame.origin.y ?? 0
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let offset = -navigationBarOffset - navigationBarHeight
        
        avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: -offset + 20).isActive = true
        avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: avatarSize).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: avatarSize).isActive = true
        
        usernameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#0C151A")
        setupNavigationBar()
        view.addSubview(usernameLabel)
        view.addSubview(avatarView)
        setupConstraints()
        getInfo()
        setupBinders()
    }
    
    private func setupBinders() {
        
        viewModel.$profile.sink { [weak self] profile in
            self?.profile = profile
            self?.usernameLabel.text = "@\(profile.username ?? "" )"
            if let avatar = profile.avatar {
                self?.avatarView.image = UIImage(data: avatar)
            } else {
                self?.avatarView.image = UIImage(named: "profile-placeholder")
            }
        }.store(in: &cancellables)
    }
    
    func getInfo() {
        Task{
            await viewModel.fetchProfile()
        }
    }
    
    func setupNavigationBar() {
        title = "Profile"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(hexString: "#56B366")]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }

}
