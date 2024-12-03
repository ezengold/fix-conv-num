//
//  RemoveContact.swift
//  FixConvNum
//
//  Created by ezen on 03/12/2024.
//

import Contacts

protocol RemoveContact {
	
	func execute(forContact contact: CNContact) -> Bool
}

struct RemoveContactUseCase: RemoveContact {
	
	var store: CNContactStore
	
	func execute(forContact contact: CNContact) -> Bool {
		do {
			guard let mutableContact = contact.mutableCopy() as? CNMutableContact else { return false }
			
			let saveRequest = CNSaveRequest()
			
			saveRequest.delete(mutableContact)

			try store.execute(saveRequest)

			return true
		} catch {
			return false
		}
	}
}
