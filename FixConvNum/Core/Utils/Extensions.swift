//
//  Extensions.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//


import Foundation
import SwiftUI

extension UIViewController {
	
	func hideKeyboardWhenTappedAround() {
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
	}
	
	@objc
	func hideKeyboard() {
		view.endEditing(true)
	}
}

extension Color {
	
	static let appPrincipal: Color = Color("AccentColor")
	
	static let appDarkGray: Color = Color(red: 63/255, green: 63/255, blue: 63/255)
	
	static let appText: Color = Color(UIColor.label)
	
	static let appBackground: Color = Color(UIColor.systemBackground)
	
	static let appRed: Color = Color(UIColor.systemRed)
}

extension UIColor {
	
	static let appPrincipal: UIColor = UIColor(named: "AccentColor") ?? .init(red: 0.251, green: 0.482, blue: 1.0, alpha: 1.0)
}

extension UIApplication {
	
	class func getPresentedViewController() -> UIViewController? {
		
		var presentViewController = UIApplication
			.shared
			.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.flatMap { $0.windows }
			.last { $0.isKeyWindow }?.rootViewController
		
		while let pVC = presentViewController?.presentedViewController {
			presentViewController = pVC
		}
		
		return presentViewController
	}
}

extension UserDefaults {
	
	static var TRASH_KEY: String { "\(Bundle.main.bundleIdentifier ?? "").IGNORED_CONTACTS_BIN" }
	
	static var shared: UserDefaults {
		let _instance = UserDefaults.standard
		return _instance
	}
	
	static func addToTrash(contactId id: String) {
		
		if let _array = shared.array(forKey: TRASH_KEY) {
			guard !_array.contains(where: { ($0 as? String) == id }) else { return }
			
			var updated = _array
			updated.append(id)
			shared.set(updated, forKey: TRASH_KEY)
		} else {
			shared.set([id], forKey: TRASH_KEY)
		}
	}
	
	static func hasInTrash(aContactOfId ofId: String) -> Bool {
		
		if let _array = shared.array(forKey: TRASH_KEY) {
			return _array.contains(where: { ($0 as? String) == ofId })
		} else {
			return false
		}
	}
}
