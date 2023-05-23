//
//  AdminViewController.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import UIKit

class AdminViewController: UIViewController {

    enum Constants {
        static let inset = 15.0
        static let largeInset = 30.0
        static let textFieldHeight = 40.0
        static let cornerRadius = 15.0

        static let startButtonHeight = 50.0
        static let startButtonBottomConstraint = 35.0
        static let animationDuration = 0.3

        static let defaultInfectionFactor = 3
        static let defaultPeriod = 1.0
    }

    private var output: AdminViewOutputProtocol

    private var currentType: TypeOfPrivate = .privateGame

    private var isButtonAnimating = false

    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название комнаты"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите тип"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var publicLabel: UILabel = {
        let networkLabel = UILabel()
        networkLabel.text = "Публичная"
        networkLabel.textColor = .white
        networkLabel.font = UIFont.boldSystemFont(ofSize: 15)
        networkLabel.translatesAutoresizingMaskIntoConstraints = false
        return networkLabel
    }()

    private let privateLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.text = "Приватная"
        localLabel.textColor = .white
        localLabel.font = UIFont.boldSystemFont(ofSize: 15)
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        return localLabel
    }()

    private lazy var gameNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderWidth = 2.0
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Например: Пираты"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: textField.frame.size.height))
        textField.leftViewMode = .always
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var publicButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonsHandler), for: .touchUpInside)
        button.setImage(UIImage(systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .selected)
        let image = UIImage(systemName: "circle",
                           withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isSelected = true
        return button
    }()

    private lazy var privateButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonsHandler), for: .touchUpInside)
        button.setImage(UIImage(systemName: "checkmark.circle.fill",
                                withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(.white, renderingMode: .alwaysOriginal),
                        for: .selected)
        let image = UIImage(systemName: "circle",
                           withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    private lazy var stackView: UIStackView = {
        let publicStackView = UIStackView(arrangedSubviews: [
            publicLabel, publicButton
        ])
        publicStackView.axis = .vertical
        publicStackView.spacing = 10
        publicStackView.alignment = .center
        publicStackView.distribution = .fill

        let privateStackView = UIStackView(arrangedSubviews: [
            privateLabel, privateButton
        ])
        privateStackView.spacing = 10
        privateStackView.alignment = .center
        privateStackView.distribution = .fill
        privateStackView.axis = .vertical

        let horizontalStackView = UIStackView(arrangedSubviews: [
            publicStackView, privateStackView
        ])
        horizontalStackView.spacing = 30
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        let stackView = UIStackView(arrangedSubviews: [
            gameNameLabel,
            gameNameTextField,
            typeLabel,
            horizontalStackView
        ])
        stackView.backgroundColor = UIColor(hexString: "#0077FF")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layer.cornerRadius = Constants.cornerRadius
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.setCustomSpacing(30, after: gameNameTextField)
        stackView.layoutMargins = UIEdgeInsets(top: Constants.largeInset, left: 0, bottom: Constants.largeInset, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#0077FF")
        button.tintColor = .white
        button.setTitle("Создать комнату", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(output: AdminViewOutputProtocol) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Создание комнаты"
        startButton.addTarget(self, action: #selector(startButtonOnTapHandler), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onPressed(_:)))
        startButton.addGestureRecognizer(longPressRecognizer)
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(startButton)
        setupTextFieldBorderColor()
        setupStackViewConstraints()
        setupStartButtonConstraints()
    }

    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.inset)
        ])

        NSLayoutConstraint.activate([
            gameNameTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            gameNameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: Constants.inset),
            gameNameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -Constants.inset),
        ])
    }

    func setupStartButtonConstraints() {
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: Constants.startButtonHeight),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.largeInset),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.largeInset),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                constant: -Constants.startButtonBottomConstraint)
        ])
    }

    func showErrorAlert(message: String) {
        let errorTextAlert = UIAlertController(title: "Неправильный ввод",
        message: message, preferredStyle: .alert)
        errorTextAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        }))
        present(errorTextAlert, animated: true)
    }

    @objc func startButtonOnTapHandler() {
        output.checkErrorsAndPresent(name: gameNameTextField.text, currentType: currentType)
    }

    @objc private func buttonsHandler(_ sender: UIButton) {
        if sender == publicButton {
            output.changedType(with: TypeOfPrivate.publicGame)
        } else {
            output.changedType(with: TypeOfPrivate.privateGame)
        }
    }
}


// MARK: Animations

extension AdminViewController {

    @objc func onPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            if !isButtonAnimating {
                isButtonAnimating = true
                animateButton(with: Constants.animationDuration)
            } else {
                isButtonAnimating = false
                if let presentationLayer = startButton.layer.presentation() {
                    startButton.layer.transform = presentationLayer.transform
                    startButton.layer.removeAnimation(forKey: "shake")
                }
                UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
                    self?.startButton.transform = .identity
                }, completion: { [weak self] _ in
                    self?.startButton.layer.removeAllAnimations()
                })
            }
        }
    }

    func animateButton(with duration: Double) {
        let translationAnimation = CABasicAnimation(keyPath: "position")
        let yPosition = view.frame.height -
        Constants.startButtonHeight / 2 - Constants.startButtonBottomConstraint
        translationAnimation.autoreverses = true
        translationAnimation.fromValue = CGPoint(x: view.frame.width / 2.0 - 5, y: yPosition - 5)
        translationAnimation.toValue = CGPoint(x: view.frame.width / 2.0 + 5, y: yPosition + 5)
        translationAnimation.duration = duration / 2
        translationAnimation.repeatCount = .infinity

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.autoreverses = true
        rotationAnimation.fromValue = -.pi / 20.0
        rotationAnimation.toValue = .pi / 20.0
        rotationAnimation.duration = duration / 2
        rotationAnimation.repeatCount = .infinity

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotationAnimation, translationAnimation]
        animationGroup.autoreverses = true
        animationGroup.duration = Constants.animationDuration
        animationGroup.repeatCount = .infinity
        startButton.layer.add(animationGroup, forKey: "shake")
    }
}

extension AdminViewController: AdminViewInputProtocol {

    func setErrorGroupTextField() {
        gameNameTextField.layer.borderColor = UIColor.systemRed.cgColor
    }

    func setupTextFieldBorderColor() {
        gameNameTextField.layer.borderColor = UIColor.systemGray3.cgColor
    }

    func presentRoom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        Service.shared.createRoom(name: gameNameTextField.text ?? "", isPrivate: currentType == .privateGame, complition: { [weak self] result in
            switch result {
            case .success(let value):
                print(value)
                self?.navigationController?.view.layer.add(transition, forKey: nil)
                self?.present(ViewController(), animated: true)
            case .error(let error):
                self?.showErrorAlert(message: error.localizedDescription)
            }
        })
    }

    func setPublicType () {
        publicButton.isSelected = true
        privateButton.isSelected = false
        currentType = .publicGame
    }

    func setPrivateType() {
        privateButton.isSelected = true
        publicButton.isSelected = false
        currentType = .privateGame
    }
}
