//
//  PlayedGameListView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/08.
//

import SwiftUI

struct PlayedGameListView: View {
    
    let playedGamesGroupedByDate: [String: [PersistedGame]]
    
    init() {
        self.playedGamesGroupedByDate = RealmManager.shared.getGamesGroupedByDay()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if playedGamesGroupedByDate.isEmpty {
                    Text("No data")
                } else {
                    gameList()
                }
            }
        }
    }
    
    fileprivate func gameList() -> some View {
        return List {
            let sortedGroups = playedGamesGroupedByDate
                .sorted(by: { $0.key > $1.key })
                .map {key, value in (key: key, games: value)}
            
            ForEach(sortedGroups , id: \.key) { day in
                Section(header: Text(day.key)) {
                    ForEach(day.games, id: \.id) { persistedGame in
                        let game = Game(persistedObject: persistedGame)
                        NavigationLink {
                            PlayedGameView(game: game)
                        } label: {
                            Text(game.wordDict
                                .filter({ $0.jamo == game.answer})
                                .first?.word ?? "")
                        }
                    }
                }
            }
        }.listStyle(.plain)
    }
    
}

struct PlayedGameListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayedGameListView()
    }
}
