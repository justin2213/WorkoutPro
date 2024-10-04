//
//  BadgesView.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/27/24.
//

import SwiftUI

struct BadgesView: View {
    @ObservedObject var userBadges = UserBadges.shared
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    Section {
                        ScrollView(.horizontal) {
                            HStack(spacing: 25) {
                                Spacer()
                                ForEach(userBadges.badges) { badge in
                                    VStack {
                                        Image(systemName: badge.image)
                                            .resizable()
                                            .frame(width:125, height: 125, alignment: .center)
                                            .foregroundStyle(Color.blue)
                                        VStack {
                                            Text(badge.name)
                                            Text(badge.description)
                                                .font(.footnote)
                                                .frame(width: 100)
                                                .multilineTextAlignment(.center)
                                        }
                
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } header: {
                        Text("Weight")
                            .font(.title)
                            .padding(.leading, 15)
                            .padding(.bottom)
                            .padding(.top)
                        
                    }
                }
            
                VStack(alignment: .leading) {
                    Section {
                        ScrollView(.horizontal) {
                            HStack(spacing: 25) {
                                Spacer()
                                ForEach(userBadges.badges) { badge in
                                    VStack {
                                        Image(systemName: badge.image)
                                            .resizable()
                                            .frame(width:125, height: 125, alignment: .center)
                                            .foregroundStyle(Color.blue)
                                        VStack {
                                            Text(badge.name)
                                            Text(badge.description)
                                                .font(.footnote)
                                                .frame(width: 100)
                                                .multilineTextAlignment(.center)
                                        }
                
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } header: {
                        Text("Weight")
                            .font(.title)
                            .padding(.leading, 15)
                            .padding(.bottom)
                        
                    }
                }
                
                VStack(alignment: .leading) {
                    Section {
                        ScrollView(.horizontal) {
                            HStack(spacing: 25) {
                                Spacer()
                                ForEach(userBadges.badges) { badge in
                                    VStack {
                                        Image(systemName: badge.image)
                                            .resizable()
                                            .frame(width:125, height: 125, alignment: .center)
                                            .foregroundStyle(Color.blue)
                                        VStack {
                                            Text(badge.name)
                                            Text(badge.description)
                                                .font(.footnote)
                                                .frame(width: 100)
                                                .multilineTextAlignment(.center)
                                        }
                
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } header: {
                        Text("Weight")
                            .font(.title)
                            .padding(.leading, 15)
                            .padding(.bottom)
                        
                    }
                }            }
        }
        .navigationTitle("Badges")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BadgesView()
}
