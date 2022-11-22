//
//  CommonDifinition.swift
//  CentralDataSample
//
//  Created by MacBook Air M1 on 2022/04/24.
//

import Foundation
// swiftUIをimportしない！！

// 性別
enum Sex: Int, Codable, CaseIterable {
    // CaseIterable : forEach()文などで.allCasesを使えるようにするために使用
    case unselected = 0
    case male
    case female
    case etc        = 254
    case secret     = 255

    var name: String {
        // switch : 上記のcaseと1対1かつ全てを記載しなければビルドエラー
        //          となることで、被らずに網羅されていることが保証される
        switch self {
        case .unselected:   return "未選択"
        case .male:         return "男"
        case .female:       return "女"
        case .etc:          return "その他"
        case .secret:       return "秘密"
        }
    }
    
    // これをうまくやる方法ないかな？？
    static func intToSex(num: Int) -> Sex {
        switch num {
        case Self.male.rawValue:    return Sex.male
        case Self.female.rawValue:  return Sex.female
        case Self.etc.rawValue:    return Sex.etc
        case Self.secret.rawValue:  return Sex.secret
        default: return Sex.unselected
        }
    }
}

// 地域
enum Areas: Int, Codable, CaseIterable {
    // CaseIterable : forEach()文などで.allCasesを使えるようにするために使用
    case unselected = 0
    case hokkaido
    case aomori
    case iwate
    case miyagi
    case akita
    case yamagata
    case fukushima
    case ibaraki
    case tochigi
    case gunma
    case saitama
    case chiba
    case tokyo
    case kanagawa
    case niigata
    case toyama
    case ishikawa
    case fukui
    case yamanashi
    case nagano
    case gifu
    case shizuoka
    case aichi
    case mie
    case shiga
    case kyoto
    case osaka
    case hyogo
    case nara
    case wakayama
    case tottori
    case shimane
    case okayama
    case hiroshima
    case yamaguchi
    case tokushima
    case kagawa
    case ehime
    case kochi
    case fukuoka
    case saga
    case nagasaki
    case kumamoto
    case oita
    case miyazaki
    case kagoshima
    case okinawa    // = 47
    case etc        = 65534
    case secret     = 65535

    var name: String {
        // switch : 上記のcaseと1対1かつ全てを記載しなければビルドエラー
        //          となることで、被らずに網羅されていることが保証される
        switch self {
        case .unselected:   return "未選択"
        case .hokkaido:     return "北海道"
        case .aomori:       return "青森県"
        case .iwate:        return "岩手県"
        case .miyagi:       return "宮城県"
        case .akita:        return "秋田県"
        case .yamagata:     return "山形県"
        case .fukushima:    return "福島県"
        case .ibaraki:      return "茨城県"
        case .tochigi:      return "栃木県"
        case .gunma:        return "群馬県"
        case .saitama:      return "埼玉県"
        case .chiba:        return "千葉県"
        case .tokyo:        return "東京都"
        case .kanagawa:     return "神奈川県"
        case .niigata:      return "新潟県"
        case .toyama:       return "富山県"
        case .ishikawa:     return "石川県"
        case .fukui:        return "福井県"
        case .yamanashi:    return "山梨県"
        case .nagano:       return "長野県"
        case .gifu:         return "岐阜県"
        case .shizuoka:     return "静岡県"
        case .aichi:        return "愛知県"
        case .mie:          return "三重県"
        case .shiga:        return "滋賀県"
        case .kyoto:        return "京都府"
        case .osaka:        return "大阪府"
        case .hyogo:        return "兵庫県"
        case .nara:         return "奈良県"
        case .wakayama:     return "和歌山県"
        case .tottori:      return "鳥取県"
        case .shimane:      return "島根県"
        case .okayama:      return "岡山県"
        case .hiroshima:    return "広島県"
        case .yamaguchi:    return "山口県"
        case .tokushima:    return "徳島県"
        case .kagawa:       return "香川県"
        case .ehime:        return "愛媛県"
        case .kochi:        return "高知県"
        case .fukuoka:      return "福岡県"
        case .saga:         return "佐賀県"
        case .nagasaki:     return "長崎県"
        case .kumamoto:     return "熊本県"
        case .oita:         return "大分県"
        case .miyazaki:     return "宮崎県"
        case .kagoshima:    return "鹿児島県"
        case .okinawa:      return "沖縄県"
        case .etc:          return "その他"
        case .secret:       return "秘密"
        }
    }

