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
	
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		HStack(spacing: 15) {
			if contact.hasIssue() {
				Image(systemName: "person.crop.circle.badge.exclamationmark")
					.resizable()
					.scaledToFit()
					.frame(width: 50, height: 50)
					.foregroundColor(Color.appRed)
			} else {
				Text(contact.shortName)
					.font(.system(size: 18, weight: .semibold))
					.foregroundColor(.appText)
					.frame(width: 50, height: 50)
					.background(Color.appText.opacity(colorScheme == .dark ? 0.08 : 0.04))
					.cornerRadius(50 / 2)
					.overlay(
						RoundedRectangle(cornerRadius: 50/2, style: .circular)
							.stroke(Color.appText.opacity(0.1), lineWidth: 1)
					)
			}
			VStack(alignment: .leading, spacing: 5) {
				Text("\(contact.givenName) **\(contact.familyName)**")
					.font(.system(size: 17, weight: .regular))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text(contact.phoneNumbers.map({ $0.value.stringValue }).joined(separator: ", "))
					.font(.system(size: 15, weight: .regular))
					.foregroundColor(.appText)
					.multilineTextAlignment(.leading)
					.lineSpacing(2)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
	}
}

#Preview {
	let contact = CNMutableContact()
	contact.givenName = "Ezen"
	contact.familyName = "Gold"
	contact.phoneNumbers = [
		CNLabeledValue(
			label: CNLabelPhoneNumberMobile,
			value: CNPhoneNumber(stringValue: "+22997979797")
		),
		CNLabeledValue(
			label: CNLabelPhoneNumberMobile,
			value: CNPhoneNumber(stringValue: "0197979798")
		),
	]
	
	return ContactCard(contact: .constant(contact))
}
