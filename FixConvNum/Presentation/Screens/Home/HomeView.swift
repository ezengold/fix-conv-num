//
//  HomeView.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import SwiftUI
import Contacts

struct HomeView: View {
	@StateObject var vm: HomeViewModel
	
	@Environment(\.colorScheme) private var colorScheme
	
	@State var isDeleting: Bool = false
	
	@State var tempContact: CNContact?

	@AppStorage(Helpers.hasViewedInfosKey) var hasViewedInfos: Bool = false
	
	@State var isPresentingInfos: Bool = false
	
	var body: some View {
		VStack(spacing: 0) {
			if vm.displayed.isEmpty {
				if !vm.isFetching {
					VStack {
						Spacer()
						Text("Aucun contact détecté")
							.font(.system(size: 15, weight: .regular))
							.frame(maxWidth: .infinity, alignment: .center)
						Spacer()
					}
					.frame(maxHeight: .infinity)
				} else {
					Spacer()
				}
			} else {
				List {
					ForEach(Array(vm.displayed.enumerated()), id: \.0) { _, item in
						ContactCard(contact: .constant(item))
							.swipeActions(edge: .leading, allowsFullSwipe: false) {
								Button("Ignorer", systemImage: "archivebox") {
									isDeleting = true
									tempContact = item
								}
								.tint(Color(UIColor.systemOrange))
							}
							.swipeActions(edge: .trailing) {
								if item.hasIssue() {
									Button("Corriger") {
										vm.fixContact(item)
									}
									.tint(Color.appPrincipal)
								}
							}
					}
				}
				.listStyle(.plain)
				.frame(maxHeight: .infinity)
			}
			
			HStack(spacing: 10) {
				if vm.isFetching {
					Button { } label: {
						Text("Chargement des contacts...")
							.font(.system(size: 17, weight: .bold))
					}
					.frame(maxWidth: .infinity)
					.frame(height: 50, alignment: .center)
					.foregroundColor(.appText)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.appPrincipal.opacity(colorScheme == .dark ? 0.3 : 0.1))
					)
					.disabled(true)
				} else {
					Button {
						vm.fixAllContacts()
					} label: {
						if vm.isLoading {
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle(tint: .white))
						} else {
							Text(vm.issueExistsInList ? "Corriger vos contacts" : "Tous vos contacts sont corrects")
								.font(.system(size: 17, weight: .bold))
						}
					}
					.frame(maxWidth: .infinity)
					.frame(height: 50, alignment: .center)
					.foregroundColor(vm.issueExistsInList ? Color.white : .appPrincipal)
					.disabled(!vm.issueExistsInList)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.appPrincipal.opacity(vm.isLoading ? 0.3 : (vm.issueExistsInList ? 1 : 0.1)))
					)
					.overlay(
						vm.issueExistsInList ?
						nil
						:
							RoundedRectangle(cornerRadius: 10, style: .circular)
							.stroke(Color.appPrincipal.opacity(0.5), lineWidth: 1)
					)
				}
			}
			.padding(10)
		}
		.navigationTitle("Mes contacts")
		.navigationBarItems(trailing: HStack {
			Button("Infos", systemImage: "info.circle", role: .none) {
				isPresentingInfos.toggle()
			}
			Button("Settings", systemImage: "person.crop.circle.fill.badge.plus", role: .none) {
				guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
				
				if UIApplication.shared.canOpenURL(settingsUrl) {
					UIApplication.shared.open(settingsUrl)
				}
			}
		})
		.sheet(isPresented: $isPresentingInfos) {
			InfosView()
		}
		.searchable(text: $vm.keywords, prompt: Text("Rechercher un nom ou prénom"))
		.alert("", isPresented: $vm.isAlertPresented) {
			Button("OK", role: .cancel) { }
		} message: {
			Text(vm.alertMessage)
		}
		.alert("", isPresented: $isDeleting) {
			Button("Oui", role: .destructive) {
				if let _contact = tempContact {
					vm.removeContact(_contact)
				}
			}
			Button("Non", role: .cancel) {
				tempContact = nil
			}
		} message: {
			Text("Êtes-vous sûr de vouloir ignorer ce contact ? Cette action est irréversible !")
		}
		.onAppear {
			isPresentingInfos = !hasViewedInfos
			
			vm.fetchAllData()
		}
	}
}

#Preview {
	HomeView(vm: HomeViewModel())
}
