import SwiftUI
import BTShared

struct MyArenasView: View {
    @Environment(Session.self) private var session
    @State private var arenas: [ArenaDTO] = []
    @State private var showNew = false

    var body: some View {
        NavigationStack {
            List(arenas) { arena in
                NavigationLink(value: arena) {
                    VStack(alignment: .leading) {
                        Text(arena.name).font(.headline)
                        Text(arena.city).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Minhas arenas")
            .navigationDestination(for: ArenaDTO.self) { ArenaDetailView(arena: $0) }
            .toolbar { Button { showNew = true } label: { Image(systemName: "plus") } }
            .sheet(isPresented: $showNew, onDismiss: { Task { await load() } }) { NewArenaView() }
            .refreshable { await load() }
            .task { await load() }
        }
    }

    private func load() async { arenas = (try? await session.api.arenas()) ?? [] }
}

struct ArenaDetailView: View {
    @Environment(Session.self) private var session
    let arena: ArenaDTO
    @State private var courts: [CourtDTO] = []

    var body: some View {
        List {
            Section("Endereço") { Text("\(arena.address), \(arena.city)") }
            Section("Quadras") {
                ForEach(courts) { c in
                    LabeledContent(c.name, value: "\(c.pricePerHourCents.brl)/h")
                }
                if courts.isEmpty { Text("Nenhuma quadra cadastrada").foregroundStyle(.secondary) }
            }
        }
        .navigationTitle(arena.name)
        .task { courts = (try? await session.api.courts(arenaID: arena.id)) ?? [] }
    }
}
