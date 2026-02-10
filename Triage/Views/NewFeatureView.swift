//
//  NewFeatureView.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI

struct NewFeatureView: View {

    @Environment(\.dismiss) private var dismiss

    @State
    private var title: String = ""

    var submit: (String?) -> Void

    var body: some View {
        List {
            TextField("Feature", text: $title, prompt: Text("Implement authentication…"))
                .lineLimit(nil)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    submit(nil)
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button {
                    submit(title.trimmingCharacters(in: .whitespacesAndNewlines))
                    dismiss()
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("New Feature")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        NewFeatureView(submit: { _ in })
    }
}
