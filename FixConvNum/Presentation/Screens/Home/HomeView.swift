//
//  HomeView.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import SwiftUI

struct HomeView: View {
	@StateObject var vm: HomeViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			ScrollView {
				if vm.displayed.isEmpty {
					if !vm.isFetching {
						Text("Aucun contact détecté")
							.font(.system(size: 15, weight: .regular))
							.frame(maxWidth: .infinity, alignment: .center)
							.padding(.top, 100)
					}
				} else {
					LazyVStack(spacing: 15) {
						ForEach(Array(vm.displayed.enumerated()), id: \.0) { _, item in
							ContactCard(
								contact: .constant(item),
								isSafe: .constant(vm.isValid(item))
							)
						}
					}
					.padding(.horizontal, 15)
					.padding(.top, 20)
					.padding(.bottom, 100)
				}
			}
			
			HStack(spacing: 10) {
				if vm.isFetching {
					Button { } label: {
						Text("Chargement des contacts...")
							.font(.system(size: 17, weight: .bold))
					}
					.frame(maxWidth: .infinity)
					.frame(height: 50, alignment: .center)
					.foregroundColor(Color.appPrincipal)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.appPrincipal.opacity(0.1))
					)
				} else {
					Button {
						vm.fixNumbers()
					} label: {
						if vm.isLoading {
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle(tint: .white))
						} else {
							Text("CORRIGER LES CONTACTS")
								.font(.system(size: 17, weight: .bold))
						}
					}
					.frame(maxWidth: .infinity)
					.frame(height: 50, alignment: .center)
					.foregroundColor(Color.white)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.appPrincipal.opacity(vm.isLoading ? 0.3 : 1))
					)
				}
			}
			.padding(10)
		}
		.onAppear {
			vm.fetchAllData()
		}
		.navigationTitle("Mes contacts")
		.searchable(text: $vm.keywords)
		.alert("", isPresented: $vm.isAlertPresented) {
			Button("OK", role: .cancel) { }
		} message: {
			Text(vm.alertMessage)
		}
	}
}

#Preview {
	HomeView(vm: HomeViewModel())
}
