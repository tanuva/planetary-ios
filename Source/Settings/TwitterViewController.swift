//
//  TwitterViewController.swift
//  Planetary
//
//  Created by Rabble on 5/26/20.
//  Copyright © 2020 Verse Communications Inc. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class TwitterSettingsViewController: DebugTableViewController {
    
    // MARK: - Private Variables

    private lazy var colorSidebar: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 1
        label.textColor = .darkText
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var userIDLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var show = DebugTableViewCellModel(title: Text.crossPostToTwitter.text,
                                                    valueClosure:
        {
            [unowned self] cell in
            cell.accessoryType = .none
            guard let syncWithTwitter = self.syncWithTwitter else { return }
            cell.accessoryType = syncWithTwitter ? .checkmark : .none
        },
                                                    actionClosure:
        {
            [unowned self] cell in
            self.toggle(syncWithTwitter: true)
        })

    private lazy var hide = DebugTableViewCellModel(title: Text.dontCrossPostToTwitter.text,
                                                    valueClosure:
        {
            [unowned self] cell in
            cell.accessoryType = .none
            guard let syncWithTwitter = self.syncWithTwitter else { return }
            cell.accessoryType = syncWithTwitter ? .none : .checkmark
        },
                                                    actionClosure:
        {
            [unowned self] cell in
            self.toggle(syncWithTwitter: false)
        })

    
    private var syncWithTwitter: Bool? = nil

    //private var sessionStore: TWTRSessionStore
    
    private var session: TWTRAuthSession?

    // TODO include optional initial state
    convenience init(syncWithTwitter: Bool? = nil) {
        //super.init()
        //self.syncWithTwitter = syncWithTwitter
        self.init()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Text.twitterSyncSettings.text
        self.session = TWTRTwitter.sharedInstance().sessionStore.session()
        self.addSubviews()
        self.updateSettings()
    }
    
    private func addSubviews() {
        //self.view.addSubview(self.textView)
        //self.view.addSubview(self.label)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(userIDLabel)
        self.view.addSubview(colorSidebar)
        self.view.addSubview(logoutButton)

        setupUsernameLabel()
        setupUserIDLabel()
        setupColorSidebar()
        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkInDirectoryIfNecessary()
    }

    internal override func updateSettings() {
        self.settings = [("", [self.show, self.hide], Text.twitterMessage.text)]
        super.updateSettings()
    }
    
    private func loginTwitter() {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
           if session != nil {
                print("logged in user: ", session?.userName) // prints: logged in user:  Optional("dagostin")
           } else {
                print("didn't log in: ", error!)
           }
       }
    }
    
    private func logoutTwitter() {
       let sessionStore = TWTRTwitter.sharedInstance().sessionStore
       if let userID = sessionStore.session()?.userID {
           sessionStore.logOutUserID(userID)
       }
    }

    private func checkInDirectoryIfNecessary() {
        guard self.syncWithTwitter == nil else { return }
        //AppController.shared.showProgress()
        // syncWithTwitter
    }

    private func toggle(syncWithTwitter: Bool) {
        guard let identity = Bots.current.identity else {
            return
        }
        self.syncWithTwitter = syncWithTwitter
        self.updateSettings()
        //AppController.shared.showProgress()
        if syncWithTwitter {
            // set setting to sync with twitter
        } else {
            // set setting to sync NOT with twitter
        }
    }
    
    // MARK: - Private Methods

    private func setupUsernameLabel() {
        usernameLabel.rightAnchor.constraint(equalTo: logoutButton.leftAnchor, constant: -10.0).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: colorSidebar.rightAnchor, constant: 10.0).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }

    private func setupUserIDLabel() {
        userIDLabel.rightAnchor.constraint(equalTo: logoutButton.leftAnchor, constant: -10.0).isActive = true
        userIDLabel.leftAnchor.constraint(equalTo: colorSidebar.rightAnchor, constant: 10.0).isActive = true
        userIDLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        userIDLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }

    private func setupColorSidebar() {
        colorSidebar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        colorSidebar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        colorSidebar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        colorSidebar.widthAnchor.constraint(equalToConstant: 10.0).isActive = true
    }

    private func setupLogoutButton() {
        logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
    }

    // MARK: - Actions

    @objc func logout() {
        if let session = session {
            //delegate?.sessionCollectionViewCell(collectionViewCell: self, didTapLogoutFor: session)
        }
    }

    // MARK: - Public Methods

    func configure(with session: TWTRSession?) {
        self.session = session
        guard let session = session else { return }
        usernameLabel.text = "Username: \(session.userName)"
        userIDLabel.text = "User ID: \(session.userID)"
    }
    
}
