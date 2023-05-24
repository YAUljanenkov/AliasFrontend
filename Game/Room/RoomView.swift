//
//  RoomView.swift
//  AliasFrontend
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import UIKit

class RoomView: UIView {
    private enum Constants {
        static let title = "Команды"
        static let titleHeight: CGFloat = 32
        static let exitButtonTitle = "Выйти"
        static let offset: CGFloat = 10
    }

    let title = UILabel()
    let teamsTable: UITableView = UITableView()
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
        title.text = Constants.title
        title.pinCenterX(to: self)
        title.pinTop(to: self)
        title.setHeight(Constants.titleHeight)

        self.addSubview(teamsTable)
        teamsTable.pinHorizontal(to: self, Constants.offset)
        teamsTable.pinTop(to: title.bottomAnchor)

        self.addSubview(exitButton)
        exitButton.setTitle(Constants.exitButtonTitle, for: .normal)
        exitButton.pinHorizontal(to: self, Constants.offset)
        exitButton.pinBottom(to: self)
        exitButton.pinTop(to: teamsTable.bottomAnchor, Constants.offset)
    }
}
