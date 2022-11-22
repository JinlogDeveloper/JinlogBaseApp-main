//
//  PlayerList.swift
//  JinlogBase
//
//  Created by Ken Oonishi on 2022/09/03.
//

import SwiftUI

struct PlayerList: View {

    var players = ["Player1","Player2","Player3","Player4","Player5","Player6","Player7","Player8","Player9","Player10"]
    
    var body: some View {
        
            List{
                ForEach(0 ..< 10) { num in
                    NavigationLink {
                        PlayerDetail(username: players[num])
                    } label: {
                        PlayerRow(username: players[num])
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("お気に入りプレーヤー")
    }
        
}

struct PlayerList_Previews: PreviewProvider {
    static var previews: some View {
        PlayerList()
    }
}
