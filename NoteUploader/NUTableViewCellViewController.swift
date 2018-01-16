//
//  NUTableViewCellViewController.swift
//  NoteUploader
//
//  Created by baneDealer on 11/24/17.
//  Copyright © 2017 LY. All rights reserved.
//

import UIKit

class NUTableViewCellViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	var note: NUNote?

	var titleLabel: UITextField!
	var edittingView: UITextView!
	var uploadedImageView: UIImageView!

	var hasSetupInitialConstraints: Bool = false

	func setupUploadedImageView() {
		uploadedImageView = UIImageView.init()
		uploadedImageView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(uploadedImageView)
	}

	func setupEdittingView() {
		edittingView = UITextView.init()
		edittingView.translatesAutoresizingMaskIntoConstraints = false
		edittingView.layer.borderWidth = 0.5
		edittingView.layer.borderColor = UIColor.darkGray.cgColor
		self.view.addSubview(edittingView)
	}

	func setupTitleLabel() {
		titleLabel = UITextField.init()
		titleLabel.text = note?.Title
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.placeholder = "Enter your note title"
		titleLabel.borderStyle = UITextBorderStyle.line
		self.view.addSubview(titleLabel)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let rootView: UIScrollView = UIScrollView.init()
		rootView.contentSize = CGSize.init(width: 400, height: 800)
		self.view = rootView
		setupTitleLabel()
		setupEdittingView()
		setupUploadedImageView()

		let navRightButton: UIBarButtonItem = UIBarButtonItem.init(title: "Add Image", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NUTableViewCellViewController.displayImagePickerButtonTapped(_:)))
		self.navigationItem.rightBarButtonItem = navRightButton
	}

	@objc func displayImagePickerButtonTapped(_ sender:UIButton!) {

		let photoPickerController = UIImagePickerController()
		photoPickerController.delegate = self;
		photoPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary

		self.present(photoPickerController, animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.uploadedImageView.contentMode = .scaleAspectFit
			self.uploadedImageView.image = pickedImage

			dismiss(animated: true, completion: nil)
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	override func updateViewConstraints() {
		if (!hasSetupInitialConstraints) {
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 8.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: titleLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])

			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: edittingView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 8.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: edittingView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: edittingView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: -80.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: edittingView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: edittingView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)])

			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: uploadedImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.edittingView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 8.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: uploadedImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: uploadedImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: -80.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: uploadedImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.uploadedImageView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)])

			hasSetupInitialConstraints = true
		}
		super.updateViewConstraints();
	}
}
