//
//  ProfileInfoRow.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/15.
//

import SwiftUI



/// 共通の設定用モディファイア
struct addtitle: ViewModifier {
    
    let text: String
    var showEdit: Bool
    
    func body(content: Content) -> some View {
        
        HStack{
            Text(text)
                .multilineTextAlignment(.leading)
                .frame(width: 90)
                .foregroundColor(.secondary)
            
            Spacer().frame(width: 20)
            
            content
                .foregroundColor(.primary)
            
            Spacer()

//            Image(systemName: showEdit ? "checkmark.circle.fill" : "chevron.right")
            Image(systemName: showEdit ? "xmark.circle.fill" : "chevron.right")
//            Image(systemName: "chevron.right")
                .foregroundColor(showEdit ? .red : .secondary)
                .scaleEffect(showEdit ? 1.7 : 1)
                .rotationEffect(Angle(degrees: showEdit ? 90 : 0))
        }
    }
}

/// 設定項目の1列用部品
struct ProfileRow: View {
    
    let bufProfile: Profile
    let showEdit: Bool
    let page: EditSelect
    
    
    var body: some View {
        
        Group {
            switch page {
            case .birthdayEdit:
                Text(CommonUtil.birthStr(date: bufProfile.birthday, type: .yyyyMd))
            case .sexEdit:
                Text(bufProfile.sex.name)
            case .areaEdit:
                Text(bufProfile.area.name)
            }
        }
        .modifier(addtitle(text: page.rawValue, showEdit: showEdit))
        .FrontIconStyle(IconName: page.iconName, IconColor: InAppColor.strColor)
    }
}


struct BirthdayEdit: View {

    @Binding var bufProfile: Profile
    @Binding var pages :EditSelect?
    
    var body: some View {
        VStack() {
            DatePicker("Birthday",selection: $bufProfile.birthday, displayedComponents: .date)
                .font(.system(size: 10))
                .labelsHidden()
                .datePickerStyle(.wheel)
                .frame(height: 190)
            //Divider()
            Toggle("生年月日の表示",isOn: $bufProfile.visibleBirthday)
                .font(.title3)
            Text("生年月日を\(bufProfile.visibleBirthday ? "表示します" : "非表示にします")")
                .font(.callout)
                .foregroundColor(.secondary)
                .frame(width: UIScreen.main.bounds.width - 60)
            
            Button {
                withAnimation(){ pages = nil }
                    
            } label: {
                ButtonLabel(message: "決定", buttonColor: InAppColor.buttonColor)
            }
                .padding(.top, 20)
        }
        .padding()
        .padding(.top, 10)
        .background(.white.opacity(0.9))
        .frame(width: UIScreen.main.bounds.width - 60)
        .cornerRadius(20)
        .offset(y: -20)
        .shadow(radius: 1)
    }
}


struct SexEdit: View {
    
    @Binding var bufProfile: Profile
    @Binding var pages :EditSelect?
    
    var body: some View {
        
        List{
            ForEach(Sex.allCases, id: \.self) { selectedSex in
                Button {
                    bufProfile.sex = selectedSex
                    withAnimation(){ pages = nil }
                } label: {
                    HStack{
                        Text(selectedSex.name).tag(selectedSex)
                        if bufProfile.sex == selectedSex {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .foregroundColor(InAppColor.strColor)
        .background(.white.opacity(0.9))
        .frame(width: UIScreen.main.bounds.width - 60)
        .cornerRadius(20)
        .offset(y: -20)
        .shadow(radius: 1)
    }
}


struct AreaEdit: View {
    
    @Binding var bufProfile: Profile
    @Binding var pages :EditSelect?

    var body: some View {
        List{
            ForEach(Areas.allCases, id: \.self) { selectedArea in
                Button {
                    bufProfile.area = selectedArea
                    withAnimation(){ pages = nil }
                } label: {
                    HStack{
                        Text(selectedArea.name).tag(selectedArea)
                        if bufProfile.area == selectedArea {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .foregroundColor(InAppColor.strColor)
        .background(.white.opacity(0.9))
        .frame(width: UIScreen.main.bounds.width - 60)
        .cornerRadius(20)
        .offset(y: -20)
        .shadow(radius: 1)
        .labelsHidden()
    }
}


struct ProfileInfoRow_Previews: PreviewProvider {

    @State static var profile = Profile()
    @State static var pages: EditSelect? = .birthdayEdit
    
    static var previews: some View {
        ProfileRow(bufProfile: Profile(), showEdit: true, page: EditSelect.birthdayEdit)
            .previewLayout(.fixed(width: 380, height: 100))
        BirthdayEdit(bufProfile: $profile, pages: $pages)
            .previewLayout(.fixed(width: 380, height: 400))
        SexEdit(bufProfile: $profile, pages: $pages)
            .previewLayout(.fixed(width: 380, height: 300))
        AreaEdit(bufProfile: $profile, pages: $pages)
            .previewLayout(.fixed(width: 380, height: 300))


    }
}
