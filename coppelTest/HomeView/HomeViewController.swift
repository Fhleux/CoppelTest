//
//  HomeViewController.swift
//  coppelTest
//
//  Created by Tony on 8/18/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var movies: [Movie] = []
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MoviesCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = UIColor.black
        return cv
    }()
    
    
    fileprivate func setCollectionViewConstraints() {
        collectionView.topAnchor.constraint(equalTo: blackView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate let blackView : UIView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 150))
        myView.backgroundColor = .black
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    fileprivate let segmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["porpular", "Top Rated", "On Tv", "Airing Today"])
        segmented.selectedSegmentIndex = 0
        
        let frame = UIScreen.main.bounds
        segmented.layer.cornerRadius = 5
        segmented.backgroundColor = .darkGray
        segmented.selectedSegmentTintColor = .gray
        segmented.addTarget(self, action: #selector(mediaFilterChange(_:)), for: .valueChanged)
        segmented.translatesAutoresizingMaskIntoConstraints = false 
        return segmented
    }()
    
    func setSegmentedConstraints() {
        let topbarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        blackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight + 50).isActive = true
        blackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: blackView.topAnchor, constant: 15).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        title = "TV Shows"
        navigationController?.navigationBar.backgroundColor = .darkGray
        setupBinders()
        fetchData()
        setupNavigationBar()
        view.addSubview(collectionView)
        view.addSubview(blackView)
        view.addSubview(segmentedControl)
        setSegmentedConstraints()
        setCollectionViewConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupBinders() {
        
        viewModel.$movies.sink { [weak self] movies in
            
            self?.movies = movies
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    func fetchData() {
        Task {
            await viewModel.fetchData()            
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let image = UIImage(named: "list")
        image?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        let menuButton = UIButton()
        menuButton.setBackgroundImage(UIImage(named: "list")?.withTintColor(.white, renderingMode: .automatic), for: .normal)
        menuButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    @objc func buttonTapped() {
        let actionSheet = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        let viewProfileAction = UIAlertAction(title: "View Profile", style: .default) { (action) in
            //TODO: go to profile view
            self.goToProfile()
        }
        let logoutAction = UIAlertAction(title: "Log out", style: .destructive) { (action) in
            self.goToLoginPage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(viewProfileAction)
        actionSheet.addAction(logoutAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func mediaFilterChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                print("popular")
            case 1:
                print("Top")
            case 2:
                print("on tv")
            case 3:
                print("Airing")
            collectionView.reloadData()
            default:
                break
              }
    }
    
    private func goToLoginPage() {
        viewModel.logout()
        let loginVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func goToProfile() {
        let profileVC = ProfileViewController()
//        navigationController?.pushViewController(profile, animated: true)
        let navVC = UINavigationController(rootViewController: profileVC)
        present(navVC, animated: true)
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCell
        cell.titleLabel.text = movies[indexPath.row].title
        cell.ratingLabel.text = String(describing: movies[indexPath.row].rating!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = dateFormatter.string(for: movies[indexPath.row].releaseDate)
        cell.descriptionLabel.text = movies[indexPath.row].description
        if let imgData = movies[indexPath.row].imgdata {
            cell.movieImage.image = UIImage(data: imgData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 8.0, bottom: 1.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let widthPerItem = collectionView.frame.width / 2 - layout.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 12, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController(movies[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
