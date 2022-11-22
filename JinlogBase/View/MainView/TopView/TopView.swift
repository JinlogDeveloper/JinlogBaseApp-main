//
//  TopView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/06/09.
//

import SwiftUI
//import Charts


struct TopView: View {
    
    //画面の初期設定
    init(){
        //タブバーの背景色を変更する
        //UITabBar.appearance().backgroundColor = UIColor(InAppColor.buttonColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(.gray)
        //UITabBar.appearance().unselectedItemTintColor = .lightGray
    }
    
    @State var selectTabIndex = 0
    @State var opacity :Double = 0
    
    
    var body: some View {
        
        ZStack{
            //背景色　ダークモード対応のため色はAssetsに登録
            //InAppColor.backColor
            //.edgesIgnoringSafeArea(.all)
            

            //TabViewの宣言部
            //タブ毎に画面(View)が1つ必要になる
            //タブのアイコンは「SF Symbols」っていうソフトでデフォルトで使えるアイコンが確認できる。
            
            TabView(selection: $selectTabIndex) {
                TabPage1View().tag(0)
                    .tabItem{
                        Image(systemName: "house.fill")
                        Text("ホーム")
                    }
                
                TabPage2View().tag(1)
                    .tabItem{
                        Image(systemName: "calendar")
                        Text("イベント")
                    }
                //.badge(newEvent > 0 ? "New" : nil)
                
                TabPage3View().tag(2)
                    .tabItem{
                        Image(systemName: "gamecontroller")
                        Text("ゲーム")
                    }
                
                TabPage4View().tag(3)
                    .tabItem{
                        Image(systemName: "message.fill")
                        Text("チャット")
                    }
                //.badge(unRead > 0 ? "\(unRead)" : nil)
                
                TabPage5View().tag(4)
                    .tabItem{
                        Image(systemName: "gearshape")
                        Text("設定")
                    }
            } //TabView
            .accentColor(InAppColor.buttonColor)
        } //ZStack
        .opacity(opacity)
        .onAppear(){
            withAnimation(.linear(duration: 0.6)){
                self.opacity = 1.0
            }
        }
        
    }
}



//ここから下は各タブで使用する画面のコード部分
struct TabPage1View: View {
    
    @State var maxNum = 100
    @State var num = 30
    @State var value :CGFloat = 0.3
    @State var score :[Double] = [3.5,4.8,2.5,3.5,2.8]
    let characters = ["長所探し","気遣い","ユーモア","話術","推理力"]
    let colors = [Color(red: 0.204, green: 0.368, blue: 0.499),
                  Color(red: 0.020, green: 0.525, blue: 0.549),
                  Color(red: 0.267, green: 0.765, blue: 0.545),
                  Color(red: 1.000, green: 0.820, blue: 0.224),
                  Color(red: 0.957, green: 0.471, blue: 0.259)]
    
    
    var body: some View {
        
        ScrollView {
            VStack {
                ZStack {
                    
                    //背景色　ダークモード対応のため色はAssetsに登録
                    InAppColor.backColor
                                        
                    //                        Text("ステータス画面")
                    //
                    //                        Circle()
                    //                            .stroke(lineWidth: 30.0)
                    //                            .opacity(0.1)
                    //                            .foregroundColor(InAppColor.buttonColor)
                    //                            .frame(width: UIScreen.main.bounds.width - 40,
                    //                                   height: UIScreen.main.bounds.width - 40 )
                    //
                    //                        Circle()
                    //                            .trim(from: 0.0, to: 0.3)
                    //                            .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                    //                            .foregroundColor(InAppColor.buttonColor)
                    //                            .frame(width: UIScreen.main.bounds.width - 40,
                    //                                   height: UIScreen.main.bounds.width - 40)
                    //                            .rotationEffect(Angle(degrees: -90))
                    //                            .opacity(0.5)
                    
                    //TODO: Xcode14.0にアップデートしたら、ビルドエラーが発生してしまう
                    /*
                    //一旦ここにデータを作成。今後どっかへ移動させる
                    Radar(entries: [
                        RadarChartDataEntry(value: 2.6),
                        RadarChartDataEntry(value: 2.8),
                        RadarChartDataEntry(value: 4.1),
                        RadarChartDataEntry(value: 5.0),
                        RadarChartDataEntry(value: 3.4)]
                          ,entries2: [
                            RadarChartDataEntry(value: score[0]),
                            RadarChartDataEntry(value: score[1]),
                            RadarChartDataEntry(value: score[2]),
                            RadarChartDataEntry(value: score[3]),
                            RadarChartDataEntry(value: score[4])]
                    )
                    .frame(width: UIScreen.main.bounds.width,height: 420.0)
                    */
                    //プログレスバーはviewで作成　　スタックで重ねて表示させる
                    SquareProgressView(maxNum: $maxNum, num: $num)
                        .frame(width: 300, height: 40)
                        .cornerRadius(15)
                        .offset(x: 0, y: 135)
                    
                } //Zstack
                
                                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        VStack {
                            Text("ステータス")
                                .padding(.bottom,1)
                                .foregroundColor(.secondary)
                            Text("\(num)")
                                .font(.system(size: 35, weight: .thin, design: .rounded))
                                
                            withAnimation(){
                                Stepper("ステータス",value: $num, in: 0...100)
                                    .labelsHidden()
                            }
                        }
                        .padding(.top)

                        
                        ForEach(0 ..< 4) { num in
                            VStack {
                                HStack {
                                    if score[num] > 4.99 {
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(Color.yellow)
                                    }
                                    Text(self.characters[num])
                                        .padding(.bottom,1)
                                        .foregroundColor(.secondary)
                                }
                                ZStack {
                                    RadialGradient(gradient: Gradient(colors: [colors[num].opacity(0.3), Color.white.opacity(0.4)]), center: .center, startRadius: 0, endRadius: 35)

                                    Text(String(format: "%.1f", score[num]))
                                        .font(.system(size: 35, weight: .thin, design: .rounded))
                                }
                                Stepper(self.characters[num],value: $score[num], in: 0...5, step: 0.1)
                                    .labelsHidden()
                            }
                            .padding(.top)
                        }
                    } //HStack
                } //ScrollView
            } //Vstack
        } //ScrollView
        .edgesIgnoringSafeArea(.all)
    }
}



