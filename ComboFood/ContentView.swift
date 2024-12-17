//
//  ContentView.swift
//  ComboFood
//
//  Created by Chengzhi 张 on 2024/12/15.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userPurchased") private var userPurchased = false
    @AppStorage("useCount") private var useCount = 0
    
    @StateObject private var dataLoader = FoodDataLoader()

    @State private var selectedVegetables: [String] = [] // 存储选中的素菜名称
    @State private var selectedMeats: [String] = []      // 存储选中的荤菜名称
    @State private var selectedStaples: [String] = []    // 存储选中的主食名称
    @State private var selectedTools: [String] = []      // 存储选中的工具名称
    
    @State private var matchedRecipes: [Recipe] = []
    
    @State private var showBuyView = false

    let columns = [GridItem(.adaptive(minimum: 90))] // 最小宽度 90，按钮自动换行

    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            if let foodCategory = dataLoader.foodCategory {
                ScrollView {
                    HStack {
                        Text("牛牛食谱")
                            .font(.custom("JPangWa", size:34))
                            .foregroundStyle(Color("textColor"))
                        Spacer()
                        Button(action: {showBuyView = true}){
                            Image("kafei")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                        }
                        .sheet(isPresented: $showBuyView){
                            PurchaseView()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 5)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        foodSectionView(title: "🥬素菜", items: foodCategory.vegetable, selection: $selectedVegetables)
                        foodSectionView(title: "🥓荤菜", items: foodCategory.meat, selection: $selectedMeats)
                        foodSectionView(title: "🍚主食", items: foodCategory.staple, selection: $selectedStaples)
                        foodSectionView(title: "🍳工具", items: foodCategory.tools, selection: $selectedTools)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    HStack{
                        if matchedRecipes.count > 0 && selectedMeats.count + selectedStaples.count + selectedVegetables.count > 0 {
                            Text("🤩挑选好的菜品（找到\(matchedRecipes.count)个）")
                                .font(.custom("JPangWa", size:23))
                                .foregroundStyle(Color("textColor"))
                                .padding(.bottom, 5)
                        } else {
                            Text("🤩挑选好的菜品")
                                .font(.custom("JPangWa", size:23))
                                .foregroundStyle(Color("textColor"))
                                .padding(.bottom, 5)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    
                    if selectedMeats.count + selectedStaples.count + selectedVegetables.count > 0 {
                        if matchedRecipes.count > 0 {
                            VStack(spacing: 10) {
                                ForEach(matchedRecipes) { recipe in
                                    Button(action: {
                                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                                        if let url = URL(string: "https://www.bilibili.com/video/\(recipe.bv)") {
                                            UIApplication.shared.open(url)
                                        }
                                    }){
                                        HStack {
                                            VStack(spacing: 5) {
                                                HStack {
                                                    Text(getEmoji(for: recipe.stuff))
                                                        .lineLimit(1)
                                                        .foregroundStyle(Color("textColor"))
                                                    Spacer()
                                                }
                                                HStack {
                                                    Text(recipe.name)
                                                        .font(.custom("JPangWa", size:18))
                                                        .foregroundStyle(Color("textColor"))
                                                        .multilineTextAlignment(.leading)
                                                    Spacer()
                                                }
                                                if recipe.tools.count > 0 {
                                                    HStack {
                                                        if recipe.difficulty != "" {
                                                            Text("\(recipe.tools.joined(separator: ", ")) | \(recipe.difficulty)")
                                                                .font(.custom("JPangWa", size:13))
                                                                .foregroundStyle(Color("textColor"))
                                                                .multilineTextAlignment(.leading)
                                                                .opacity(0.8)
                                                        } else {
                                                            Text("\(recipe.tools.joined(separator: ", "))")
                                                                .font(.custom("JPangWa", size:13))
                                                                .foregroundStyle(Color("textColor"))
                                                                .multilineTextAlignment(.leading)
                                                                .opacity(0.8)
                                                        }
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            ZStack{
                                                Color("textColor")
                                                
                                                Text("查看食谱")
                                                    .font(.custom("JPangWa", size:16))
                                                    .foregroundStyle(.white)
                                            }
                                            .frame(height: 40)
                                            .frame(width: 100)
                                            .cornerRadius(20)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color("btnColor").opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            Text("- 未找到合适的菜品 -")
                                .font(.custom("JPangWa", size:16))
                                .foregroundStyle(Color("textColor"))
                                .opacity(0.8)
                                .padding()
                        }
                    } else {
                        Text("- 请先选择食材哦 -")
                            .font(.custom("JPangWa", size:16))
                            .foregroundStyle(Color("textColor"))
                            .opacity(0.8)
                            .padding()
                    }
                    
                    HStack{
                        Text("👍支持下作者的其他APP")
                            .font(.custom("JPangWa", size:23))
                            .foregroundStyle(Color("textColor"))
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    Button(action: {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        if let url = URL(string: "https://apps.apple.com/cn/app/%E5%91%B3%E8%BF%B9-%E7%BE%8E%E9%A3%9F%E6%89%93%E5%8D%A1%E5%9B%9E%E5%BF%86%E7%B0%BF/id6737729381") {
                            UIApplication.shared.open(url)
                        }
                    }){
                        HStack {
                            Image("weiji")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .cornerRadius(10)
                            
                            VStack(spacing: 5) {
                                HStack {
                                    Text("味迹")
                                        .font(.custom("JPangWa", size:22))
                                        .foregroundStyle(Color("textColor"))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                HStack{
                                    Text("你的个人美食回忆簿")
                                        .font(.custom("JPangWa", size:13))
                                        .foregroundStyle(Color("textColor"))
                                        .multilineTextAlignment(.leading)
                                        .opacity(0.8)
                                    Spacer()
                                }
                            }
                            
                            Spacer()
                            
                            ZStack{
                                Color("textColor")
                                
                                Text("立即查看")
                                    .font(.custom("JPangWa", size:16))
                                    .foregroundStyle(.white)
                            }
                            .frame(height: 40)
                            .frame(width: 100)
                            .cornerRadius(20)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("btnColor").opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .onChange(of: selectedVegetables) {
                    updateMatchedRecipes()
                }
                .onChange(of: selectedMeats) {
                    updateMatchedRecipes()
                }
                .onChange(of: selectedStaples) {
                    updateMatchedRecipes()
                }
                .onChange(of: selectedTools) {
                    updateMatchedRecipes()
                }
            } else {
                ProgressView("加载中...")
            }
        }
        .onAppear{
            if !userPurchased {
                if useCount == 5 || useCount == 3 || useCount == 10 || useCount == 15 || useCount == 20 || useCount == 30 || useCount == 40 || useCount == 50 || useCount == 60 || useCount == 70 || useCount == 80 || useCount == 90 || useCount == 100 || useCount > 100 {
                    showBuyView = true
                }
            }
        }
    }
    
    // 更新匹配的菜品
    private func updateMatchedRecipes() {
        // 根据选中的食材和工具过滤菜品
        matchedRecipes = matchRecipes(vegetables: selectedVegetables, meats: selectedMeats, staples: selectedStaples, tools: selectedTools)
    }

    private func foodSectionView(title: String, items: [FoodItem], selection: Binding<[String]>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("JPangWa", size:23))
                .foregroundStyle(Color("textColor"))
                .padding(.bottom, 5)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(items) { item in
                    Button(action: {
                        toggleSelection(for: item, selection: selection)
                    }) {
                        VStack(spacing: 5) {
                            Text(item.emoji)
                                .font(.largeTitle)
                            Text(item.name)
                                .font(.custom("JPangWa", size:16))
                                .foregroundStyle(Color("textColor"))
                                .lineLimit(1)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selection.wrappedValue.contains(item.name) ? Color("textColor") : Color.clear, lineWidth: 3)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private func toggleSelection(for item: FoodItem, selection: Binding<[String]>) {
        if selection.wrappedValue.contains(item.name) {
            selection.wrappedValue.removeAll { $0 == item.name }
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            selection.wrappedValue.append(item.name)
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        }
    }
}

#Preview {
    ContentView()
}
