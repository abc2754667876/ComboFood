//
//  RecipeModel.swift
//  ComboFood
//
//  Created by Chengzhi 张 on 2024/12/15.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id = UUID()
    let name: String
    let stuff: [String]
    let bv: String
    let difficulty: String
    let tags: [String]
    let methods: [String]
    let tools: [String]
}

func loadRecipes() -> [Recipe]? {
    guard let url = Bundle.main.url(forResource: "recipe", withExtension: "json") else {
        print("无法找到 recipe.json 文件")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let recipes = try decoder.decode([Recipe].self, from: data)
        return recipes
    } catch {
        print("加载数据失败: \(error)")
        return nil
    }
}

func matchRecipes(vegetables: [String], meats: [String], staples: [String], tools: [String]) -> [Recipe] {
    guard let recipes = loadRecipes() else { return [] }
    
    return recipes.filter { recipe in
        // 如果条件数组为空，表示该条件不限
        let matchesVegetables = vegetables.isEmpty || !Set(vegetables).isDisjoint(with: Set(recipe.stuff.filter { isVegetable($0) }))
        let matchesMeats = meats.isEmpty || !Set(meats).isDisjoint(with: Set(recipe.stuff.filter { isMeat($0) }))
        let matchesStaples = staples.isEmpty || !Set(staples).isDisjoint(with: Set(recipe.stuff.filter { isStaple($0) }))
        let matchesTools = tools.isEmpty || !Set(tools).isDisjoint(with: Set(recipe.tools))
        
        return matchesVegetables && matchesMeats && matchesStaples && matchesTools
    }
}

// 根据食材名称判断是否为素菜、荤菜或主食
func isVegetable(_ name: String) -> Bool {
    let vegetables = ["土豆", "胡萝卜", "花菜", "西葫芦", "番茄", "芹菜", "黄瓜", "洋葱", "包菜", "白菜", "茄子", "豆腐"]
    return vegetables.contains(name)
}

func isMeat(_ name: String) -> Bool {
    let meats = ["午餐肉", "香肠", "腊肠", "鸡肉", "猪肉", "鸡蛋", "虾", "牛肉", "骨头", "鱼"]
    return meats.contains(name)
}

func isStaple(_ name: String) -> Bool {
    let staples = ["面食", "面包", "米", "方便面"]
    return staples.contains(name)
}
