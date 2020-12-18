//
//  WelcomeViewController.swift
//  Upgrade
//
//  Created by Arash on 18/12/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Views
    var headerView: UIView!
    var descriptionLabel: UILabel!
    var focusImageView: UIImageView!
    var promptLabel: UILabel!
    var continueButton: UIButton!

    // MARK: - Properties
    let headerGradientLayer = K.Design.upGradientLayer
    let buttonGradientLayer = K.Design.upGradientLayer

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let guide = view.safeAreaLayoutGuide

        // MARK: Header View
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        // FIXME: Header View design
        headerView.applyHeaderDesign(headerGradientLayer)
        headerGradientLayer.frame = headerView.bounds
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])

        // MARK: Subtitle Label
        let subtitleLabel = UILabel()
        let titleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Welcome to"
        subtitleLabel.font = UIFont(name: "Metropolis Semi Bold", size: 24.0)
        subtitleLabel.textColor = .white
        titleLabel.text = "Upgrade!"
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

        // MARK: Description Label
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Upgrade helps you view your academic achievements in insightful ways."
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 20.0)
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: K.Layout.moreSpaceBetween),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -K.Layout.someSpaceBetween),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: K.Layout.someSpaceBetween)
        ])

        // MARK: Focus Image View
        focusImageView = UIImageView()
        focusImageView.translatesAutoresizingMaskIntoConstraints = false
        focusImageView.image = UIImage(named: "score")
        view.addSubview(focusImageView)
        NSLayoutConstraint.activate([
            focusImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: K.Layout.moreSpaceBetween),
            focusImageView.heightAnchor.constraint(equalToConstant: 177.0),
            focusImageView.widthAnchor.constraint(equalToConstant: 251.0),
            focusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // MARK: Prompt Label
        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.text = "Ready to begin?"
        promptLabel.textAlignment = .center
        promptLabel.font = UIFont.systemFont(ofSize: 20.0)
        view.addSubview(promptLabel)
        NSLayoutConstraint.activate([
            promptLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -K.Layout.someSpaceBetween),
            promptLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: K.Layout.someSpaceBetween)
        ])

        // MARK: Continue Label
        continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.applyButtonDesign(buttonGradientLayer)
        buttonGradientLayer.frame = continueButton.bounds
        continueButton.setTitle("Let's go!", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Metropolis Bold", size: 22.0)
        continueButton.titleLabel?.textColor = .white
        view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: K.Layout.someSpaceBetween),
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

    // MARK: - Functions
    @objc func continueButtonPressed() {
        // TODO: Implement navigation to next screen
    }

}
