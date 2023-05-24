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
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Download a list of all public rooms.
        dataManager.listAll { rooms in
            self.rooms = rooms
            // Update tableView to view downloaded rooms.
            self.roomListView.roomsTable.reloadData()
        }
    }

    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(roomListView)
        roomListView.roomsTable.dataSource = self
        roomListView.roomsTable.delegate = self
        roomListView.pinHorizontal(to: view)
        roomListView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        roomListView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        roomListView.roomsTable.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)

        roomListView.exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        roomListView.joinByCode.addTarget(self, action: #selector(joinByCode), for: .touchUpInside)
        roomListView.createRoom.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
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

extension RoomsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rooms.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell was tapped.
        dataManager.joinRoom(gameRoomId: rooms[indexPath.row].id, complition: { response in
            guard let navigationController = self.navigationController else {
                return
            }

            // Open room window.
            navigationController.setViewControllers([RoomViewController()], animated: false)
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // View room's title in the table view cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        // Prepare for reuse.
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }

        let title = UILabel()
        title.text = rooms[indexPath.row].name
        cell.addSubview(title)
        title.pin(to: cell)

        return cell
    }


}
