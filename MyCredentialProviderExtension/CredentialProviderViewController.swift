//
//  CredentialProviderViewController.swift
//  MyCredentialProviderExtension
//
//  Created by e.shirashiyani on 5/4/24.
//

import UIKit
import AuthenticationServices

struct Credential {
    let username: String
    let domain: String
}

final class CredentialProviderViewController: ASCredentialProviderViewController {
    private var credentials: [Credential] = [
        Credential(username: "j_appleseed", domain: "example.com"),
        Credential(username: "j_appleseed", domain: "apple.com")
    ]
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CredentialTableViewCell.self, forCellReuseIdentifier: CredentialTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Passwords"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "Select a password to fill")
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissViewController))
        navBar.setItems([navItem], animated: false)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        layoutUI()
    }

    private func layoutUI() {
        view.addSubview(navigationBar)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func dismissViewController() {
//        extensionContext.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

extension CredentialProviderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credentials.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CredentialTableViewCell.identifier, for: indexPath) as! CredentialTableViewCell
        let credential = credentials[indexPath.row]
        cell.configure(with: credential)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCredential = credentials[indexPath.row]
        let credential = ASPasswordCredential(user: selectedCredential.username, password: "password_for_demo")
        DispatchQueue.main.async {
            self.extensionContext.completeRequest(withSelectedCredential: credential, completionHandler: nil)
        }
    }
}
