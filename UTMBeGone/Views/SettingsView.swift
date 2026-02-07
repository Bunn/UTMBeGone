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
    @State private var showingStatsInfo = false

    var body: some View {
        Form {
            Section(UserText.queryParametersHeader) {
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

                HStack(spacing: 4) {
                    Button(action: { appState.queryItemsManager.createNewItem() }) {
                        Image(systemName: "plus")
                            .frame(width: 16, height: 16)
                    }

                    Button(action: { deleteSelected() }) {
                        Image(systemName: "minus")
                            .frame(width: 16, height: 16)
                    }
                    .disabled(selection.isEmpty)
                }
            }

            Section {
                HStack {
                    Toggle(UserText.enableStats, isOn: Binding(
                        get: { appState.cleaningStats.isEnabled },
                        set: { appState.cleaningStats.isEnabled = $0 }
                    ))

                    Button(action: { showingStatsInfo.toggle() }) {
                        Image(systemName: "questionmark.circle")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .popover(isPresented: $showingStatsInfo, arrowEdge: .trailing) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(UserText.statsPrivacyInfo)
                                .fixedSize(horizontal: false, vertical: true)

                            Link(UserText.statsSourceCode, destination: URL(string: UserText.statsSourceCodeURL)!)
                        }
                        .padding()
                        .frame(width: 260)
                    }

                    Spacer()

                    Button(UserText.resetStats) {
                        appState.cleaningStats.reset()
                    }
                }
            } header: {
                Text(UserText.statisticsHeader)
            }

            Section {
                Button(action: { appState.openProjectWebsite() }) {
                    Text(UserText.projectWebsite)
                }
                .buttonStyle(.link)
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 450)
    }

    private func deleteSelected() {
        appState.queryItemsManager.delete(ids: selection)
        selection.removeAll()
    }
}
