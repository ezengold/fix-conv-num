//
//  Untitled.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import SwiftUI
import Contacts

struct ContactCard: View {
	@Binding var contact: CNContact
	
	@Binding var isSafe: Bool
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack(spacing: 10) {
				Text("\(contact.givenName) \(contact.familyName)")
					.font(.system(size: 17, weight: .semibold))
					.foregroundColor(.appPrincipal)
					.frame(maxWidth: .infinity, alignment: .leading)
				if !isSafe {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.red)
						.frame(width: 10, height: 10)
				}
			}
			.padding(10)
			.frame(maxWidth: .infinity)
			.background(Color.appPrincipal.opacity(0.05))
			.cornerRadius(5)
			
			ForEach(Array(contact.phoneNumbers.enumerated()), id: \.0) { key, item in
				if key != 0 {
					RoundedRectangle(cornerRadius: 2)
						.fill(Color.appDarkGray.opacity(0.1))
						.frame(height: 1)
						.frame(maxWidth: .infinity)
						.padding(.leading, 15)
				}
				Text(item.value.stringValue)
					.font(.system(size: 15, weight: .regular))
					.foregroundColor(.black)
					.padding(5)
					.padding(.leading, 10)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.padding(10)
		.background(Color.white)
		.cornerRadius(10)
		.clipped()
		.shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 0)
	}
}

#Preview {
	let contact = CNMutableContact()
	contact.givenName = "Ezen"
	contact.familyName = "Gold"
	contact.phoneNumbers = [
		CNLabeledValue(
			label: CNLabelPhoneNumberMobile,
			value: CNPhoneNumber(stringValue: "+2290197979797")
		),
		CNLabeledValue(
			label: CNLabelPhoneNumberMobile,
			value: CNPhoneNumber(stringValue: "+2290197979797")
		),
		CNLabeledValue(
			label: CNLabelPhoneNumberMobile,
			value: CNPhoneNumber(stringValue: "+2290197979797")
		),
	]
	
	return ContactCard(contact: .constant(contact), isSafe: .constant(false))
}
