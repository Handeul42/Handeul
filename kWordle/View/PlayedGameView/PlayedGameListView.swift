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
                    Text("푼 문제가 없습니다.")
                        .font(.custom("EBSHMJESaeronR", size: 20))
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
                Section(header: gameListSectionHeader(day.key)) {
                    ForEach(day.games, id: \.id) { persistedGame in
                        let game = Game(persistedObject: persistedGame)
                        NavigationLink {
                            PlayedGameView(game: game)
                        } label: {
                            HStack {
                                Text(game.wordDict
                                    .filter({ $0.jamo == game.answer})
                                    .first?.word ?? "")
                                .font(.custom("EBSHMJESaeronR", size: 20))
                                Spacer()
                                gameResultText(game: game)
                            }
                        }
                    }
                }
            }
        }.listStyle(.plain)
    }
    
    @ViewBuilder
    private func gameResultText(game: Game) -> some View {
        let resultText = game.didPlayerWin ? "\(game.currentRow + 1) / 6" : "🤯"
        Text(resultText)
            .font(.custom("EBSHMJESaeronR", size: 14))
    }
    
    fileprivate func gameListSectionHeader(_ content: String) -> Text {
        return Text(content).font(.custom("EBSHMJESaeronL", size: 14))
    }
    
}

struct PlayedGameListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayedGameListView()
    }
}
