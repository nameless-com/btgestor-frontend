import SwiftUI
import BTShared

struct NewArenaView: View {
    @Environment(Session.self) private var session
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var address = ""
    @State private var city = ""
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome", text: $name)
                TextField("Endereço", text: $address)
                TextField("Cidade", text: $city)
                if let error { Text(error).foregroundStyle(.red) }
            }
            .navigationTitle("Nova arena")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { Task { await save() } }
                        .disabled(name.isEmpty || address.isEmpty || city.isEmpty)
                }
            }
        }
    }

    private func save() async {
        do {
            _ = try await session.api.createArena(CreateArenaRequest(name: name, address: address, city: city))
            dismiss()
        } catch { self.error = error.localizedDescription }
    }
}
