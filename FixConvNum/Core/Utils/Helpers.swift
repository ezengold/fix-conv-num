//
//  Helpers.swift
//  FixConvNum
//
//  Created by ezen on 02/12/2024.
//
import Contacts

struct Helpers {
	
	static let localPhoneRegex: String = "^(\\+229|00229)?(40|41|42|43|44|45|46|47|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|90|91|92|93|94|95|96|97|98|99)\\d{6}$"
	
	static let extendedPhoneRegex: String = "^(\\+229|00229)?(01){1}(40|41|42|43|44|45|46|47|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|90|91|92|93|94|95|96|97|98|99)\\d{6}$"
	
	static let hasViewedInfosKey: String = "hasViewedInfos"
	
	static func getMigratedContactIfNecessary(from contact: CNContact) -> CNMutableContact? {
		guard let mutableContact = contact.mutableCopy() as? CNMutableContact else { return nil }
		
		let numbers = contact.phoneNumbers.filter({ $0.isLocalNumber() })
		
		var notChanged: Bool = true
		
		for number in numbers {
			let numberString = number.value.stringValue.withoutSpaces()
			
			let actualNumber = numberString.suffix(8)
			
			let hasBeenFixedAlready = contact.phoneNumbers.contains(where: {
				$0.value.stringValue.withoutSpaces() == "+22901\(actualNumber)" ||
				$0.value.stringValue.withoutSpaces() == "01\(actualNumber)" ||
				$0.value.stringValue.withoutSpaces() == "0022901\(actualNumber)"
			})
			
			if !hasBeenFixedAlready {
				print("01[number] > \(contact.givenName) \(contact.familyName) | added number: +22901\(actualNumber)")

				mutableContact.phoneNumbers.append(CNLabeledValue(
					label: CNLabelPhoneNumberMobile,
					value: CNPhoneNumber(stringValue: "+22901\(actualNumber)")
				))
				
				notChanged = notChanged && false
			}
		}
		
		return notChanged ? nil : mutableContact
	}
	
	static func getFixedContactIfNecessary(from contact: CNContact) -> CNMutableContact? {
		guard let mutableContact = contact.mutableCopy() as? CNMutableContact else { return nil }
		
		let numbers = contact.phoneNumbers.filter({ $0.isExtendedNumber() })
		
		var notChanged: Bool = true
		
		for number in numbers {
			let numberString = number.value.stringValue.withoutSpaces()
			
			let actualNumber = numberString.suffix(8)
			
			let hasBeenFixedAlready = contact.phoneNumbers.contains(where: {
				$0.value.stringValue.withoutSpaces() == actualNumber ||
				$0.value.stringValue.withoutSpaces() == "+229\(actualNumber)" ||
				$0.value.stringValue.withoutSpaces() == "00229\(actualNumber)"
			})
			
			if !hasBeenFixedAlready {
				print("Fix[number] > \(contact.givenName) \(contact.familyName) | added number: +229\(actualNumber)")

				mutableContact.phoneNumbers.append(CNLabeledValue(
					label: CNLabelPhoneNumberMobile,
					value: CNPhoneNumber(stringValue: "+229\(actualNumber)")
				))
				
				notChanged = notChanged && false
			}
		}
		
		return notChanged ? nil : mutableContact
	}
}
