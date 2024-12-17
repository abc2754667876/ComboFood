//
//  FoodModel.swift
//  ComboFood
//
//  Created by Chengzhi 张 on 2024/12/15.
//

import Foundation

struct FoodCategory: Codable {
    let vegetable: [FoodItem]
    let meat: [FoodItem]
    let staple: [FoodItem]
    let tools: [FoodItem]
}

struct FoodItem: Codable, Identifiable {
    let id = UUID() // 确保每个项目都有唯一标识符
    let name: String
    let emoji: String
}

class FoodDataLoader: ObservableObject {
    @Published var foodCategory: FoodCategory?

    init() {
        loadJSON()
    }

    private func loadJSON() {
        guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else {
            print("未找到 food.json 文件")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(FoodCategory.self, from: data)
            DispatchQueue.main.async {
                self.foodCategory = decodedData
            }
        } catch {
            print("加载 JSON 数据失败: \(error)")
        }
    }
}

func getEmoji(for strings: [String]) -> String {
    let emojiDictionary: [String: String] = [
        "土豆": "🥔",
        "胡萝卜": "🥕",
        "花菜": "🥦",
        "白萝卜": "🥣",
        "西葫芦": "🥒",
        "番茄": "🍅",
        "芹菜": "🥬",
        "黄瓜": "🥒",
        "洋葱": "🧅",
        "莴笋": "🎍",
        "菌菇": "🍄",
        "茄子": "🍆",
        "豆腐": "🍲",
        "包菜": "🥗",
        "白菜": "🥬",
        "午餐肉": "🥓",
        "香肠": "🌭",
        "腊肠": "🌭",
        "鸡肉": "🐤",
        "猪肉": "🐷",
        "鸡蛋": "🥚",
        "虾": "🦐",
        "牛肉": "🐮",
        "骨头": "🦴",
        "鱼（Todo）": "🐟",
        "面食": "🍝",
        "面包": "🍞",
        "米": "🍚",
        "方便面": "🍜",
        "烤箱": "📺",
        "空气炸锅": "🥃",
        "微波炉": "🫕",
        "电饭煲": "🍚",
        "一口大锅": "🍳"
    ]
    
    // 根据名称返回对应的 emoji
    return strings.compactMap { emojiDictionary[$0] }.joined()
}
