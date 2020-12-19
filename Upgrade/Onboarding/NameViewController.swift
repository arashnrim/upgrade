//
//  NameViewController.swift
//  Upgrade
//
//  Created by Arash on 18/12/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit
import Hero

class NameViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Views
    var headerView: UIView!
    var promptLabel: UILabel!
    var nameTextField: UITextField!
    var continueButton: UIButton!

    // MARK: - Properties
    let headerGradientLayer = K.Design.upGradientLayer
    let buttonGradientLayer = K.Design.upGradientLayer

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.hero.isEnabled = true

        let guide = view.safeAreaLayoutGuide

        // MARK: Header View
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        // FIXME: Header View design
        headerView.applyHeaderDesign(headerGradientLayer)
        headerView.backgroundColor = K.Design.upPurple
        headerGradientLayer.frame = headerView.bounds
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])

        // MARK: Subtitle and Title Label
        let subtitleLabel = UILabel()
        let titleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Let's get"
        subtitleLabel.font = UIFont(name: "Metropolis Semi Bold", size: 24.0)
        subtitleLabel.textColor = .white
        titleLabel.text = "started!"
        titleLabel.font = UIFont(name: "Metropolis Bold", size: 30.0)
        titleLabel.textColor = .white
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -K.Layout.someSpaceBetween),
            subtitleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -K.Layout.littleSpaceBetween),
            subtitleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: K.Layout.someSpaceBetween),
            titleLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -K.Layout.someSpaceBetween),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -K.Layout.moreSpaceBetween),
            titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: K.Layout.someSpaceBetween)
        ])

        // MARK: Prompt Label
        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.text = "What name can we address you by?"
        promptLabel.textColor = .darkText
        promptLabel.font = .systemFont(ofSize: 20.0)
        view.addSubview(promptLabel)
        NSLayoutConstraint.activate([
            promptLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: K.Layout.moreSpaceBetween),
            promptLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -K.Layout.someSpaceBetween),
            promptLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: K.Layout.someSpaceBetween)
        ])

        // MARK: Name Text Field
        nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Name"
        nameTextField.font = .systemFont(ofSize: 18.0)
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocorrectionType = .no
        nameTextField.delegate = self
        self.dismissKeyboardOnTap(completion: nil)
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: K.Layout.someSpaceBetween),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: K.Layout.someSpaceBetween),
            nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: K.Layout.someSpaceBetween),
            nameTextField.heightAnchor.constraint(equalToConstant: K.Layout.buttonHeight)
        ])

        // MARK: Continue Button
        continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.applyButtonDesign(buttonGradientLayer)
        buttonGradientLayer.frame = continueButton.bounds
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitle("Type a name...", for: .disabled)
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        continueButton.titleLabel?.font = UIFont(name: "Metropolis Bold", size: 22.0)
        continueButton.titleLabel?.textColor = .white
        continueButton.addTarget(nil, action: #selector(continueButtonPressed), for: .touchUpInside)
        view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -K.Layout.someSpaceBetween),
            continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: K.Layout.someSpaceBetween),
            continueButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerGradientLayer.frame = headerView.bounds
        buttonGradientLayer.frame = continueButton.bounds
    }

    // MARK: - Text Field Protocols
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Checks if the name is empty; otherwise, the user cannot proceed.
        guard let name = textField.text else { return }
        if !(name.isEmpty) {
            continueButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.continueButton.alpha = 1.0
            }
        } else {
            continueButton.isEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.continueButton.alpha = 0.5
            }
        }
    }

    @objc func continueButtonPressed() {
        guard let name = nameTextField.text else { return }
        saveToUserDefaults(value: name, key: "name") {
            guard var viewControllers = self.navigationController?.viewControllers else { return }
            _ = viewControllers.popLast()
            viewControllers.append(HomeViewController())
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }

}
