//
//  GameEntranceView.swift
//  JinlogBase
//
//  Created by MacBook Air M1 on 2022/09/18.
//

import SwiftUI

struct GameView: View {
    @ObservedObject private var gm = GameMaster()
    
    var body: some View {
        if gm.gameId.isEmpty {
            let _ = print("DEBUG : GameViewTop()")
            GameViewTop(gm: gm)
        } else {
            switch gm.gameState.progress.phase {
            case .recruitPlayers:
                if gm.gameState.hostUserId == Owner.sAuth.uid {
                    let _ = print("DEBUG : GameViewRecruitPlayers()")
                    GameViewRecruitPlayers(gm: gm)
                } else {
                    let _ = print("DEBUG : GameViewWaitingStart()")
                    GameViewWaitingStart(gm: gm)
                }
                
            case .confirmingTheRole:
                let _ = print("DEBUG : GameViewConfirmingRole()")
                GameViewConfirmingRole(gm: gm)
                
            case .discussion:
                let _ = print("DEBUG : GameViewDiscussion()")
                GameViewDiscussion(gm: gm)
                
            case .voting:
                let _ = print("DEBUG : GameViewVoting()")
                GameViewVoting(gm: gm)
                
            default:
                let _ = print("ERROR : EmptyView()")
                EmptyView()
            }
        }
    }
}

struct GameViewTop: View {
    @ObservedObject var gm: GameMaster
    
    @ObservedObject var viewModel = ScannerViewModel()
    
    @State private var inputGameId = ""
    
    
    var body: some View {
        VStack{
            Button("ゲームを作成する") {
                Task {
                    do {
                        try await gm.createGame(uId: Owner.sAuth.uid)
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }.padding()
            
            VStack {
//                TextFieldRow(
//                    fieldText: $inputGameId,
//                    iconName: "person.badge.plus",
//                    text: "Game ID"
//                )
                
                HStack{
                               Button(action:{
                                  print("QRcordを読み取るカメラ起動")
                                   viewModel.isShowing = true
                              
                               },label:{
                                   Image(systemName: "person.badge.plus")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 25.0, height: 25.0)
                                   
                               })

                               TextField("Game ID",text: $inputGameId)
                           }
                           .padding(12.0)
                               .frame(maxWidth: 400)
                               .clipShape(RoundedRectangle(cornerRadius: 30))
                               .shadow(radius: 3)
                               .padding(.horizontal, 20.0)
                               
                
                
                
                Button("ゲームに参加する") {
                    Task {
                        do {
                            try await gm.joinGame(gId: inputGameId, uId: Owner.sAuth.uid)
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
                
                
                
                .fullScreenCover(isPresented: $viewModel.isShowing) {
                  SecondView(viewModel: viewModel)
                    
                }
                
                
            }.padding()
            
        }.onChange(of: viewModel.lastQrCode){ newValue in
            inputGameId = newValue
        }
        
        
    }
    

}

struct GameViewRecruitPlayers: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("ゲーム参加者募集中")
                .font(.system(size: 31, weight: .thin))
            
            //TODO: メソッドで作る
            let qrCode: UIImage? = UIImage().createQRCode(sourceText: gm.gameId)
            if qrCode != nil {
                Image(uiImage: qrCode!)
                    .resizable()
                    .frame(width: 240, height: 240)
                    .overlay(   //楕円
                        Ellipse()
                            .fill(Color.green)
                            .frame(width: 100, height: 100)
                    )
                    .overlay(   //アイコン
                        Image(systemName: "tortoise.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                    )
            }
            Text("\(gm.gameId)")
            
            Text("現在の参加者数は \(gm.gamePlayers.count) 人です")
                .padding()
            
            Button("ゲームを開始する") {
                Task {
                    do {
                        try await gm.startGame()
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }.padding()
            
        }
    }
}

struct GameViewWaitingStart: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            VStack{
                Text("ゲームの開始を")
                    .font(.system(size: 31, weight: .thin))
                Text("待っています")
                    .font(.system(size: 31, weight: .thin))
            }.padding()
            
            Text("ゲームID")
            Text("\(gm.gameId)")
            
            Text("現在の参加者数は \(gm.gamePlayers.count) 人です")
                .padding()
            
            Button("ゲームから抜ける") {
                Task {
                    do {
                        try await gm.leaveGame(uId: Owner.sAuth.uid)
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }.padding()
        }
    }
}

struct GameViewConfirmingRole: View {
    @ObservedObject var gm: GameMaster
    @State private var allConfirmed: Bool = false
    
    var body: some View {
        VStack{
            let player = gm.gamePlayers.first(
                where: {$0.userId == Owner.sAuth.uid}
            )
            if (player != nil) {
                
                if (gm.gameState.hostUserId == Owner.sAuth.uid) &&
                    (gm.gamePlayers.filter({$0.confirmedRole}).count == gm.gamePlayers.count) {
                } else {
                    
                    Text("あなたの役職は \(player!.role.name) です")
                        .padding()
                    
                    if player!.confirmedRole == false {
                        Button("確認しました") {
                            Task {
                                do {
                                    try await gm.confirmRole(uId: Owner.sAuth.uid)
                                } catch {
                                    //TODO:
                                    print("ERROR")
                                }
                            }
                        }.padding()
                    } else {
                        Text("役職を確認済み").padding()
                        Text("しばらくお待ちください").padding()
                    }                       
                    
                }
            } else {
                Text("えらー").padding()
                //TODO:
            }
            
        }
        .onChange(of: gm.gamePlayers) { players in
            // 全員が役職を確認したら議論フェーズへ
            // ※主催者スマホに処理させる
            print("onChange()")
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                print("owner")
                let alivedUserNum = players.filter({$0.alived}).count
                let alivedConfirmedUserNum = players.filter({$0.alived && ($0.confirmedRole)}).count
                print("alivedUserNum:\(alivedUserNum) alivedConfirmedUserNum:\(alivedConfirmedUserNum)")
                
                if alivedUserNum == alivedConfirmedUserNum {
                    Task {
                        do {
                            try await gm.startDiscussion()
                        } catch {
                            //TODO:
                            print("ERROR")
                        }
                    }
                }
            }
        }
    }
}

struct GameViewDiscussion: View {
    @ObservedObject var gm: GameMaster
    
    @State private var timerCount: Int = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack{
            Text("〜議論中〜")
                .font(.system(size: 31, weight: .thin))
                .padding()
            Text("残り時間 \(timerCount/60)分 \(timerCount%60)秒")
                .font(.system(size: 31, weight: .thin))
                .padding()
        }
        .onAppear() {
            timerCount = gm.gameState.progress.phaseTimer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                runEveryInterval()
            }
        }
    }
    
    func runEveryInterval() {
        if 0 < timerCount {
            timerCount -= 1
        } else {
            timer?.invalidate() // タイマ削除
            if gm.gameState.hostUserId == Owner.sAuth.uid {
                Task {
                    do {
                        try await gm.startVote()
                    } catch {
                        //TODO:
                        print("ERROR")
                    }
                }
            }
        }
    }
}

struct GameViewVoting: View {
    @ObservedObject var gm: GameMaster
    
