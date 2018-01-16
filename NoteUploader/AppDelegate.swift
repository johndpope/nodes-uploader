//
//  AppDelegate.swift
//  NoteUploader
//
//  Created by baneDealer on 11/5/17.
//  Copyright © 2017 LY. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSUserPoolsSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	// set up the initialized flag
	var isInitialized = false

	func application(_ application: UIApplication, open url: URL,
					 sourceApplication: String?, annotation: Any) -> Bool {

		// finished launching

		AWSSignInManager.sharedInstance().interceptApplication(
			application, open: url,
			sourceApplication: sourceApplication,
			annotation: annotation)

		if (!isInitialized) {
			isInitialized = true
		}

		return false;
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		AWSSignInManager.sharedInstance().register(
			signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance())

		let didFinishLaunching:
			Bool = AWSSignInManager.sharedInstance().interceptApplication(
				application, didFinishLaunchingWithOptions: launchOptions)

		if (!isInitialized) {
			AWSSignInManager.sharedInstance().resumeSession(completionHandler: {
				(result: Any?,  error: Error?) in

				// print("Result: \(result)\n Error:\(error)")
			})

			isInitialized = true

		}

		let credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: AWSRegionType.USEast1, identityPoolId: "us-east-1:d09703ff-3aea-405b-999c-75b638e9b860")
		let configuration = AWSServiceConfiguration.init(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
		AWSServiceManager.default().defaultServiceConfiguration = configuration

		if (didFinishLaunching) {
			self.window = UIWindow(frame: UIScreen.main.bounds)
			let nav = UINavigationController()
			let signinView = NUViewController()
			nav.viewControllers = [signinView]
			self.window?.rootViewController = nav
			self.window?.backgroundColor = UIColor.white;
			self.window?.makeKeyAndVisible()
		}
		return didFinishLaunching
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

