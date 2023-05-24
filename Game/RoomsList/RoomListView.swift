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
        static let titleHeight: CGFloat = 64
        static let exitButtonTitle = "Выйти"
        static let offset: CGFloat = 10
    }


    let title = UILabel()
    let roomsTable: UITableView = UITableView()
    let exitButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        self.addSubview(title)
        title.pinCenterX(to: self)
        title.pinTop(to: self)
        title.setHeight(Constants.titleHeight)

        self.addSubview(roomsTable)
        roomsTable.pinHorizontal(to: self, Constants.offset)
        roomsTable.pinTop(to: title.bottomAnchor)

        self.addSubview(exitButton)
        exitButton.setTitle(Constants.exitButtonTitle, for: .normal)
        exitButton.pinHorizontal(to: self, Constants.offset)
        exitButton.pinBottom(to: self)
        exitButton.pinTop(to: roomsTable.bottomAnchor)
    }
}
