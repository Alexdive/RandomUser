    //
    //  UserViewController.swift
    //  RandomUser
    //
    //  Created by Aleksei Permiakov on 19.04.2023.
    //

import Combine
import UIKit

final class UserViewController: UIViewController {
    
    private var viewModel: UserViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    lazy var cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo.withAlphaComponent(0.15)
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderColor = UIColor.systemIndigo.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    private lazy var userInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init(viewModel: UserViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        setupWithViewModel()
    }
    
    private func setupNavBar() {
        let logOutAction = UIAction(handler: { [weak self] _ in
            self?.viewModel.logOut()
        })
        let logOutButton = UIBarButtonItem(
            title: "LogOut",
            primaryAction: logOutAction)
        logOutButton.tintColor = .systemPink
        
        navigationItem.setRightBarButton(logOutButton, animated: false)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupWithViewModel() {
        setupTitleView()
        
        viewModel.getProfileImage()
            .sink { [weak self] image in
                if let image = image as? UIImage {
                    self?.profileImageView.image = image
                }
            }
            .store(in: &subscriptions)

        let location = viewModel.userDetails.location
        addLabelToInfoStack(name: "Country", value: location.country)
        addLabelToInfoStack(name: "State", value: location.state)
        addLabelToInfoStack(name: "City", value: location.city)
        addLabelToInfoStack(name: "Street", value: location.street.name + " " + String(location.street.number))
        
        addLabelToInfoStack(name: "Postcode", value: location.postcode.stringValue)
        
        addLabelToInfoStack(name: "Email", value: viewModel.userDetails.email)
        addLabelToInfoStack(name: "DOB", value: viewModel.userDetails.stringDate)
    }
    
    private func addLabelToInfoStack(name: String, value: String?) {
        guard let value else { return }
        let label = UILabel()
        label.text = name + ": " + value
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.font = AppConstants.Fonts.avenirNext18
        userInfoStack.addArrangedSubview(label)
    }
    
    private func setupTitleView() {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemIndigo
        label.numberOfLines = 2
        label.font = AppConstants.Fonts.avenirMedium22
        label.text = viewModel.userDetails.name.first + " " + viewModel.userDetails.name.last
        navigationItem.titleView = label
    }
}

extension UserViewController {
    private func setupViews() {
        let inset: CGFloat = 16
        
        view.backgroundColor = .systemBackground
        
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardContainerView)
        
        [profileImageView,
         userInfoStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardContainerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            cardContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: inset),
            cardContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -inset),
            
            profileImageView.centerYAnchor.constraint(
                equalTo: cardContainerView.topAnchor),
            profileImageView.centerXAnchor.constraint(
                equalTo: cardContainerView.centerXAnchor),
            profileImageView.heightAnchor.constraint(
                equalToConstant: 120),
            profileImageView.widthAnchor.constraint(
                equalToConstant: 120),
            
            userInfoStack.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor, constant: inset*2),
            userInfoStack.leadingAnchor.constraint(
                equalTo: cardContainerView.leadingAnchor, constant: inset),
            userInfoStack.trailingAnchor.constraint(
                equalTo: cardContainerView.trailingAnchor, constant: -inset),
            userInfoStack.bottomAnchor.constraint(
                equalTo: cardContainerView.bottomAnchor, constant: -inset*2)
        ])
    }
}
