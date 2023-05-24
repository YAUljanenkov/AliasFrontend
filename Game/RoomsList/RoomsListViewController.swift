//
//  RoomsListViewController.swift
//  AliasFrontend
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import UIKit
import SwiftUI

class RoomsListViewController: UIViewController {
    fileprivate enum Constants {
        static let cell = "Cell"
        static let cellHeight: CGFloat = 40
    }

    var dataManager: ServiceProtocol = Service.shared
    var rooms: [RoomResponse] = []

    let roomListView = RoomListView()

    override public func viewDidLoad() {
        configureUI()
        // Download a list of all public rooms.
        dataManager.listAll { rooms in
            self.rooms = rooms
            // Update tableView to view downloaded rooms.
            self.roomListView.roomsTable.reloadData()
        }
    }

    func configureUI() {
        view.addSubview(roomListView)
        roomListView.roomsTable.dataSource = self
        roomListView.roomsTable.delegate = self
        roomListView.pinHorizontal(to: view)
        roomListView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        roomListView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        roomListView.roomsTable.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)
        roomListView.exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
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
}

extension RoomsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rooms.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell was tapped.
        dataManager.joinRoom(gameRoomId: rooms[indexPath.row].id, complition: {_ in })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // View room's title in the table view cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        let title = UILabel()
        title.text = rooms[indexPath.row].name
        cell.addSubview(title)
        title.pin(to: cell)

        return cell
    }


}
