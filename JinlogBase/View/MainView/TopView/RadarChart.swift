//
//  RadarChart.swift
//  Chart_Test
//
//  Created by Ken Oonishi on 2022/06/18.
//

//TODO: Xcode14.0にアップデートしたら、ビルドエラーが発生してしまう
/*
import SwiftUI
import Charts

struct Radar :UIViewRepresentable{
    
    var entries: [RadarChartDataEntry]
    var entries2: [RadarChartDataEntry]
    
    
    //　レーダーチャート本体部分
    func makeUIView(context: Context) -> RadarChartView{
        
        let chart = RadarChartView()
        chart.data = addData()                              //データのセット（必ず必要）
        
        //--------------------------
        //全体の設定
        chart.innerWebColor = UIColor(InAppColor.textFieldColor)    //周囲のグリッド色
        chart.webColor = UIColor(InAppColor.backColor)              //メインのグリッド色
        chart.webLineWidth = 0                                      //軸線の太さ
        chart.innerWebLineWidth = 2                                 //目盛線の太さ
        //chart.backgroundColor = UIColor(Color.gray)               //グラフの背景色
        //chart.drawWeb = false                                     //グラフのグリッド表示
        //chart.skipWebLineCount = 2                                //メイン軸の表示間隔

        
        //--------------------------
        //凡例の設定
        chart.legend.font = .systemFont(ofSize: 15)
        chart.legend.horizontalAlignment = .center
        chart.legend.yOffset = 10
        //chart.legend.enabled = false                              //凡例の非表示

        
        //--------------------------
        //Y軸の設定
        chart.yAxis.drawLabelsEnabled = false                       //Y軸のラベル表示
        chart.yAxis.axisMaximum = 5                                 //Y軸最大値
        chart.yAxis.axisMinimum = 0                                 //Y軸の最小値
        chart.yAxis.axisMaximum = 5                                 //Y軸の最大値
        chart.yAxis.setLabelCount(4, force: true)                   //Y軸のラベル数　forceをtrueにすると強制表示
        //chart.yAxis.drawLabelsEnabled = false                     //Y軸のラベル表示
        //chart.yAxis.granularity = 1                               //Y軸の値間隔
        
        
        //--------------------------
        //X軸の設定
        chart.xAxis.valueFormatter = MyAxisFormatter()              //X軸の項目表示を変更
        chart.xAxis.labelFont = .systemFont(ofSize: 15)             //X軸ラベルのフォントサイズ
        //chart.xAxis.drawLabelsEnabled = false                     //X軸のラベル表示

        
        //--------------------------
        //アニメーション
        chart.animate(xAxisDuration: 1, yAxisDuration: 1)           //XY軸のアニメーション設定
        
        
        return chart
    }
    
    
    //データ更新時の表示アップデート
    func updateUIView(_ uiView: RadarChartView, context: Context) {
        
        uiView.data = addData()
        
    }

    
    //　レーダーチャートに追加するデータ
    func addData() -> RadarChartData{

        let data = RadarChartData()                                     //登録するデータ群のセット
        

        //--------------------------
       //　1つ目のデータセット
        let dataSet = RadarChartDataSet(entries: entries, label: "理想の自分")
        
        dataSet.colors = [.gray]                                        //線の色
        dataSet.lineWidth = 0                                           //線の太さ
        dataSet.drawFilledEnabled = true                                //塗りつぶしするかどうか
        dataSet.fill = Fill(color: UIColor(.white))     //グラフ内の塗りつぶし色
        dataSet.fillAlpha = 0.3                                         //塗りつぶしの透過率
        dataSet.drawValuesEnabled = false                               //値表示
        dataSet.highlightEnabled = false                                //ハイライト表示

        data.addDataSet(dataSet)                                        //データセットの追加
        
        
        //　2つ目のデータセット
        let dataSet2 = RadarChartDataSet(entries: entries2, label: "評価された自分")
    
        dataSet2.colors = [UIColor(InAppColor.buttonColor)]            //線の色
        dataSet2.lineWidth = 3                                          //線の太さ
        dataSet2.drawFilledEnabled = true                               //塗りつぶすかどうか
        dataSet2.fill = Fill(color: UIColor(InAppColor.buttonColor))   //グラフ内の塗りつぶし色
        dataSet2.fillAlpha = 0.5                                        //塗りつぶしの透過率
        dataSet2.drawValuesEnabled = true                               //値の表示
        dataSet2.highlightEnabled = false                               //ハイライト表示
        
        data.addDataSet(dataSet2)                                       //データセットの追加
        
        return data
    }
    
    
    typealias UIViewType = RadarChartView
    
}


/*-----  X軸のラベル表示を変更するために Formatterクラスをオーバーライドして作成　-----

　　標準の場合、X軸のラベル表示は「Double型」で固定されてる
　　数字じゃなくて文字を入れたいので、カスタムフォーマットを作成

-------------------------------------------------------------------------*/
 
class MyAxisFormatter :IAxisValueFormatter{

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋
        //今は固定値のラベル表示
        //別で「String型」の配列を作成する関数作れば、項目数・順序も変更可能

        let xLabel :[String] = ["長所探し","気遣い","ユーモア","話術","推理力"]

        //＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋＋

        
        
        return xLabel[Int(value)]
    }
}



struct Radar_Preview :PreviewProvider {
    static var previews: some View{
        Radar(entries: [
            RadarChartDataEntry(value: 1),
            RadarChartDataEntry(value: 2),
            RadarChartDataEntry(value: 4),
            RadarChartDataEntry(value: 5),
            RadarChartDataEntry(value: 5)]
              ,entries2: [
                RadarChartDataEntry(value: 2),
                RadarChartDataEntry(value: 1),
                RadarChartDataEntry(value: 3),
                RadarChartDataEntry(value: 5),
                RadarChartDataEntry(value: 2)]
        )
    }
}
*/
