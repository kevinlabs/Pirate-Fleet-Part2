//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//
//  Udacity Editor - Student Signature.
//  Code Signature.
//  3960c466b6e28ebeeaf7d8bbfb464ecf


struct GridLocation {
    let x: Int
    let y: Int
}

//This struct is Ships information.
struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    
    //Represnts the space a ship occupies.
    var cells: [GridLocation] {
        get {
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            
            var occupiedCells = [GridLocation]()
            
            for x in start.x...end.x {
                for y in start.y...end.y {
                    occupiedCells.append(GridLocation(x: x, y: y))
                    
                }
            }
            //print("printing occupiedCells", occupiedCells)
            return occupiedCells
        }
    }
    

    
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    
    var sunk: Bool {
        //Length limits loop indee
        //location is where initial loop start
        //isVertical tells us which direction we have to add the digits.
    
        var tempArray = [GridLocation]()
        var counter:Int = 0
        
        tempArray = self.cells

        for index in tempArray {
            if let temp = hitTracker.cellsHit[index] {
                if temp == true {
                    counter += 1
                }
            }
        }
        
        if counter == self.length {
            print("Ship has sunk!!")
            return true
        }
        
        return false
    }

    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.hitTracker = HitTracker()
        self.location = location
        self.isVertical = isVertical
        self.isWooden = false
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool,
         isWooden: Bool) {
        self.length = length
        self.hitTracker = HitTracker()
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
    }
    
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String

    init(location: GridLocation) {
        self.location = location
        self.guaranteesHit = false
        self.penaltyText = "Read for the mosh pit, Boom Shaka Brah"
    }
    
    init(location: GridLocation, guaranteesHit: Bool) {
        self.location = location
        self.guaranteesHit = guaranteesHit
        self.penaltyText = "Act like Sea Lion!! "
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation) {
        self.location = location
        self.guaranteesHit = true
        self.penaltyText = "Monster is in the Pit"
    }
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true)
        print(smallShip.cells)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        print(mediumShip1.cells)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: true)
        print(mediumShip2.cells)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
        print(largeShip.cells)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        print(xLargeShip.cells)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0))
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3))
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}
