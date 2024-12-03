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
	
	func execute(forContact contact: CNContact) -> Bool {
		UserDefaults.addToTrash(contactId: contact.identifier)
		return true
	}
}
