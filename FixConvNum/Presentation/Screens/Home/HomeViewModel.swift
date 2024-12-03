//
//  HomeViewModel.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import Contacts

class HomeViewModel: ObservableObject {
	static let ContactStore = CNContactStore()
	
	@Published var keywords: String = ""
	
	@Published var data = [CNContact]()
	
	var displayed: [CNContact] {
		get {
			getFilteredData()
		}
	}
	
	var issueExistsInList: Bool {
		get {
			self.data.contains(where: { $0.hasIssue() })
		}
	}
	
	// MARK: Use cases
	var fetchContactsUseCase = FetchContactsUseCase(store: ContactStore)
	
	var updateContactsUseCase = UpdateContactsUseCase(store: ContactStore)
	
	var fixOneContactUseCase = FixOneContactUseCase(store: ContactStore)
	
	var removeOneContactUseCase = RemoveContactUseCase()
	
	@Published var isFetching: Bool = true
	
	@Published var isLoading: Bool = false
	
	// handle alert
	@Published var isAlertPresented: Bool = false
	
	@Published var alertMessage: String = ""
	
	func getFilteredData() -> [CNContact] {
		let predicate = NSPredicate(format: "SELF contains[c] %@", self.keywords)
		
		if keywords.isEmpty {
			return self.data
		} else {
			return self.data
				.filter {
					predicate.evaluate(with: $0.givenName.uppercased()) ||
					predicate.evaluate(with: $0.familyName.uppercased())
				}
		}
	}
	
	func isValid(_ contact: CNContact) -> Bool {
		// case of numbers not already migrated
		let _possiblyNotMigratedNumbers = contact.phoneNumbers.filter({
			$0.value.stringValue.withoutSpaces().count == 8 ||
			($0.value.stringValue.withoutSpaces().hasPrefix("+229") && $0.value.stringValue.withoutSpaces().count == 12) ||
			($0.value.stringValue.withoutSpaces().hasPrefix("229") && $0.value.stringValue.withoutSpaces().count == 11) ||
			($0.value.stringValue.withoutSpaces().hasPrefix("00229") && $0.value.stringValue.withoutSpaces().count == 13)
		})
		
		var isCorrect = true
		
		for number in _possiblyNotMigratedNumbers {
			let numberString = number.value.stringValue.withoutSpaces()
			
			var actualNumber: String = ""
			
			if numberString.count == 8 {
				actualNumber = numberString
			} else if numberString.hasPrefix("+229") && numberString.count == 12 {
				actualNumber = String(numberString[numberString.index(numberString.startIndex, offsetBy: 4)...])
			} else if numberString.hasPrefix("229") && numberString.count == 11 {
				actualNumber = String(numberString[numberString.index(numberString.startIndex, offsetBy: 3)...])
			} else if numberString.hasPrefix("00229") && numberString.count == 13 {
				actualNumber = String(numberString[numberString.index(numberString.startIndex, offsetBy: 5)...])
			}
			
			let isFixed = contact.phoneNumbers.contains(where: { $0.value.stringValue.withoutSpaces() == "+22901\(actualNumber)" })
			
			isCorrect = isCorrect && isFixed
		}
		
		// case of numbers not fixed back by migration
		let _numbers = contact.phoneNumbers.filter({
			$0.value.stringValue.withoutSpaces().starts(with: "+22901") ||
			$0.value.stringValue.withoutSpaces().starts(with: "01")
		})
		
		guard _numbers.count > 0 else { return true }
		
		for number in _numbers {
			let numberString = number.value.stringValue.withoutSpaces()
			
			let actualNumber = numberString[numberString.index(numberString.startIndex, offsetBy: numberString.hasPrefix("+22901") ? 6 : 2)...]
			
			let isFixed = contact.phoneNumbers.contains(where: { $0.value.stringValue.withoutSpaces() == "+229\(actualNumber)" })
			
			isCorrect = isCorrect && isFixed
		}
		
		return isCorrect
	}
	
	func fetchAllData() {
		DispatchQueue.main.async {
			self.isFetching = true
		}
		Task {
			let _data = await fetchContactsUseCase.execute()
			DispatchQueue.main.async {
				self.data = _data
				self.isFetching = false
			}
		}
	}
	
	func fixAllContacts() {
		DispatchQueue.main.async {
			self.isLoading = true
		}
		
		Task {
			if await updateContactsUseCase.execute() {
				self.fetchAllData()
				
				DispatchQueue.main.async {
					self.isLoading = false
					self.alertMessage = "Les contacts ont été corrigés avec succès ✅"
					self.isAlertPresented = true
				}
			} else {
				DispatchQueue.main.async {
					self.isLoading = false
					self.alertMessage = "Une erreur est survenue lors de la correction des contacts ❌"
					self.isAlertPresented = true
				}
			}
		}
	}
	
	func fixContact(_ contact: CNContact) {
		DispatchQueue.main.async {
			self.isLoading = true
		}
		
		Task {
			if await fixOneContactUseCase.execute(forContact: contact) {
				self.fetchAllData()
				
				DispatchQueue.main.async {
					self.isLoading = false
					self.alertMessage = "Les numeros de \(contact.givenName) \(contact.familyName) ont été corrigés ✅"
					self.isAlertPresented = true
				}
			} else {
				DispatchQueue.main.async {
					self.isLoading = false
					self.alertMessage = "Une erreur est survenue lors de la correction des numeros de \(contact.givenName) \(contact.familyName) ❌"
					self.isAlertPresented = true
				}
			}
		}
	}
	
	func removeContact(_ contact: CNContact) {
		DispatchQueue.main.async {
			self.isLoading = true
		}
		
		Task {
			if removeOneContactUseCase.execute(forContact: contact) {
				self.fetchAllData()
				
				DispatchQueue.main.async {
					self.isLoading = false
					self.alertMessage = "Le contact \(contact.givenName) \(contact.familyName) a été retiré ✅"
					self.isAlertPresented = true
				}
			} else {
				DispatchQueue.main.async {
					self.isLoading = false
					self.alertMessage = "Une erreur est survenue lors du retrait du contact \(contact.givenName) \(contact.familyName) ❌"
					self.isAlertPresented = true
				}
			}
		}
	}
}
