//
//  InfosView.swift
//  FixConvNum
//
//  Created by ezen on 03/12/2024.
//

import SwiftUI
import Contacts

struct InfosView: View {
	@Environment(\.colorScheme) private var colorScheme
	
	@AppStorage(Helpers.hasViewedInfosKey) var hasViewedInfos: Bool = false
	
	var correctContact: CNContact {
		let _ctc = CNMutableContact()
		_ctc.givenName = "Steve"
		_ctc.familyName = "Jobs"
		_ctc.phoneNumbers = [
			CNLabeledValue(
				label: CNLabelPhoneNumberMobile,
				value: CNPhoneNumber(stringValue: "+22900000001")
			),
			CNLabeledValue(
				label: CNLabelPhoneNumberMobile,
				value: CNPhoneNumber(stringValue: "0100000001")
			),
		]
		return _ctc
	}
	
	var incorrectContact: CNContact {
		let _ctc = CNMutableContact()
		_ctc.givenName = "Steve"
		_ctc.familyName = "Jobs"
		_ctc.phoneNumbers = [
			CNLabeledValue(
				label: CNLabelPhoneNumberMobile,
				value: CNPhoneNumber(stringValue: "97000000")
			)
		]
		return _ctc
	}
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: 0) {
				Text("Comment utiliser FixConvNum ?")
					.font(.system(size: 18, weight: .bold))
					.frame(maxWidth: .infinity, alignment: .center)
					.padding(10)
					.padding(.bottom, 20)
				
				ContactCard(contact: .constant(correctContact))
					.padding(10)
					.overlay (
						RoundedRectangle(cornerRadius: 10, style: .continuous)
							.stroke(Color.appText.opacity(colorScheme == .dark ? 0.1 : 0.07), lineWidth: 1)
					)
				Group {
					Text("Les contacts affichés suivant le format ci-dessus ont tous leurs numéros") +
					Text(" béninois ").foregroundColor(colorScheme == .dark ? Color(UIColor.green) : Color.appPrincipal).font(.system(size: 15, weight: .bold)) +
					Text("déjà migrés et contiennent aussi le format non migré pour permettre aux applications sociales comme") +
					Text(" **WhatsApp** ").foregroundColor(colorScheme == .dark ? Color(UIColor.green) : Color.appPrincipal).font(.system(size: 15, weight: .bold)) +
					Text("de les identifier.")
				}
				.font(.system(size: 15, weight: .regular))
				.lineSpacing(9)
				.padding(.top, 10)
				.padding(.bottom, 40)
				
				ZStack(alignment: .leading) {
					Image(systemName: "archivebox.fill")
						.foregroundColor(.white)
						.frame(width: 80)
						.frame(maxHeight: .infinity)
						.background(Color(UIColor.systemOrange))
					ContactCard(contact: .constant(correctContact))
						.padding(10)
						.offset(x: 80)
				}
				.cornerRadius(10)
				.overlay (
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.stroke(Color.appText.opacity(colorScheme == .dark ? 0.1 : 0.07), lineWidth: 1)
				)
				.clipped()
				Text("Vous pouvez ignorer certains contacts en les glissant vers la droite. Ces derniers seront retirés de l'application mais pas de votre répertoire téléphonique. Ils ne seront pas altérés.")
					.font(.system(size: 15, weight: .regular))
					.lineSpacing(9)
					.padding(.top, 10)
					.padding(.bottom, 40)
				
				ContactCard(contact: .constant(incorrectContact))
					.padding(10)
					.overlay (
						RoundedRectangle(cornerRadius: 10, style: .continuous)
							.stroke(Color.appText.opacity(colorScheme == .dark ? 0.1 : 0.07), lineWidth: 1)
					)
				Group {
					Text("Les contacts affichés suivant le format ci-dessus se retrouvent dans le cas contraire. C'est-à-dire qu'ils") +
					Text(" n'ont pas été migré ").foregroundColor(.red).font(.system(size: 15, weight: .bold)) +
					Text(" ou que lors de la migration, ils ont été ") +
					Text(" remplacés ").foregroundColor(.red).font(.system(size: 15, weight: .bold)) +
					Text(" par le nouveau format des numeros béninois. Ils sont à l'origine des problèmes rencontrés dans l'application **WhatsApp** par exemple.")
				}
				.font(.system(size: 15, weight: .regular))
				.lineSpacing(9)
				.padding(.top, 10)
				.padding(.bottom, 40)
				
				HStack {
					ContactCard(contact: .constant(incorrectContact))
						.padding(10)
						.offset(x: -80)
					Text("Corriger")
						.foregroundColor(.white)
						.font(.system(size: 15))
						.padding(.horizontal, 10)
						.frame(maxHeight: .infinity)
						.background(Color.appPrincipal)
				}
				.cornerRadius(10)
				.overlay (
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.stroke(Color.appText.opacity(colorScheme == .dark ? 0.1 : 0.07), lineWidth: 1)
				)
				.clipped()
				Text("Vous pouvez aussi corriger un contact à la fois, en le glissant vers la gauche.")
					.font(.system(size: 15, weight: .regular))
					.lineSpacing(9)
					.padding(.top, 10)
				
				Text("Si vous désirez modifier les contacts auquels auront accès cette application, veuillez cliquer sur l'icône dans le coin supérieur droit comme présenté ci-dessous :")
					.font(.system(size: 15, weight: .regular))
					.lineSpacing(9)
					.padding(.top, 30)
					.padding(.bottom, 10)
				ZStack(alignment: .topTrailing) {
					VStack {
						HStack {
							Spacer()
							Image(systemName: "ellipsis.circle")
								.foregroundColor(.appPrincipal)
						}
						Text("Mes contacts")
							.font(.system(size: 30, weight: .bold))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.top, 15)
					}
					Image(systemName: "line.diagonal.arrow")
						.resizable()
						.scaledToFit()
						.foregroundColor(.appRed)
						.frame(width: 30)
						.offset(x: -23, y: 20)
				}
				.cornerRadius(10)
				.padding(10)
				.frame(maxWidth: .infinity)
				.overlay (
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.stroke(Color.appText.opacity(colorScheme == .dark ? 0.1 : 0.07), lineWidth: 1)
				)
				.clipped()
				Text("Puis vous choisissez l'option des paramètres. Vous serez redirigés vers les paramètres de votre téléphone pour modifier les conditions d'accès au répertoire téléphonique.")
					.font(.system(size: 15, weight: .regular))
					.lineSpacing(9)
					.padding(.top, 20)
				
				Text("By \(Text("[@ezengold](https://www.linkedin.com/in/ezengold/)").underline().foregroundColor(.appPrincipal))")
					.font(.system(size: 15, weight: .regular))
					.fontDesign(.monospaced)
					.lineSpacing(10)
					.frame(maxWidth: .infinity, alignment: .center)
					.padding(.top, 100)
			}
			.frame(maxWidth: .infinity)
			.padding(20)
			.padding(.bottom, 100)
			.onAppear {
				hasViewedInfos = true
			}
		}
	}
}

#Preview {
    InfosView()
}
