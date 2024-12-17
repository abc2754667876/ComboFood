//
//  PurchaseView.swift
//  ComboFood
//
//  Created by Chengzhi 张 on 2024/12/16.
//

import SwiftUI

struct PurchaseView: View {
    @AppStorage("userPurchased") private var userPurchased = false
    @AppStorage("useCount") private var useCount = 0
    
    @StateObject private var iapManager = IAPManager.shared
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedOption = 0
    @State private var isProgress =  false
    @State private var purchaseID = "cola"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("bgColor")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("制作不易，求打赏")
                        .font(.custom("JPangWa", size:34))
                        .foregroundStyle(Color("textColor"))
                    Text("你已使用牛牛食谱\(useCount)次了")
                        .font(.custom("JPangWa", size:14))
                        .foregroundStyle(Color("textColor"))
                        .multilineTextAlignment(.leading)
                        .opacity(0.8)
                        .padding(.bottom, 50)
                        .padding(.top, -10)
                    
                    Button(action: {
                        selectedOption = 0
                    }){
                        HStack{
                            VStack(spacing: 5){
                                HStack {
                                    Text("打赏一杯可乐")
                                        .font(.custom("JPangWa", size:18))
                                        .foregroundStyle(Color("textColor"))
                                    Spacer()
                                }
                                HStack {
                                    Text("3元")
                                        .font(.custom("JPangWa", size:14))
                                        .foregroundStyle(Color("textColor"))
                                        .opacity(0.8)
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            if selectedOption == 0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color("textColor"))
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(Color("textColor"))
                            }
                        }
                    }
                    Divider()
                    Button(action: {
                        selectedOption = 1
                    }){
                        HStack{
                            VStack(spacing: 5){
                                HStack {
                                    Text("打赏一杯奶茶")
                                        .font(.custom("JPangWa", size:18))
                                        .foregroundStyle(Color("textColor"))
                                    Spacer()
                                }
                                HStack {
                                    Text("15元")
                                        .font(.custom("JPangWa", size:14))
                                        .foregroundStyle(Color("textColor"))
                                        .opacity(0.8)
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            if selectedOption == 1 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color("textColor"))
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(Color("textColor"))
                            }
                        }
                    }
                    Divider()
                    Button(action: {
                        selectedOption = 2
                    }){
                        HStack{
                            VStack(spacing: 5){
                                HStack {
                                    Text("打赏一杯咖啡")
                                        .font(.custom("JPangWa", size:18))
                                        .foregroundStyle(Color("textColor"))
                                    Spacer()
                                }
                                HStack {
                                    Text("30元")
                                        .font(.custom("JPangWa", size:14))
                                        .foregroundStyle(Color("textColor"))
                                        .opacity(0.8)
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            if selectedOption == 2 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color("textColor"))
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(Color("textColor"))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isProgress = true

                        if selectedOption == 0 {
                            purchaseID = "cola"
                        } else if selectedOption == 1 {
                            purchaseID = "milktea"
                        } else if selectedOption == 2 {
                            purchaseID = "coffee"
                        }
                        
                        if let product = iapManager.product(for: purchaseID) {
                            IAPManager.shared.purchase(product: product)
                        }
                    }){
                        ZStack{
                            if isProgress {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("打赏")
                                    .font(.custom("JPangWa", size:18))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color("textColor"))
                        .cornerRadius(30)
                    }
                    .padding(.bottom)
                    .disabled(isProgress)
                    
                    HStack{
                        Button(action: {
                            if let url = URL(string: "http://www.apple.com/legal/itunes/appstore/dev/stdeula") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }){
                            Text("条款")
                        }
                        
                        Text("|")
                            .foregroundStyle(.gray)
                        
                        Button(action: {
                            if let url = URL(string: "https://www.privacypolicies.com/live/c5e7692b-6d13-49fa-b074-29141a8d88df") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }){
                            Text("隐私")
                        }
                        
                        Text("|")
                            .foregroundStyle(.gray)
                        
                        Button(action: {
                            isProgress = true
                            iapManager.restorePurchases()
                        }){
                            Text("恢复购买")
                        }
                        .disabled(isProgress)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .navigationBarTitle("打赏", displayMode: .inline)
                .navigationBarItems(leading: cancleBtn)
            }
        }
        .onAppear{
            iapManager.fetchProducts()
        }
        .onReceive(iapManager.$purchaseStatus) { status in
            if let status = status {
                if status.contains("成功") || status.contains("完成") {
                    userPurchased = true
                    alertMessage = "打赏成功，感谢支持！"
                } else {
                    alertMessage = "打赏失败！"
                }
                isProgress = false
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("打赏"),
                message: Text(alertMessage),
                dismissButton: .default(Text("确定")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private var cancleBtn: some View{
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }){
            Text("可是我拒绝")
        }
        .disabled(isProgress)
    }
}

#Preview {
    PurchaseView()
}
