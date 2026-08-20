import SwiftUI
import BTShared

/// Reservas de todas as arenas do gestor, vindas do MESMO endpoint que o app do jogador usa
/// (o backend filtra pelo papel do token).
struct DashboardView: View {
    @Environment(Session.self) private var session
    @State private var bookings: [BookingDTO] = []
    @State private var error: String?

    private var revenueCents: Int { bookings.filter { $0.status == .confirmed }.map(\.totalCents).reduce(0, +) }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        stat("Reservas", "\(bookings.count)")
                        Divider()
                        stat("Confirmadas", "\(bookings.filter { $0.status == .confirmed }.count)")
                        Divider()
                        stat("Receita", revenueCents.brl)
                    }
                }
                Section("Próximas") {
                    ForEach(bookings) { b in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(b.startsAt.shortDateTime).font(.headline)
                            Text("\(b.status.rawValue) · \(b.totalCents.brl)").font(.subheadline).foregroundStyle(.secondary)
                        }
                        .swipeActions {
                            if b.status != .cancelled {
                                Button("Cancelar", role: .destructive) { Task { await cancel(b) } }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Painel")
            .overlay { if let error { ContentUnavailableView(error, systemImage: "wifi.exclamationmark") } }
            .refreshable { await load() }
            .task { await load() }
        }
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack {
            Text(value).font(.title3.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity)
    }

    private func load() async {
        do { bookings = try await session.api.bookings(); error = nil }
        catch { self.error = error.localizedDescription }
    }

    private func cancel(_ b: BookingDTO) async {
        try? await session.api.cancelBooking(b.id)
        await load()
    }
}
