//
//  HealthDataSet.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/16.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation
import HealthKit

struct HealthDataTypes {
    // https://developer.apple.com/documentation/healthkit/hkcharacteristictypeidentifier
    static let characteristicKeysAndTypes: Dictionary<String, HKCharacteristicType> = [
        "biologicalSex" : HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
        "dateOfBirth" : HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        "wheelchairUse" : HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!
    ]
    
    // https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier
    static let sampleKeyAndTypes: Dictionary<String, HKSampleType> = [
        "workout" : HKObjectType.workoutType(),

        // -- Activity
        "stepCount" : HKObjectType.quantityType(forIdentifier: .stepCount)!,
        "distanceWalkingRunning" : HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        "distanceCycling" : HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
        "pushCount" : HKObjectType.quantityType(forIdentifier: .pushCount)!,
        "distanceWheelchair" : HKObjectType.quantityType(forIdentifier: .distanceWheelchair)!,
        "swimmingStrokeCount" : HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)!,
        "distanceSwimming" : HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
        "distanceDownhillSnowSports" : HKObjectType.quantityType(forIdentifier: .distanceDownhillSnowSports)!,
        "basalEnergyBurned" : HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
        "activeEnergyBurned" : HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        "flightsClimbed" : HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
        // Apple は nikeFuel, appleExerciseTime, appleStandTime にアクセスすることを禁じているらしい
        // "nikeFuel" : HKObjectType.quantityType(forIdentifier: .nikeFuel)!,
        // "appleExerciseTime" : HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        // "appleStandTime" : HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
        "vo2Max" : HKObjectType.quantityType(forIdentifier: .vo2Max)!,

        // -- Body Measurements
        "height" : HKObjectType.quantityType(forIdentifier: .height)!,
        "bodyMass" : HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        "bodyMassIndex" : HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
        "leanBodyMass" : HKObjectType.quantityType(forIdentifier: .leanBodyMass)!,
        "bodyFatPercentage" : HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
        "waistCircumference" : HKObjectType.quantityType(forIdentifier: .waistCircumference)!,
        
        // -- Reproductive Health
        "basalBodyTemperature" : HKObjectType.quantityType(forIdentifier: .basalBodyTemperature)!,

