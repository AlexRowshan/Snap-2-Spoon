//
//  RecipeModel.swift
//  s2s
//
//  Created by Cory DeWitt on 2/13/25.
//

import Foundation
import CloudKit

struct RecipeModel: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var userId: String
    var name: String
    var duration: String
    var difficulty: String
    var ingredients: [String]
    var instructions: [String]
    var nutritionalInfo: [String: String]?
    var healthBenefits: [String]?
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, userId, name, duration, difficulty, ingredients, instructions, nutritionalInfo, healthBenefits, createdAt
    }
    
    init(id: String = UUID().uuidString,
             name: String,
             duration: String,
             difficulty: String,
             ingredients: [String],
             instructions: [String],
             userId: String = "",
             nutritionalInfo: [String: String]? = nil,
             healthBenefits: [String]? = nil,
             createdAt: Date = Date()) {
            self.id = id
            self.name = name
            self.duration = duration
            self.difficulty = difficulty
            self.ingredients = ingredients
            self.instructions = instructions
            self.userId = userId
            self.nutritionalInfo = nutritionalInfo
            self.healthBenefits = healthBenefits
            self.createdAt = createdAt
        }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? UUID().uuidString
        userId = (try? container.decode(String.self, forKey: .userId)) ?? ""
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(String.self, forKey: .duration)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        ingredients = try container.decode([String].self, forKey: .ingredients)
        instructions = try container.decode([String].self, forKey: .instructions)
        nutritionalInfo = try? container.decode([String: String].self, forKey: .nutritionalInfo)
        healthBenefits = try? container.decode([String]?.self, forKey: .healthBenefits)
        createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date()
    }
    
    init(record: CKRecord) {
        self.id = record.recordID.recordName
        self.userId = record["userId"] as? String ?? ""
        self.name = record["name"] as? String ?? ""
        self.duration = record["duration"] as? String ?? ""
        self.difficulty = record["difficulty"] as? String ?? ""
        self.ingredients = record["ingredients"] as? [String] ?? []
        self.instructions = record["instructions"] as? [String] ?? []
        
        if let nutritionData = record["nutritionalInfo"] as? Data,
           let nutrition = try? JSONDecoder().decode([String: String].self, from: nutritionData) {
            self.nutritionalInfo = nutrition
        } else {
            self.nutritionalInfo = nil
        }
        
        self.healthBenefits = record["healthBenefits"] as? [String]
        
        // Get creation date from record or use current date
        if let creationDate = record["createdAt"] as? Date {
            self.createdAt = creationDate
        } else if let creationDate = record.creationDate {
            // Fall back to CloudKit's record creation date
            self.createdAt = creationDate
        } else {
            self.createdAt = Date()
        }
    }
    
    func toRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: "Recipe", recordID: recordID)
        record["name"] = name
        record["duration"] = duration
        record["difficulty"] = difficulty
        record["ingredients"] = ingredients
        record["instructions"] = instructions
        record["userId"] = userId
        record["createdAt"] = createdAt
        
        // Store nutritional info if it exists
        if let nutritionInfo = nutritionalInfo,
           let nutritionData = try? JSONEncoder().encode(nutritionInfo) {
            record["nutritionalInfo"] = nutritionData
        }
        
        // Store health benefits if they exist
        if let benefits = healthBenefits {
            record["healthBenefits"] = benefits
        }
        
        return record
    }

    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id
    }
}