struct TabPage2View: View {
    var body: some View {
        
        VStack{
            Text("2ページめのタブ")
                .font(.title)
            
        }
    }
}


struct TabPage3View: View {
    var body: some View {
        GameView()
    }
}


struct TabPage4View: View {
    var body: some View {
        
        VStack{
            Text("4ページめのタブ")
                .font(.title)
            
        }
    }
}


struct TabPage5View: View {
    
    @State var permitComment = false
    @State var permitMessage = false
    @State var isShowDialog = false     //ダイアログボックスの表示フラグ
    
    var body: some View {
        
            //TODO: 実行時にエラーログが出る
            //※動作はちゃんとしてるっぽい？
            NavigationView{
                
                List{
                    
                    //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
                    //　本当は　NavigationList　を入れるところだけど
                    //　まだ画面ができてないので　Text　で仮に作成してます
                    //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
                    
                    Section(header:Text("プロフィール")) {
                        
                        NavigationLink("プロフィール編集", destination: ProfileView2())
                        Text("メールアドレス変更")
                        Text("パスワード変更")
                        Text("ステータス変更")
                        
                    }
                    
                    Section(header:Text("メッセージ・コメント")) {
                        
                        Toggle(isOn: $permitComment){
                            Text("コメントの許可")
                        }
                        
                        Toggle(isOn: $permitMessage){
                            Text("メッセージの許可")
                        }
                        
                    }
                    
                    Section(header:Text("プレーヤーリスト")) {
                        
                        NavigationLink("お気に入りプレイヤー",destination: PlayerList())
                        Text("ブロックしたプレイヤー")
                        
                    }

                    Section(){
                        Button(action: {}){
                            Text("アカウント編集")
                                .foregroundColor(Color.red)
                        }
                    }
                } //List
                .navigationTitle(Text("設定"))
                //.navigationBarTitleDisplayMode(.inline)
                //.navigationBarHidden(true)
                .toolbar {
                    // ナビゲーションバー左にアイコン追加
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: { isShowDialog = true }) {
                            VStack{
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("ログアウト").font(.system(size: 10))
                            }
                        }
                        .confirmationDialog("ログアウト操作\n続行していいですか",
                                            isPresented: $isShowDialog,
                                            titleVisibility: .visible) {
                            Button("ログアウトする") {
                                Task {
                                    try! Owner.sAuth.signOut()
                                    withAnimation(.linear(duration: 0.4)) {
                                        ReturnViewFrags.returnToLoginView.wrappedValue.toggle()
                                    }
                                }
                            }
                            Button("キャンセル", role: .cancel) {}
                        }
                    }
                }
            } //NavigationView
    } //bodyView
} //View


struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
            .previewInterfaceOrientation(.portrait)
        //        TabPage1View()
        //        TabPage2View()
        TabPage3View()
        //        TabPage4View()
        TabPage5View()
    }
}
