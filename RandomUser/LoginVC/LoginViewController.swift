    //
    //  LoginViewController.swift
    //  RandomUser
    //
    //  Created by Aleksei Permiakov on 19.04.2023.
    //

import Combine
import UIKit

final class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModelProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        configure(label: label, with: viewModel.presentationObject.loginLabel)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        configure(textfield: tf, with: viewModel.presentationObject.emailTF)
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.returnKeyType = .continue
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        configure(textfield: tf, with: viewModel.presentationObject.passwordTF)
        tf.isSecureTextEntry = true
        tf.textContentType = .oneTimeCode
        tf.clearsOnBeginEditing = true
        tf.returnKeyType = .go
        tf.enablePasswordHideToggle()
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = viewModel.presentationObject.cornerRadius
        let attributedTitle = makeAttributedString(with: viewModel.presentationObject.loginWhite)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setBackgroundColor(.systemIndigo, forState: .normal)
        button.setBackgroundColor(.lightGray, forState: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemIndigo
        return indicator
    }()
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
        setupObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindToViewModel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        
        let input = LoginViewModelInput(email: emailTextField.textPublisher,
                                        pass: passwordTextField.textPublisher,
                                        loginTap: loginButton.publisher(for: .touchUpInside))
        
        viewModel.transform(input: input)
            .sink(receiveValue: { [unowned self] output in
                self.emailTextField.leftView?.tintColor = output.emailTint
                self.passwordTextField.leftView?.tintColor = output.passwTint
                self.loginButton.isEnabled = output.loginEnabled
            })
            .store(in: &subscriptions)
        
        viewModel.activityHandler = { [unowned self] state in
            switch state {
            case .running:
                self.activityIndicator.startAnimating()
            case .stop:
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setupObservers() {
            /// Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
        // MARK: Keyboard observers actions
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.scrollRectToVisible(loginButton.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
    }
}

    // MARK: - Layout
extension LoginViewController {
    private func setupViews() {
        
        navigationController?.isNavigationBarHidden = true
        
        let inset: CGFloat = 60
        let defaultHeight: CGFloat = 44
        let screenHeight = UIScreen.main.bounds.height
        
        view = scrollView
        view.backgroundColor = viewModel.presentationObject.backgroundColor
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [headerLabel,
         emailTextField,
         passwordTextField,
         loginButton,
         activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                             constant: screenHeight / 4),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: screenHeight / 5),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            emailTextField.heightAnchor.constraint(equalToConstant: defaultHeight),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: defaultHeight/2),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            passwordTextField.heightAnchor.constraint(equalToConstant: defaultHeight),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: defaultHeight),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            loginButton.heightAnchor.constraint(equalToConstant: defaultHeight),
            loginButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configure(textfield: UITextField, with config: TextFieldConfig) {
        textfield.placeholder = config.placeholder
        textfield.setIcon(UIImage(systemName: config.imageName))
        textfield.backgroundColor = config.backgroundColor
        textfield.tintColor = config.tintColor
        textfield.layer.cornerRadius = viewModel.presentationObject.cornerRadius
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.delegate = self
    }
    
    private func configure(label: UILabel, with config: TextConfig) {
        label.text = config.text
        label.font = config.font
        label.textColor = config.textColor
    }
    
    private func makeAttributedString(with config: TextConfig) -> NSAttributedString{
        return NSAttributedString(string: config.text,
                                  attributes: [.foregroundColor : config.textColor,
                                               .font: config.font])
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}
