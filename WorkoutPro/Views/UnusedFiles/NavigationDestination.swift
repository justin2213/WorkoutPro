//
//  NavigationDestination.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 9/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .navigationDestination(for: Detail.self) { detail in
                DetailView(detail: detail)
            }
        }
    }
}

struct HomeView: View {
    @State private var isShowingDetail = false
    
    var body: some View {
        VStack {
            Text("Home View")
            NavigationLink(destination: DetailView(detail: Detail(name: "Example Detail"))) {
                Text("Show Detail")
            }
        }
        .navigationTitle("Home")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .navigationTitle("Profile")
    }
}

struct Detail: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct DetailView: View {
    let detail: Detail
    
    var body: some View {
        VStack {
            Text("Detail for \(detail.name)")
        }
        .navigationTitle("Detail")
    }
}
