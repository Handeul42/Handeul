//
//  PlayedGameListView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/08.
//

import SwiftUI

struct PlayedGameListView: View {
    
    let playedGames: [Game]
    
    init() {
        self.playedGames = RealmManager.shared.getFinishedGames()
            .sorted(byKeyPath: "timestamp", ascending: false)
            .map({ Game(persistedObject: $0)})
    }
    
    var body: some View {
        NavigationView {
            if playedGames.isEmpty {
                Text("No data")
            } else {
                List {
                    ForEach(playedGames) { game in
                        Text(game.answer)
                    }
                }
            }
        }
    }
}

struct PlayedGameListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayedGameListView()
    }
}
