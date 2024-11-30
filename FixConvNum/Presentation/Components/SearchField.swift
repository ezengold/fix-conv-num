//
//  SearchField.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import SwiftUI

struct SearchField: View {
	var title: String = NSLocalizedString("Search a contact", comment: "")
	
	@Binding var value: String
	
	var onCommit: () -> Void = { }
	
	var body: some View {
		HStack(spacing: 5) {
			Image(systemName: "magnifyingglass")
				.resizable()
				.scaledToFit()
				.frame(width: 15, height: 15)
				.foregroundColor(.appDarkGray)
				.padding(.leading, 10)
				.padding(.trailing, 5)
			ZStack {
				if value.isEmpty {
					Text(title)
						.font(.system(size: 15, weight: .regular))
						.foregroundColor(.black)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				TextField("", text: $value, onCommit: onCommit)
					.font(.system(size: 15, weight: .regular))
					.foregroundColor(.black)
					.accentColor(.black)
					.autocorrectionDisabled()
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.frame(height: 35)
		.frame(maxWidth: .infinity)
		.background(Color.black.opacity(0.05))
		.cornerRadius(10)
	}
}

#Preview {
	SearchField(value: .constant(""))
}
