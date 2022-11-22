//
//  JinlogFirestore.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/05/03.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum rootCollections: String {
    case profiles = "profiles"
    case settings = "settings"
    case games    = "games"
}

/// プロフィール用のDBに直接アクセスする処理を集めたクラス
final actor ProfileStore {

    private let db: CollectionReference

    init() {
        db = Firestore.firestore().collection(rootCollections.profiles.rawValue)
    }

    /// データベースにプロフィールを保存する
    /// - Parameters:
    ///   - uId: 保存するプロフィールのユーザID
    ///   - prof: 保存するプロフィール
    func storeProfile(uId: String, prof: Profile) async throws {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }

        // 辞書型に変換
        var dictionary: [String : Any]
        do {
            dictionary = try Firestore.Encoder().encode(prof)
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }

        // ドキュメント保存
        do {
            try await db.document(uId).setData(dictionary)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }

    /// データベースからプロフィールを読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID
    /// - Returns: Profile
    func loadProfile(uId: String) async throws -> Profile {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            throw JinlogError.argumentEmpty
        }

        // ドキュメント取得
        var document: DocumentSnapshot
        do {
            document = try await db.document(uId).getDocument(source: .server)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }

        // ドキュメントなし
        guard document.exists == true else {
            print("Error : document not found")
            throw JinlogError.noProfileInDB
        }

        // ドキュメント変換
        do {
            let profile = try document.data(as: Profile.self)
            return profile
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }
    }

    /// データベースから複数のプロフィールを読み込む
    /// - Parameter uId: 読み込むプロフィールのユーザID配列
    func loadProfiles(uId: [String]) async -> [Profile]? {
        var ret: [Profile]? = nil

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }

        print(uId)
        do {
            let profs = try await db.whereField(FieldPath.documentID(), in: uId).getDocuments()
                .documents.compactMap{ try $0.data(as: Profile.self) }
            ret = profs
            return ret
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return ret
        }
    }

}

/// 設定用のDBに直接アクセスする処理を集めたクラス
final actor SettingStore {

    private let db: CollectionReference

    init() {
        db = Firestore.firestore().collection(rootCollections.settings.rawValue)
    }

    /// データベースに設定を保存する
    /// - Parameters:
    ///   - uId: 保存する設定のユーザID
    ///   - prof: 保存する設定
    /// - Returns: 成功0／失敗-1
    func storeSetting(uId: String, setting: Setting) async -> Int {
        var ret: Int = -1

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return ret
        }

        do {
            try db.document(uId).setData(from: setting)
            ret = 0
            return ret
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return ret
        }
    }

    /// データベースから設定を読み込む
    /// - Parameter uId: 読み込む設定のユーザID
    /// - Returns: 成功Profile／失敗nil
    func loadSetting(uId: String) async -> Setting? {

        guard !(uId.isEmpty) else {
            print("Error : uId is empty")
            return nil
        }

        do {
            let res = try await db.document(uId).getDocument(as: Setting.self)
            return res
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            //TODO:
            return nil
        }
    }

}

protocol DelegateGameListener: AnyObject {
    func receiveLatestGame(gId: String, latestGameState: GameState?)
    func receiveLatestGame(gId: String, latestGamePlayers: [GamePlayer])
}