    // これをうまくやる方法ないかな？？
    static func intToAreas(num: Int) -> Areas {
        switch num {
        case Self.hokkaido.rawValue:    return Areas.hokkaido
        case Self.aomori.rawValue:      return Areas.aomori
        case Self.iwate.rawValue:       return Areas.iwate
        case Self.miyagi.rawValue:      return Areas.miyagi
        case Self.akita.rawValue:       return Areas.akita
        case Self.yamagata.rawValue:    return Areas.yamagata
        case Self.fukushima.rawValue:   return Areas.fukushima
        case Self.ibaraki.rawValue:     return Areas.ibaraki
        case Self.tochigi.rawValue:     return Areas.tochigi
        case Self.gunma.rawValue:       return Areas.gunma
        case Self.saitama.rawValue:     return Areas.saitama
        case Self.chiba.rawValue:       return Areas.chiba
        case Self.tokyo.rawValue:       return Areas.tokyo
        case Self.kanagawa.rawValue:    return Areas.kanagawa
        case Self.niigata.rawValue:     return Areas.niigata
        case Self.toyama.rawValue:      return Areas.toyama
        case Self.ishikawa.rawValue:    return Areas.ishikawa
        case Self.fukui.rawValue:       return Areas.fukui
        case Self.yamanashi.rawValue:   return Areas.yamanashi
        case Self.nagano.rawValue:      return Areas.nagano
        case Self.gifu.rawValue:        return Areas.gifu
        case Self.shizuoka.rawValue:    return Areas.shizuoka
        case Self.aichi.rawValue:       return Areas.aichi
        case Self.mie.rawValue:         return Areas.mie
        case Self.shiga.rawValue:       return Areas.shiga
        case Self.kyoto.rawValue:       return Areas.kyoto
        case Self.osaka.rawValue:       return Areas.osaka
        case Self.hyogo.rawValue:       return Areas.hyogo
        case Self.nara.rawValue:        return Areas.nara
        case Self.wakayama.rawValue:    return Areas.wakayama
        case Self.tottori.rawValue:     return Areas.tottori
        case Self.shimane.rawValue:     return Areas.shimane
        case Self.okayama.rawValue:     return Areas.okayama
        case Self.hiroshima.rawValue:   return Areas.hiroshima
        case Self.yamaguchi.rawValue:   return Areas.yamaguchi
        case Self.tokushima.rawValue:   return Areas.tokushima
        case Self.kagawa.rawValue:      return Areas.kagawa
        case Self.ehime.rawValue:       return Areas.ehime
        case Self.kochi.rawValue:       return Areas.kochi
        case Self.fukuoka.rawValue:     return Areas.fukuoka
        case Self.saga.rawValue:        return Areas.saga
        case Self.nagasaki.rawValue:    return Areas.nagasaki
        case Self.kumamoto.rawValue:    return Areas.kumamoto
        case Self.oita.rawValue:        return Areas.oita
        case Self.miyazaki.rawValue:    return Areas.miyazaki
        case Self.kagoshima.rawValue:   return Areas.kagoshima
        case Self.okinawa.rawValue:     return Areas.okinawa
        case Self.etc.rawValue:         return Areas.etc
        case Self.secret.rawValue:      return Areas.secret
        default:                        return Areas.unselected
        }
    }

}
