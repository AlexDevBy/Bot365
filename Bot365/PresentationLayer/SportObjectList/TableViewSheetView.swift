//
//  TableViewSheetView.swift
//  Bot365
//
//  Created by Alex Misko on 23.03.23.
//

import Foundation

import UIKit
import NVActivityIndicatorView
import SnapKit

class TableViewSheetView: UIView {
    
    
    private var isConfigure = false
    
    let sportObjectTableView: UITableView = {
        let tbl = UITableView()
        tbl.contentInset.bottom = 100
        tbl.separatorStyle = .none
        tbl.backgroundColor = UIColor(netHex: 0x091F07)
        tbl.showsVerticalScrollIndicator = false
        return tbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isConfigure else { return }
//        setGradientBackground()
        isConfigure.toggle()
    }
    
    func setupView(for state: SportObjectListViewState) {
        switch state {
        case .locationExist:
            sportObjectTableView.isHidden = false

        case .noLocation:
            sportObjectTableView.isHidden = true
        case .error(let text):
            break
        default:
            break
        }
    }
    

    
    private func setupView() {
        backgroundColor = .white

        addSubview(sportObjectTableView)

        sportObjectTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(85)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
