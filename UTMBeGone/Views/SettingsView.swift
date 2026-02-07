//
//  SettingsView.swift
//  UTMBeGone
//
//  Created by Fernando Bunn.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var selection = Set<QueryItem.ID>()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(UserText.queryParametersHeader)
                .font(.headline)
                .padding([.top, .horizontal])

            List(selection: $selection) {
                ForEach(appState.queryItemsManager.queryList) { item in
                    TextField(UserText.parameterPlaceholder, text: Binding(
                        get: { item.value },
                        set: { appState.queryItemsManager.updateValue(for: item.id, newValue: $0) }
                    ))
                }
                .onDelete { offsets in
                    appState.queryItemsManager.delete(at: offsets)
                }
            }

            HStack {
                Button(action: { appState.queryItemsManager.createNewItem() }) {
                    Image(systemName: "plus")
                        .frame(width: 16, height: 16)
                }

                Button(action: { deleteSelected() }) {
                    Image(systemName: "minus")
                        .frame(width: 16, height: 16)
                }
                .disabled(selection.isEmpty)

                Button(action: { appState.openProjectWebsite() }) {
                    Text(UserText.projectWebsite)
                }
                .buttonStyle(.link)
                .padding(.leading, 8)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            Divider()
                .padding(.vertical, 8)

            HStack {
                Toggle(UserText.enableStats, isOn: Binding(
                    get: { appState.cleaningStats.isEnabled },
                    set: { appState.cleaningStats.isEnabled = $0 }
                ))

                Spacer()

                Button(UserText.resetStats) {
                    appState.cleaningStats.reset()
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(width: 350, height: 400)
    }

    private func deleteSelected() {
        appState.queryItemsManager.delete(ids: selection)
        selection.removeAll()
    }
}
