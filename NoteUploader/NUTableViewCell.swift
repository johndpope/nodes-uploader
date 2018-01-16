//
//  NUTableViewCell.swift
//  NoteUploader
//
//  Created by baneDealer on 11/24/17.
//  Copyright © 2017 LY. All rights reserved.
//

import UIKit

class NUTableViewCell: UITableViewCell {

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		contentView.backgroundColor = UIColor.white
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
