//
//  FixOneContact.swift
//  FixConvNum
//
//  Created by ezen on 03/12/2024.
//

import Contacts

protocol FixOneContact {
	
	func execute(forContact contact: CNContact) -> Bool
}

struct FixOneContactUseCase: FixOneContact {
	
	var store: CNContactStore
	
	func execute(forContact contact: CNContact) -> Bool {
		// handle migrations to -> 01[oldnumber]
		let updatedContact = Helpers.getMigratedContactIfNecessary(from: contact)
		
		if updatedContact != nil {
			let saveRequest = CNSaveRequest()
			
			saveRequest.update(updatedContact!)
			
			do {
				try store.execute(saveRequest)
			} catch { }
		}
		
		let _contact = updatedContact ?? contact

		// fix migration issues to have both number with and without 01
		if let updatedContact = Helpers.getFixedContactIfNecessary(from: _contact) {
			let saveRequest = CNSaveRequest()
			
			saveRequest.update(updatedContact)
			
			do {
				try store.execute(saveRequest)
			} catch { }
		}
		
		return true
	}
}
