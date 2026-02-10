//
//  AddSheet.swift
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
                .lineLimit(0)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    submit(nil)
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(
                    role: .confirm,
                    action: {
                        submit(title)
                        dismiss()
                    },
                    label: {
                        Label("Add", systemImage: "plus")
                    }
                )
            }
        }
        .navigationTitle("New Feature")
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        NewFeatureView(submit: { _ in })
    }
}