    var body: some View {
        VStack{
            Text("投票画面")
                .font(.system(size: 31, weight: .thin))
                .padding()
            
            let own = gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})
            if own == nil {
                //TODO error
                EmptyView()
            } else if own?.voteUserId == "" {
                // 未投票
                beforeVote(gm: gm)
            } else {
                // 投票済
                afterVote(gm: gm)
            }

        }
    }
    
    struct beforeVote: View {
        @ObservedObject var gm: GameMaster
        
        var body: some View {
            VStack {
                Text("投票先を選んでください").padding()
                
                List {
                    ForEach(gm.gamePlayers, id: \.self) { player in
                        if (player.userId != Owner.sAuth.uid) && (player.alived) {
                            // 本人以外の生存者
                            Button(player.userId) {
                                //TODO: 「投票先はこの人でいいですか？はい/いいえ」的な確認ダイアログ表示
                                Task {
                                    do {
                                        try await gm.vote(uId: Owner.sAuth.uid, voteForId: player.userId)
                                    } catch {
                                        //TODO:
                                        print("ERROR")
                                    }
                                }
                            }
                        } else {
                            if player.userId == Owner.sAuth.uid {
                                Text(player.userId).background(Color.blue)  // 本人
                            } else {
                                Text(player.userId).background(Color.gray)  // 既死者
                            }
                        }
                        
                    }
                }

            }
        }
    }
    
    struct afterVote: View {
        @ObservedObject var gm: GameMaster

        var body: some View {

            let own = gm.gamePlayers.first(where: {$0.userId == Owner.sAuth.uid})
            if own == nil {
                //TODO error
                EmptyView()
            } else {
                
                VStack {
                    Text("投票先 選択済み").padding()
                    Text("しばらくお待ちください").padding()
                    
                    List {
                        ForEach(gm.gamePlayers, id: \.self) { player in
                            if player.userId == Owner.sAuth.uid {
                                Text(player.userId).background(Color.blue)      // 本人
                            } else if player.alived == false {
                                Text(player.userId).background(Color.gray)      // 既死者
                            } else if player.userId == own!.voteUserId {
                                Text(player.userId).background(Color.red)       // 投票先
                            } else {
                                Text(player.userId)                             // それ以外
                            }
                        }
                    }
                    
                }
                .onChange(of: gm.gamePlayers) { players in
                    // 全員が投票したら投票結果発表フェーズへ
                    // ※主催者スマホに処理させる
                    print("onChange()")
                    if gm.gameState.hostUserId == Owner.sAuth.uid {
                        print("owner")
                        let alivedUserNum = players.filter({$0.alived}).count
                        let alivedVotedUserNum = players.filter({$0.alived && ($0.voteUserId != "")}).count
                        print("alivedUserNum:\(alivedUserNum) alivedVotedUserNum:\(alivedVotedUserNum)")
                        
                        if alivedUserNum == alivedVotedUserNum {
                            Task {
                                do {
                                    try await gm.startAnnounceVoteResult()
                                } catch {
                                    //TODO:
                                    print("ERROR")
                                }
                            }
                        }
                    }
                }

            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameViewTop(gm: GameMaster())
        GameViewRecruitPlayers(gm: GameMaster())
        GameViewWaitingStart(gm: GameMaster())
        GameViewConfirmingRole(gm: GameMaster())
        GameViewDiscussion(gm: GameMaster())
        GameViewVoting(gm: GameMaster())
    }
}
