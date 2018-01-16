//
//  NUNote.swift
//  NoteUploader
//
//  Created by baneDealer on 11/25/17.
//  Copyright © 2017 LY. All rights reserved.
//

import Foundation
import AWSCore
import AWSDynamoDB

class NUNote : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
	var AuthorUsername: String!
	var Title: String!

	static func dynamoDBTableName() -> String {
		return "Notes"
	}

	static func hashKeyAttribute() -> String {
		return "AuthorUsername"
	}

	static func rangeKeyAttribute() -> String {
		return "Title"
	}
}