/// ゲーム用のDBに直接アクセスする処理を集めたクラス
final actor GameStore {
    
    private let db: CollectionReference
    
    init() {
        db = Firestore.firestore().collection(rootCollections.games.rawValue)
    }
    
    /// データベースに新規ゲームを保存する
    /// - Parameters:
    ///   - game: 保存する新規ゲーム
    /// - Returns: 新規ゲームID
    func storeNewGame(game: GameState) async throws -> String {

        // 辞書型に変換
        var dictionary: [String : Any]
        do {
            dictionary = try Firestore.Encoder().encode(game)
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }

        do {
            // 新規ゲーム保存
            let ref: DocumentReference = try await db.addDocument(data: dictionary)

            // Firestoreは空のサブコレクションを作れない仕様のため、
            // 主催者を1人目のプレイヤーとして追加することでサブコレクションを作成する
            // ※Firestoreの仕様のため、このクラスに実装する※
            var bufNewPlayer = GamePlayer()
            bufNewPlayer.userId = game.hostUserId
            try await storeNewPlayer(gameId: ref.documentID, player: bufNewPlayer)

            return ref.documentID   // newGameId
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }
    
    /// データベースからゲームを読み込む
    /// - Parameter gameId: 読み込むゲームのゲームID
    /// - Returns: GameState, GamePlayers
    func loadGame(gameId: String) async throws -> (state: GameState, players: [GamePlayer]) {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }

        let gameState = try await loadGameState(gameId: gameId)
        let gamePlayers = try await loadGamePlayer(gameId: gameId)

        return (gameState, gamePlayers)
    }

    /// データベースからゲーム状況を読み込む
    /// - Parameter gameId: ゲームID
    /// - Returns: GameState
    func loadGameState(gameId: String) async throws -> GameState {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        
        // ドキュメント取得
        var snap: DocumentSnapshot
        do {
            print("gameId : \(gameId)")
            snap = try await db.document(gameId).getDocument(source: .server)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
        
        // ドキュメントなし
        guard snap.exists == true else {
            print("Error : document not found")
            throw JinlogError.noProfileInDB //TODO: JinlogError.*****
        }
        print(snap)
        
        // ドキュメント変換
        do {
            let gameState = try snap.data(as: GameState.self)
            return gameState
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }
    }
    
    /// データベースからゲームプレイヤーを読み込む
    /// - Parameter gameId: ゲームID
    /// - Returns: GamePlayers
    func loadGamePlayer(gameId: String) async throws -> [GamePlayer] {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        let dbPlayers = db.document(gameId).collection("players")

        // コレクション取得
        var snap: QuerySnapshot
        do {
            print("gameId : \(gameId)")
            snap = try await dbPlayers.getDocuments(source: .server)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }

        // ドキュメントなし
        guard 0 < snap.count else {
            print("Error : document not found")
            throw JinlogError.noProfileInDB //TODO: JinlogError.*****
        }
        print(snap)
        
        // ドキュメント変換
        do {
            var gamePlayers: [GamePlayer] = []
            for query in snap.documents {
                try gamePlayers.append(query.data(as: GamePlayer.self))
            }
            return gamePlayers
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }
    }
    
    /// 
    func listenGame(gameId: String, listener: DelegateGameListener) throws {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        print("gameId : \(gameId)")

        try listenGameSatate(gameId: gameId, listener: listener)
        try listenGamePlayers(gameId: gameId, listener: listener)
    }

    private var gameStateListenerHandle: ListenerRegistration?
    private var gamePlayersListenerHandle: ListenerRegistration?

    func listenGameSatate(gameId: String, listener: DelegateGameListener) throws {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        
        weak var delegate: DelegateGameListener? = listener

        gameStateListenerHandle = db.document(gameId).addSnapshotListener({ snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                delegate?.receiveLatestGame(gId: gameId, latestGameState: nil)
                self.gameStateListenerHandle?.remove()
                return
            }
            guard let snap = snapshot else {
                print("Error : documentSnapshot is nil")
                delegate?.receiveLatestGame(gId: gameId, latestGameState: nil)
                self.gameStateListenerHandle?.remove()
                return
            }
            
            // ドキュメントなし
            if snap.exists == false {
                print("Error : document not found")
                delegate?.receiveLatestGame(gId: gameId, latestGameState: nil)
                self.gameStateListenerHandle?.remove()
                return
            }
            print("\(snap)")
            
            // ドキュメント変換
            do {
                let gameState = try snap.data(as: GameState.self)
                delegate?.receiveLatestGame(gId: gameId, latestGameState: gameState)
                return
            } catch {
                print("Error : ", error.localizedDescription)
                delegate?.receiveLatestGame(gId: gameId, latestGameState: nil)
                self.gameStateListenerHandle?.remove()
                return
            }
        })
    }

    func listenGamePlayers(gameId: String, listener: DelegateGameListener) throws {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        
        weak var delegate: DelegateGameListener? = listener

        gamePlayersListenerHandle = db.document(gameId).collection("players").addSnapshotListener({ snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                delegate?.receiveLatestGame(gId: gameId, latestGamePlayers: [])
                self.gamePlayersListenerHandle?.remove()
                return
            }
            guard let snap = snapshot else {
                print("Error : documentSnapshot is nil")
                delegate?.receiveLatestGame(gId: gameId, latestGamePlayers: [])
                self.gamePlayersListenerHandle?.remove()
                return
            }
            
            // ドキュメントなし
            guard 0 < snap.count else {
                print("Error : document not found")
                delegate?.receiveLatestGame(gId: gameId, latestGamePlayers: [])
                self.gamePlayersListenerHandle?.remove()
                return
            }
            print("\(snap)")
            
            // ドキュメント変換
            do {
                var gamePlayers: [GamePlayer] = []
                for query in snap.documents {
                    try gamePlayers.append(query.data(as: GamePlayer.self))
                }
                delegate?.receiveLatestGame(gId: gameId, latestGamePlayers: gamePlayers)
                return
            } catch {
                print("Error : ", error.localizedDescription)
                delegate?.receiveLatestGame(gId: gameId, latestGamePlayers: [])
                self.gamePlayersListenerHandle?.remove()
                return
            }
        })
    }
    
    /// データベースに新規プレイヤーを追加保存する
    /// - Parameters:
    ///   - gameId: 保存先ゲームID
    ///   - player: 追加する新規プレイヤー
    func storeNewPlayer(gameId: String, player: GamePlayer) async throws {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        let dbPlayers = db.document(gameId).collection("players")
        
        // 辞書型に変換
        var dictionary: [String : Any]
        do {
            dictionary = try Firestore.Encoder().encode(player)
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }

        // ドキュメント保存
        do {
            try await dbPlayers.document(player.userId).setData(dictionary)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }

    func updateGame(gameId: String, game: GameState) async throws {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }

        // 辞書型に変換
        var dictionary: [String : Any]
        do {
            dictionary = try Firestore.Encoder().encode(game)
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }

        // ドキュメント保存
        do {
            try await db.document(gameId).updateData(dictionary)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }

    func updateGame(gameId: String, player: GamePlayer) async throws {
        
        guard !(gameId.isEmpty) else {
            print("Error : gameId is empty")
            throw JinlogError.argumentEmpty
        }
        let dbPlayers = db.document(gameId).collection("players")
        print("\(player)")

        // 辞書型に変換
        var dictionary: [String : Any]
        do {
            dictionary = try Firestore.Encoder().encode(player)
        } catch {
            print("Error : ", error.localizedDescription)
            throw JinlogError.unexpected
        }
        print("\(dictionary)")

        // ドキュメント更新
        do {
            try await dbPlayers.document(player.userId).updateData(dictionary)
        } catch {
            print("Error : ", error.localizedDescription)
            let errorCode = FirestoreErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .unavailable:
                print("Error : network or server error")
                throw JinlogError.networkServer
            default:
                throw JinlogError.unexpected
            }
        }
    }
}
