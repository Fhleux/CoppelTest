//
//  ViewController.swift
//  coppelTest
//
//  Created by Tony on 8/17/22.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    fileprivate let usernameTextField: UITextField = {
        let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 400, height: 60))
        textfield.placeholder = "Username"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.textContentType = .username
        return textfield
    }()
    
    fileprivate let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        textfield.textContentType = .password
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    fileprivate let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .gray
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let errorLabel : UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    fileprivate let loadingIndicator :UIActivityIndicatorView = {
        let loadingIndicator =  UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        return loadingIndicator
    }()
    
    fileprivate func setConstraints() {
        verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        verticalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        verticalStackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        errorLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 10).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkToken()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgLogin")!)
        verticalStackView.addArrangedSubview(usernameTextField)
        verticalStackView.addArrangedSubview(passwordTextField)
        verticalStackView.addArrangedSubview(loginButton)
        view.addSubview(verticalStackView)
        view.addSubview(errorLabel)
        setConstraints()
        setupBinders()
        usernameTextField.becomeFirstResponder()
        
    }
    
    private func setupBinders() {
        viewModel.$error.sink { [weak self] error in
            self?.alert.dismiss(animated: true)
            if let error = error {
                self?.errorLabel.isHidden = false
                self?.errorLabel.text = error
            }
        }.store(in: &cancellables)
        
        viewModel.$request_token.sink { [weak self] request_token in
            self?.alert.dismiss(animated: true, completion: {
                if request_token != nil {
                    self?.goToHomePage()
                }
            })
        }.store(in: &cancellables)
    }
    
    private func checkToken() {
        let hasAccessToken = viewModel.checkToken()
        if hasAccessToken { self.goToHomePage() }
    }
 
    @objc func buttonAction() {
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        Task{
            await viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        }
    }
    
    private func goToHomePage() {
        let homeVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }


}

