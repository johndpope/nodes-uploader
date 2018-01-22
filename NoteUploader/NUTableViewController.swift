//
//  NUTableViewController.swift
//  NoteUploader
//
//  Created by baneDealer on 11/24/17.
//  Copyright © 2017 LY. All rights reserved.
//

import UIKit
import AWSCore
import AWSUserPoolsSignIn
import AWSCognito
import AWSDynamoDB

class NUTableViewController: UITableViewController {

	private let cellId = "cellId"
	private var notes: [NUNote] = []

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return notes.count
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		return NUConstants.TableCellHeight
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: NUTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NUTableViewCell
		let row = indexPath.row
		cell.textLabel?.text = (notes[row] as NUNote).Title
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let noteViewController = NUTableViewCellViewController.init()
		noteViewController.note = notes[indexPath.row]
		self.navigationController?.pushViewController(noteViewController, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
//		loadNoteData()
		generateNoteData()

		title = "Notes"
		view.backgroundColor = UIColor.blue
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		setupTableView()
	}

//------test function-------//
	func generateNoteData() {
		let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
		for index in 0..<5 {
			let note: NUNote = NUNote()
			note.AuthorUsername = NUUser.user.username
			note.Title = String(index+1)
			print(index)
			notes.append(note)
			dynamoDBObjectMapper.save(note).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
				if let error = task.error as NSError? {
					print("The request failed. Error: \(error)")
				} else {
					// Do something with task.result or perform other operations.
				}
				return nil
			})
		}
	}

//	func loadNoteData() {
//		let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
//		dynamoDBObjectMapper.load(Note.self, hashKey: "t1", rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
//			if let error = task.error as NSError? {
//				print("The request failed. Error: \(error)")
//			} else if let resultNote = task.result as? Note {
//				self.notes.append(resultNote)
//
//				// Do something with task.result.
//			}
//			return nil
//		})
//	}

	func setupTableView() {
		tableView.backgroundColor = UIColor.lightGray
		tableView.register(NUTableViewCell.self, forCellReuseIdentifier: cellId)
	}
}

