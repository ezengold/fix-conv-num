//
//  FetchContacts.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import Contacts

protocol FetchContacts {
	
	func execute() async -> [CNContact]
}

struct FetchContactsUseCase: FetchContacts {
	
	var store: CNContactStore
	
	func execute() async -> [CNContact] {
		guard await self.isPermissionGranted() else { return [] }
		
		do {
			var contacts = [CNContact]()
			
			let keys = [
				CNContactGivenNameKey,
				CNContactFamilyNameKey,
				CNContactPhoneNumbersKey
			] as [CNKeyDescriptor]
			
			try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys)) { _contact, stop in
				if !UserDefaults.hasInTrash(aContactOfId: _contact.identifier) && _contact.canBeDisplayed() {
					contacts.append(_contact)
				}
			}
			
			return contacts
		} catch {
			return []
		}
	}
	
	private func isPermissionGranted() async -> Bool {
		let status = CNContactStore.authorizationStatus(for: .contacts)
		
		switch status {
		case .notDetermined:
			return await self.requestPermission()
		case .restricted:
			return false
		case .denied:
			return false
		case .authorized:
			return true
		case .limited:
			return true
		default:
			return false
		}
	}
	
	func requestPermission() async -> Bool {
		do {
			let _response = try await store.requestAccess(for: .contacts)
			return _response
		} catch {
			return false
		}
	}
}

extension CNContact {
	
	func canBeDisplayed() -> Bool {
		self.phoneNumbers.contains(where: { $0.isLocalNumber() || $0.isExtendedNumber() })
	}
	
	func hasIssue() -> Bool {
		var isValid: Bool = true
		
		for _number in self.phoneNumbers {
			let actualNumber = _number.value.stringValue.withoutSpaces().suffix(8)

			if _number.isLocalNumber() {
				isValid = isValid && self.phoneNumbers.contains(where: {
					$0.value.stringValue.withoutSpaces() == "+22901\(actualNumber)" ||
					$0.value.stringValue.withoutSpaces() == "0022901\(actualNumber)" ||
					$0.value.stringValue.withoutSpaces() == "01\(actualNumber)"
				})
			} else if _number.isExtendedNumber() {
				isValid = isValid && self.phoneNumbers.contains(where: {
					$0.value.stringValue.withoutSpaces() == actualNumber ||
					$0.value.stringValue.withoutSpaces() == "+229\(actualNumber)" ||
					$0.value.stringValue.withoutSpaces() == "00229\(actualNumber)"
				})
			}
		}
		
		return !isValid
	}
	
	var shortName: String {
		let firstLetter = self.givenName.first?.uppercased() ?? ""
		let secondLetter = self.familyName.first?.uppercased() ?? ""
		return "\(firstLetter)\(secondLetter)"
	}
}

extension CNLabeledValue<CNPhoneNumber> {
	
	func isLocalNumber() -> Bool {
		self.value.stringValue.withoutSpaces().range(of: Helpers.localPhoneRegex, options: .regularExpression) != nil
	}
	
	func isExtendedNumber() -> Bool {
		self.value.stringValue.withoutSpaces().range(of: Helpers.extendedPhoneRegex, options: .regularExpression) != nil
	}
}
