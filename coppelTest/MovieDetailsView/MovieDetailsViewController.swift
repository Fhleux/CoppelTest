//
//  MovieDetailsViewController.swift
//  coppelTest
//
//  Created by Tony on 8/20/22.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    private let viewModel = MovieDetailsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private let dateFormatter = DateFormatter()
    
    var movie : Movie
    
    private let button : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.setImage(UIImage.init(named: "chevron.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let img: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDate : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rating : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageImage : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#0C151A")
        navigationController?.isNavigationBarHidden = true
        dateFormatter.dateFormat = "YYYY"
        addViews()
        setupConstraints()
        if let movieImg = movie.imgdata, let id = movie.id {
            img.image = UIImage(data: movieImg)
            Task{
                await viewModel.fetchMovieDetals(id)                
            }
        }
        setupBinders()
    }
    
    private func setupBinders() {
        
        viewModel.$movie.sink { [weak self] movie in
            self?.movie = movie
            self?.titleLabel.text = movie.title
            self?.descriptionLabel.text = movie.description
            self?.releaseDate.text = self?.dateFormatter.string(for: movie.releaseDate)
            if let movieLength = movie.durarion, let (hours, mins) = self?.minutesToHoursAndMinutes(movieLength) {
                self?.releaseDate.text! += " \(hours)h \(mins)min"
            }
            if let rate = movie.rating {
                self?.rating.text = "TMDB \(rate)"
            }
            self?.ageImage.image = UIImage(named: movie.adult ? "age-limit" : "age-limit")?.withTintColor(.lightGray)
        }.store(in: &cancellables)
    }
    
    private func addViews() {
        view.addSubview(img)
        view.addSubview(button)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(releaseDate)
        view.addSubview(rating)
        view.addSubview(ageImage)
    }
    
    func setupConstraints() {
        let topbarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 0.0
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        img.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
        img.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        img.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        releaseDate.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        releaseDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        rating.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 10).isActive = true
        rating.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        ageImage.leadingAnchor.constraint(equalTo: rating.trailingAnchor, constant: 10).isActive = true
        ageImage.centerYAnchor.constraint(equalTo: rating.centerYAnchor).isActive = true
        ageImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ageImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    init(_ movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
}
