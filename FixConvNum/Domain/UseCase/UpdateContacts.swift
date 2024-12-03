//
//  UpdateContacts.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import Contacts

protocol UpdateContacts {
	
	func execute() async -> Bool
}

struct UpdateContactsUseCase: UpdateContacts {
	
	var store: CNContactStore
	
	func execute() async -> Bool {
		var contacts = await FetchContactsUseCase(store: store).execute()
		
		// handle migrations to -> 01[oldnumber]
		for contact in contacts {
			if let updatedContact = Helpers.getMigratedContactIfNecessary(from: contact) {
				let saveRequest = CNSaveRequest()
				
				saveRequest.update(updatedContact)
				
				do {
					try store.execute(saveRequest)
					continue
				} catch {
					continue
				}
			}
		}
		
		contacts = await FetchContactsUseCase(store: store).execute()
		
		// fix migration issues to have both number with and without 01
		for contact in contacts {
			if let updatedContact = Helpers.getFixedContactIfNecessary(from: contact) {
				let saveRequest = CNSaveRequest()
				
				saveRequest.update(updatedContact)
				
				do {
					try store.execute(saveRequest)
					continue
				} catch {
					continue
				}
			}
		}
		
		return true
	}
}

extension String {
	
	func withoutSpaces() -> String {
		return self.replacingOccurrences(of: " ", with: "")
	}
}
