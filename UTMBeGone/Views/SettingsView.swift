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
        @Bindable var manager = appState.queryItemsManager
        Form {
            Section(UserText.queryParametersHeader) {
                List(selection: $selection) {
                    ForEach($manager.queryList) { $item in
                        QueryItemRow(item: $item, onSave: manager.save)
                    }
                    .onDelete { offsets in
                        manager.delete(at: offsets)
                    }
                }

                HStack(spacing: 4) {
                    Button(action: { manager.createNewItem() }) {
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

private struct QueryItemRow: View {
    @Binding var item: QueryItem
    let onSave: () -> Void
    @State private var text: String
    @FocusState private var isFocused: Bool

    init(item: Binding<QueryItem>, onSave: @escaping () -> Void) {
        self._item = item
        self.onSave = onSave
        self._text = State(initialValue: item.wrappedValue.value)
    }

    var body: some View {
        TextField(UserText.parameterPlaceholder, text: $text)
            .focused($isFocused)
            .onSubmit(commit)
            .onChange(of: isFocused) { _, focused in
                if !focused { commit() }
            }
    }

    private func commit() {
        item.value = text
        onSave()
    }
}
