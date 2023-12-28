//
//  DictView.swift
//  한들
//
//  Created by 강희영 on 2022/04/22.
//

import SwiftUI
import Firebase
import AVFoundation

struct DictView: View {
    let answer: String
    let meaning: String
    @State var nowDate: Date = Date()
    @State var currentDate: Date = Date()
    
    @AppStorage("isColorWeakModeOn") var isColorWeakModeOn: Bool = false
    
    let synthesizer = AVSpeechSynthesizer()
    let currentGame: Game
    
    init(game: Game) {
        if let dictInfo = game.wordDict.filter({$0.jamo == game.answer}).first {
            self.answer = dictInfo.word
            self.meaning = dictInfo.meaning
        } else {
            self.answer = ""
            self.meaning = ""
        }
        currentGame = game
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                HStack {
                    Text(answer)
                        .font(.custom("EBSHMJESaeronR", fixedSize: 28))
                    Button(action: { speakAnswer() }, label: {
                        Image(systemName: "speaker.wave.2.bubble")
                            .foregroundColor(.hBlack)
                    })
                    Spacer()
                    Button {
                        presentShareActionSheet()
                    } label: {
                        shareButton
                    }
                }
                HStack {
                    ScrollView {
                        dictMeaning
                    }
                    .frame(height: 55)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 35)
    }
    
    var dictMeaning: some View {
        Text(meaning)
            .font(.custom("EBSHMJESaeronL", fixedSize: 15))
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    var shareButton: some View {
        ZStack {
            HStack(spacing: 2) {
                Text("공유")
                    .foregroundColor(.hBlack)
                    .font(.custom("EBSHMJESaeronR", fixedSize: 15))
                    .padding([.top, .leading, .bottom], 8)
                Image("shareImage")
                    .padding([.top, .trailing, .bottom], 8)
            }
            .frame(width: 60, height: 28)
            .background(Color.hLigthGray.cornerRadius(5))
        }
    }
    
    func presentShareActionSheet() {
        let sharedString = generateSharedGameResultString(game: currentGame)
        let activityVC = UIActivityViewController(activityItems: [sharedString], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func speakAnswer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
        let utterance = AVSpeechUtterance(string: answer)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR") // 한국어로 설정
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}