        // -- Hearing
        "environmentalAudioExposure" : HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!,
        "headphoneAudioExposure" : HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)!,
        
        // -- Vital Signs
        "heartRate" : HKObjectType.quantityType(forIdentifier: .heartRate)!,
        "restingHeartRate" : HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        // Apple は walkingHeartRateAverage にアクセスすることを禁じているらしい
        // "walkingHeartRateAverage" : HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
        "heartRateVariabilitySDNN" : HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        "oxygenSaturation" : HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
        "bodyTemperature" : HKObjectType.quantityType(forIdentifier: .bodyTemperature)!,
        "bloodPressureDiastolic" : HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
        "bloodPressureSystolic" : HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
        "respiratoryRate" : HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,

        // -- Lab and Test Results
        "bloodAlcoholContent" : HKObjectType.quantityType(forIdentifier: .bloodAlcoholContent)!,
        "bloodGlucose" : HKObjectType.quantityType(forIdentifier: .bloodGlucose)!,
        "electrodermalActivity" : HKObjectType.quantityType(forIdentifier: .electrodermalActivity)!,
        "forcedExpiratoryVolume1" : HKObjectType.quantityType(forIdentifier: .forcedExpiratoryVolume1)!,
        "forcedVitalCapacity" : HKObjectType.quantityType(forIdentifier: .forcedVitalCapacity)!,
        "inhalerUsage" : HKObjectType.quantityType(forIdentifier: .inhalerUsage)!,
        "insulinDelivery" : HKObjectType.quantityType(forIdentifier: .insulinDelivery)!,
        "numberOfTimesFallen" : HKObjectType.quantityType(forIdentifier: .numberOfTimesFallen)!,
        "peakExpiratoryFlowRate" : HKObjectType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!,
        "peripheralPerfusionIndex" : HKObjectType.quantityType(forIdentifier: .peripheralPerfusionIndex)!,
        
        // -- Nutrition
        "dietaryBiotin" : HKObjectType.quantityType(forIdentifier: .dietaryBiotin)!,
        "dietaryCaffeine" : HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!,
        "dietaryCalcium" : HKObjectType.quantityType(forIdentifier: .dietaryCalcium)!,
        "dietaryCarbohydrates" : HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
        "dietaryChloride" : HKObjectType.quantityType(forIdentifier: .dietaryChloride)!,
        "dietaryCholesterol" : HKObjectType.quantityType(forIdentifier: .dietaryCholesterol)!,
        "dietaryChromium" : HKObjectType.quantityType(forIdentifier: .dietaryChromium)!,
        "dietaryCopper" : HKObjectType.quantityType(forIdentifier: .dietaryCopper)!,
        "dietaryEnergyConsumed" : HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        "dietaryFatMonounsaturated" : HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!,
        "dietaryFatPolyunsaturated" : HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!,
        "dietaryFatSaturated" : HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)!,
        "dietaryFatTotal" : HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
        "dietaryFiber" : HKObjectType.quantityType(forIdentifier: .dietaryFiber)!,
        "dietaryFolate" : HKObjectType.quantityType(forIdentifier: .dietaryFolate)!,
        "dietaryIodine" : HKObjectType.quantityType(forIdentifier: .dietaryIodine)!,
        "dietaryIron" : HKObjectType.quantityType(forIdentifier: .dietaryIron)!,
        "dietaryMagnesium" : HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)!,
        "dietaryManganese" : HKObjectType.quantityType(forIdentifier: .dietaryManganese)!,
        "dietaryMolybdenum" : HKObjectType.quantityType(forIdentifier: .dietaryMolybdenum)!,
        "dietaryNiacin" : HKObjectType.quantityType(forIdentifier: .dietaryNiacin)!,
        "dietaryPantothenicAcid" : HKObjectType.quantityType(forIdentifier: .dietaryPantothenicAcid)!,
        "dietaryPhosphorus" : HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus)!,
        "dietaryPotassium" : HKObjectType.quantityType(forIdentifier: .dietaryPotassium)!,
        "dietaryProtein" : HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
        "dietaryRiboflavin" : HKObjectType.quantityType(forIdentifier: .dietaryRiboflavin)!,
        "dietarySelenium" : HKObjectType.quantityType(forIdentifier: .dietarySelenium)!,
        "dietarySodium" : HKObjectType.quantityType(forIdentifier: .dietarySodium)!,
        "dietarySugar" : HKObjectType.quantityType(forIdentifier: .dietarySugar)!,
        "dietaryThiamin" : HKObjectType.quantityType(forIdentifier: .dietaryThiamin)!,
        "dietaryVitaminA" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)!,
        "dietaryVitaminB12" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)!,
        "dietaryVitaminB6" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)!,
        "dietaryVitaminC" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)!,
        "dietaryVitaminD" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)!,
        "dietaryVitaminE" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)!,
        "dietaryVitaminK" : HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)!,
        "dietaryWater" : HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        "dietaryZinc" : HKObjectType.quantityType(forIdentifier: .dietaryZinc)!,
        
        // -- Mobility
        "sixMinuteWalkTestDistance" : HKObjectType.quantityType(forIdentifier: .sixMinuteWalkTestDistance)!,
        "walkingSpeed" : HKObjectType.quantityType(forIdentifier: .walkingSpeed)!,
        "walkingStepLength" : HKObjectType.quantityType(forIdentifier: .walkingStepLength)!,
        // Apple は walkingAsymmetryPercentage の取得を禁じているらしい。
        // "walkingAsymmetryPercentage" : HKObjectType.quantityType(forIdentifier: .walkingAsymmetryPercentage)!,
        "walkingDoubleSupportPercentage" : HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!,
        "stairAscentSpeed" : HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!,
        "stairDescentSpeed" : HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!,
        
        // -- UV Exposure
        "uvExposure" : HKObjectType.quantityType(forIdentifier: .uvExposure)!,
    ]
    
    // https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier
    static let categoryKeysAndTypes: Dictionary<String, HKCategoryType> = [
        // -- Activity
        "appleStandHour" : HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
        "lowCardioFitnessEvent" : HKObjectType.categoryType(forIdentifier: .lowCardioFitnessEvent)!,
        
        // -- Reproductive Health
        "cervicalMucusQuality" : HKObjectType.categoryType(forIdentifier: .cervicalMucusQuality)!,
        "contraceptive" : HKObjectType.categoryType(forIdentifier: .contraceptive)!,
        "intermenstrualBleeding" : HKObjectType.categoryType(forIdentifier: .intermenstrualBleeding)!,
        "lactation" : HKObjectType.categoryType(forIdentifier: .lactation)!,
        "menstrualFlow" : HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
        "ovulationTestResult" : HKObjectType.categoryType(forIdentifier: .ovulationTestResult)!,
        "pregnancy" : HKObjectType.categoryType(forIdentifier: .pregnancy)!,
        "sexualActivity" : HKObjectType.categoryType(forIdentifier: .sexualActivity)!,
        
        // -- Hearing
        "environmentalAudioExposureEvent" : HKObjectType.categoryType(forIdentifier: .environmentalAudioExposureEvent)!,
        "headphoneAudioExposureEvent" : HKObjectType.categoryType(forIdentifier: .headphoneAudioExposureEvent)!,
        
        // -- Vital Signs
        "lowHeartRateEvent" : HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent)!,
        "highHeartRateEvent" : HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!,
        "irregularHeartRhythmEvent" : HKObjectType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
        

        // - Mindfulness and Sleep
        "mindfulSession" : HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
        "sleepAnalysis" : HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        
        // -- Self Care
        "toothbrushingEvent" : HKObjectType.categoryType(forIdentifier: .toothbrushingEvent)!,
        "handwashingEvent" : HKObjectType.categoryType(forIdentifier: .handwashingEvent)!,
    ]
    
    // Apple は HKCorrelationType にアクセスすることを禁じている
