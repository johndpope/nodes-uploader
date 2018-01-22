//
//  NUViewController.swift
//  NoteUploader
//
//  Created by baneDealer on 11/5/17.
//  Copyright © 2017 LY. All rights reserved.
//

import UIKit
import AWSAuthUI
import AWSUserPoolsSignIn
import AWSCore
import AWSCognito
import AWSS3

class NUViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	var pool: AWSCognitoIdentityUserPool?

	var userNameLabel: UILabel!
	var userPortraitImageView: UIImageView!

	var hasSetupInitialConstraints: Bool = false
	var userHasPortraitImage: Bool = false


	func setupUserPortraitImageView() {
		userPortraitImageView = UIImageView()
		userPortraitImageView.translatesAutoresizingMaskIntoConstraints = false
		userPortraitImageView.backgroundColor = UIColor.red
		userPortraitImageView.isUserInteractionEnabled = true
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userPortraitImageTapped(tapGestureRecognizer:)))
		self.userPortraitImageView.addGestureRecognizer(tapRecognizer)
		self.view.addSubview(userPortraitImageView)
	}

	@objc func userPortraitImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
		if userHasPortraitImage {
			let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
			var noteListViewController = UIViewController()
			if (deviceIdiom == .phone) {
				noteListViewController = NUTableViewController();
			} else {
				noteListViewController = NUCollectionViewController();
			}
			self.navigationController?.pushViewController(noteListViewController, animated: true)
		} else {
			let myPickerController = UIImagePickerController()
			myPickerController.delegate = self;
			myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary

			self.present(myPickerController, animated: true, completion: nil)
		}
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			uploadPortraitToS3(pickedImage)

			dismiss(animated: true, completion: nil)
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	private func uploadPortraitToS3(_ image: UIImage) {
		let data = UIImagePNGRepresentation(image)

		var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
		completionHandler = { (task, error) -> Void in
			DispatchQueue.main.async(execute: {
				if error == nil {
					self.userPortraitImageView.contentMode = .scaleAspectFit
					self.userPortraitImageView.image = image
					self.userHasPortraitImage = true
				}
			})
		}

		let transferUtility = AWSS3TransferUtility.default()

		if let data = data {
			let userS3BucketName = "noteuploader-sample-images2"
			transferUtility.uploadData(data,
									   bucket: userS3BucketName,
									   key: "username/portrait.jpg",
									   contentType: "image/jpeg",
									   expression: nil,
									   completionHandler: completionHandler).continueWith {
										(task) -> AnyObject! in
										if let error = task.error {
											print("Error: \(error.localizedDescription)")
										}
										if let _ = task.result {
											
										}
										return nil;
			}
		}
	}

	func setupUserNameLabel() {
		userNameLabel = UILabel.init()
		userNameLabel.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(userNameLabel)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUserNameLabel()
		setupUserPortraitImageView()

		presentAuthUIViewController()
	}

	override func updateViewConstraints() {
		if (!hasSetupInitialConstraints) {
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: userNameLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 80.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: userNameLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 8.0)])

			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: userPortraitImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.userNameLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 200.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: userPortraitImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: userPortraitImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: -80.0)])
			NSLayoutConstraint.activate([NSLayoutConstraint.init(item: userPortraitImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: userPortraitImageView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)])

			hasSetupInitialConstraints = true
		}
		super.updateViewConstraints();
	}

	func presentAuthUIViewController() {
		let config = AWSAuthUIConfiguration()
		config.enableUserPoolsUI = true
		AWSAuthUIViewController.presentViewController(
			with: navigationController!,
			configuration: config,
			completionHandler: {(
				_ signInProvider: AWSSignInProvider, _ error: Error?) -> Void in
				if error == nil {
					DispatchQueue.main.async(execute: {() -> Void in
						self.loadUserData()
						if let currentUser: AWSCognitoIdentityUser = self.pool?.currentUser() {
							NUUser.user.username = currentUser.username!
							self.userNameLabel.text = "Welcom, " + currentUser.username!
							self.showUserPortraitImageView()
						} else {
							self.userNameLabel.text = "Got no name"
						}
					})
				}
				else {

				}
		})
	}

	func loadUserData() {
		let serviceConfiguration: AWSServiceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: nil)
		let configuration: AWSCognitoIdentityUserPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration.init(clientId: "6vel2u1ne8fv1vo67h39dqqnct", clientSecret: "182tv7kkoodej2kd26ccnbf1io4cc87iagsn4eos4d1e6qeiflp8", poolId: "us-east-1_56kKtm0jI")
		AWSCognitoIdentityUserPool .register(with: serviceConfiguration, userPoolConfiguration: configuration, forKey: "UserPool")
		pool = AWSCognitoIdentityUserPool.init(forKey: "UserPool")
	}

	func showUserPortraitImageView() {
		var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
		completionHandler = { (task, URL, data, error) -> Void in
			if (error) != nil {
				print(error as Any)
			} else {
				self.userHasPortraitImage = true
				DispatchQueue.main.async(execute: {
					self.userPortraitImageView.image = UIImage(data: data!)
				})
			}
		}

		let transferUtility = AWSS3TransferUtility.default()
		let userS3BucketName = "noteuploader-sample-images2"
		transferUtility.downloadData(
			fromBucket: userS3BucketName,
			key: "username/portrait.jpg",
			expression: nil,
			completionHandler: completionHandler
			).continueWith {
				(task) -> AnyObject! in if let error = task.error {
					print("Error: \(error.localizedDescription)")
				}

				if let _ = task.result {

				}
				return nil;
		}
	}
}

