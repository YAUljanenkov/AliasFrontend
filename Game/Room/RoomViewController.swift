//
//  RoomsListViewController.swift
//  AliasFrontend
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import UIKit
import SwiftUI

class RoomViewController: UIViewController {
    fileprivate enum Constants {
        static let cell = "Cell"
        static let cellHeight: CGFloat = 40
    }

    var dataManager: ServiceProtocol = Service.shared
    var teams: [TeamResponse] = []

    let roomView = RoomView()

    override public func viewDidLoad() {
        configureUI()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Download a list of all public rooms.
        dataManager.listTeams { teams in
            self.teams = teams
            // Update tableView to view downloaded rooms.
            self.roomView.teamsTable.reloadData()
        }
    }

    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(roomView)
        roomView.teamsTable.dataSource = self
        roomView.teamsTable.delegate = self
        roomView.pinHorizontal(to: view)
        roomView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        roomView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        roomView.teamsTable.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)

        roomView.exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }

    @objc
    func exit() {
        // Logout from server.
        dataManager.logout {_ in}
        guard let navigationController = navigationController else {
            return
        }

        // Open login window.
        navigationController.setViewControllers([UIHostingController(rootView: LoginView(navigationController: navigationController))], animated: false)
    }

    @objc
    func joinByCode() {
        guard let navigationController = navigationController else {
            return
        }
        let presenter = JoinByCodePresenter()
        let controller = JoinByCodeViewController(output: presenter)
        presenter.viewInput = controller

        // Open join by code window.
        navigationController.pushViewController(controller, animated: false)
    }

    @objc
    func createRoom() {
        guard let navigationController = navigationController else {
            return
        }
        let presenter = AdminPresenter()
        let controller = AdminViewController(output: presenter)
        presenter.viewInput = controller

        // Open admin window.
        navigationController.pushViewController(controller, animated: false)
    }
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teams.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell was tapped.
        dataManager.joinTeam(teamId: teams[indexPath.row].id, complition: {_ in })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // View room's title in the table view cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        // Prepare for reuse.
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }

        let title = UILabel()
        title.text = teams[indexPath.row].name
        cell.addSubview(title)
        title.pin(to: cell)

        return cell
    }


}