//    // https://developer.apple.com/documentation/healthkit/hkcorrelationtypeidentifier
//    static let correlationKeysAndTypes: Dictionary<String, HKCorrelationType> = [
//        "bloodPressure" : HKObjectType.correlationType(forIdentifier: .bloodPressure)!,
//        "food": HKObjectType.correlationType(forIdentifier: .food)!
//    ]
    
    static let characteristicTypes : Set<HKCharacteristicType> = Set(HealthDataTypes.characteristicKeysAndTypes.values)
    static let sampleTypes: Set<HKSampleType> = Set(HealthDataTypes.sampleKeyAndTypes.values)
    static let categoryTypes: Set<HKCategoryType> = Set(HealthDataTypes.categoryKeysAndTypes.values)
    // static let correlationTypes: Set<HKCorrelationType> = Set(HealthDataTypes.correlationKeysAndTypes.values)
    static let activeSummaryType = HKObjectType.activitySummaryType()
    static let typesToRead: Set<HKObjectType> =
        Set(
            HealthDataTypes.characteristicTypes.map { t in t as HKObjectType } +
            HealthDataTypes.sampleTypes.map { t in t as HKObjectType } +
            HealthDataTypes.categoryTypes.map { t in t as HKObjectType } +
            // HealthDataTypes.correlationTypes.map { t in t as HKObjectType } +
            [HealthDataTypes.activeSummaryType as HKObjectType])
    
    static let workoutTypeDic : Dictionary<HKWorkoutActivityType, String> = [
        .archery : "archery",
        .bowling : "bowling",
        .fencing : "fencing",
        .gymnastics : "gymnastics",
        .trackAndField : "trackAndField",
        .americanFootball : "americanFootball",
        .australianFootball : "australianFootball",
        .baseball : "baseball",
        .basketball : "basketball",
        .cricket : "cricket",
        .handball : "handball",
        .hockey : "hockey",
        .lacrosse : "lacrosse",
        .rugby : "rugby",
        .soccer : "soccer",
        .softball : "softball",
        .volleyball : "volleyball",
        .preparationAndRecovery : "preparationAndRecovery",
        .flexibility : "flexibility",
        .walking : "walking",
        .running : "running",
        .wheelchairWalkPace : "wheelchairWalkPace",
        .wheelchairRunPace : "wheelchairRunPace",
        .cycling : "cycling",
        .handCycling : "handCycling",
        .coreTraining : "coreTraining",
        .elliptical : "elliptical",
        .functionalStrengthTraining : "functionalStrengthTraining",
        .traditionalStrengthTraining : "traditionalStrengthTraining",
        .crossTraining : "crossTraining",
        .mixedCardio : "mixedCardio",
        .highIntensityIntervalTraining : "highIntensityIntervalTraining",
        .jumpRope : "jumpRope",
        .stairClimbing : "stairClimbing",
        .stairs : "stairs",
        .stepTraining : "stepTraining",
        .barre : "barre",
        .cardioDance : "cardioDance",
        .socialDance : "socialDance",
        .yoga : "yoga",
        .mindAndBody : "mindAndBody",
        .pilates : "pilates",
        .badminton : "badminton",
        .racquetball : "racquetball",
        .squash : "squash",
        .tableTennis : "tableTennis",
        .tennis : "tennis",
        .climbing : "climbing",
        .equestrianSports : "equestrianSports",
        .fishing : "fishing",
        .golf : "golf",
        .hiking : "hiking",
        .hunting : "hunting",
        .play : "play",
        .crossCountrySkiing : "crossCountrySkiing",
        .curling : "curling",
        .downhillSkiing : "downhillSkiing",
        .snowSports : "snowSports",
        .snowboarding : "snowboarding",
        .skatingSports : "skatingSports",
        .paddleSports : "paddleSports",
        .rowing : "rowing",
        .sailing : "sailing",
        .surfingSports : "surfingSports",
        .swimming : "swimming",
        .waterFitness : "waterFitness",
        .waterPolo : "waterPolo",
        .waterSports : "waterSports",
        .boxing : "boxing",
        .kickboxing : "kickboxing",
        .martialArts : "martialArts",
        .taiChi : "taiChi",
        .wrestling : "wrestling",
        .other : "other",
    ]
}
