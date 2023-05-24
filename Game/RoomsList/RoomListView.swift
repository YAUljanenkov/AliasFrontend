//
//  RoomListView.swift
//  AliasFrontend
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import UIKit

class RoomListView: UIView {
    private enum Constants {
        static let title = "Открытые комнаты"
        static let titleHeight: CGFloat = 32
        static let exitButtonTitle = "Выйти"
        static let joinByCodeTitle = "Войти по коду"
        static let createRoomTitle = "Создать комнату"
        static let offset: CGFloat = 10
    }

    let title = UILabel()
    let roomsTable: UITableView = UITableView()
    let createRoom: UIButton = UIButton()
    let joinByCode: UIButton = UIButton()
    let exitButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        configureTitle()
        configureTableView()
        configureCreateButton()
        configureJoinButton()
        configureExitButton()
    }

    private func configureTitle() {
        self.addSubview(title)
        title.text = Constants.title
        title.pinCenterX(to: self)
        title.pinTop(to: self)
        title.setHeight(Constants.titleHeight)
    }

    private func configureTableView() {
        self.addSubview(roomsTable)
        roomsTable.pinHorizontal(to: self, Constants.offset)
        roomsTable.pinTop(to: title.bottomAnchor, Constants.offset)
    }

    private func configureCreateButton() {
        self.addSubview(createRoom)
        createRoom.setTitle(Constants.createRoomTitle, for: .normal)
        createRoom.pinHorizontal(to: self, Constants.offset)
        createRoom.pinTop(to: roomsTable.bottomAnchor, Constants.offset)
        createRoom.setTitleColor(.blue, for: .normal)
    }

    private func configureJoinButton() {
        self.addSubview(joinByCode)
        joinByCode.setTitle(Constants.joinByCodeTitle, for: .normal)
        joinByCode.pinHorizontal(to: self, Constants.offset)
        joinByCode.pinTop(to: createRoom.bottomAnchor, Constants.offset)
        joinByCode.setTitleColor(.blue, for: .normal)
    }

    private func configureExitButton() {
        self.addSubview(exitButton)
        exitButton.setTitle(Constants.exitButtonTitle, for: .normal)
        exitButton.pinHorizontal(to: self, Constants.offset)
        exitButton.pinBottom(to: self)
        exitButton.pinTop(to: joinByCode.bottomAnchor, Constants.offset)
        exitButton.setTitleColor(.blue, for: .normal)
    }
}
