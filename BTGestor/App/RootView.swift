import SwiftUI

struct RootView: View {
    @Environment(Session.self) private var session

    var body: some View {
        if session.isRestoring {
            ProgressView("Carregando…")
        } else if session.isLoggedIn {
            TabView {
                DashboardView()
                    .tabItem { Label("Reservas", systemImage: "calendar") }
                MyArenasView()
                    .tabItem { Label("Arenas", systemImage: "building.2") }
                ProfileView()
                    .tabItem { Label("Perfil", systemImage: "person") }
            }
        } else {
            LoginView()
        }
    }
}

struct ProfileView: View {
    @Environment(Session.self) private var session
    var body: some View {
        NavigationStack {
            List {
                if let u = session.user {
                    LabeledContent("Nome", value: u.name)
                    LabeledContent("E-mail", value: u.email)
                }
                Button("Sair", role: .destructive) { Task { await session.logout() } }
            }
            .navigationTitle("Perfil")
        }
    }
}
