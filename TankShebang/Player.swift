//
//  Player.swift
//  TankShebang
//
//  Created by Sean Cao on 12/2/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import Foundation

import SpriteKit

class Player: SKSpriteNode {
    
    var colorString:String = ""
    var directionState:String = "forward"
    var health:Int = 2
    var invincible:Bool = false
    var shield:Bool = false
    var ammo:Int = 4
    var powerup:String = "Laser"
    
    var roundScore:Int = 0
    var gameScore:Int = 0
    
    
    func addShield(){
        if (!shield) {
            let Circle = SKShapeNode(circleOfRadius: self.size.height) // Size of Circle
            Circle.name = "shield"
            Circle.position = CGPoint(x:0,y:0)  //Middle of Screen
            Circle.strokeColor = SKColor.blue
            Circle.glowWidth = 1.0
            //            Circle.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height)
            //            Circle.physicsBody?.isDynamic = false
            //            Circle.physicsBody?.categoryBitMask = PhysicsCategory.shield
            //            Circle.physicsBody?.contactTestBitMask = PhysicsCategory.shot
            //            Circle.physicsBody?.collisionBitMask = PhysicsCategory.none
            self.addChild(Circle)
            shield = true
        }
    }
    
    // Moves tank forward forward or backward
    func drive(tankDriveForward:Bool, tankMoveSpeed:CGFloat) {
        
        if (health > 0){
            var direction: CGPoint
            
            // some basic trigonometry to calculate direction tanks are moving
            if ( tankDriveForward ) {
                direction = CGPoint(x:self.position.x - sin(self.zRotation) * tankMoveSpeed,y:self.position.y + cos(self.zRotation) * tankMoveSpeed)
            } else {
                direction = CGPoint(x:self.position.x + sin(self.zRotation) * tankMoveSpeed,y:self.position.y - cos(self.zRotation) * tankMoveSpeed)
            }
            
            let moveTank = SKAction.move(to: direction, duration:0)
            
            
            self.run(moveTank)
        }
    }
    
    func hit(projectile: Projectile) {
        
        
        
        // Calculate damage
        if (projectile.name == "explosive"){
            projectile.removeFromParent()
            
        } else if (shield) {
            if let shieldNode = self.childNode(withName: "shield") as? SKShapeNode {
                shieldNode.removeFromParent()
            }
            shield = false
            if(projectile.owner == self){
                projectile.owner.gameScore -= 10
            } else {
                projectile.owner.gameScore += 10
                print(projectile.owner.gameScore)
            }
        } else {
            if (!invincible){
                if (projectile.isLaser){
                    health = 0
                    projectile.owner.gameScore += 25
                } else {
                    health -= 1
                    if(projectile.owner == self){
                        projectile.owner.gameScore -= 10
                    } else {
                        projectile.owner.gameScore += 10
                        print(projectile.owner.gameScore)
                    }
                }
            }
        }
        
        // Remove projectile from parent
        if (!projectile.isLaser){
            projectile.removeFromParent()
        }
        
        // Calculate dead or not
        if (health == 0){
            self.removeFromParent()
        } else {
            temporaryInvincibility()
        }
    }
    
    func explode(explosion: SKShapeNode) {
        
        // Calculate damage
        if (shield) {
            if let shieldNode = self.childNode(withName: "shield") as? SKShapeNode {
                shieldNode.removeFromParent()
            }
            shield = false
        } else {
            if (!invincible){
                health = 0
            }
        }
        
        // Calculate dead or not
        if (health == 0){
            self.removeFromParent()
        } else {
            temporaryInvincibility()
        }
    }
    
    func temporaryInvincibility() {
        let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: 0.25)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.25)
        
        let seq:SKAction = SKAction.sequence( [ fadeOut, fadeIn ])
        
        self.run(seq)
        
        invincible = true
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.invincible = false
        }
    }
    
    func fireProjectile() {

        if ( !self.powerup.isEmpty ){
            if (self.powerup == "Laser"){
                fireLaser();
            }
        } else if ( self.ammo > 0 ) {
            let projectile:Projectile = Projectile(imageNamed: "DefaultProjectile")
            projectile.owner = self
            let direction = CGPoint(x:self.position.x - sin(self.zRotation) * 2000,y:self.position.y + cos(self.zRotation) * 2000)
            let xDirection = self.position.x - sin(self.zRotation) + (-40 * sin(self.zRotation))
            let yDirection = self.position.y + cos(self.zRotation) + (40 * cos(self.zRotation))

            projectile.position = CGPoint(x: xDirection,y:yDirection)

            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.obstacle
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true

            self.parent?.addChild(projectile)

            let shoot = SKAction.move(to: direction, duration: 2.0)
            let shootDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([shoot, shootDone]))

            self.ammo -= 1
            let spriteFile = self.colorString + String(ammo)
            self.texture = SKTexture(imageNamed: spriteFile)
        }
    }
    
    func fireLaser() {
        let projectile:Projectile = Projectile(imageNamed: "Laser")
        projectile.owner = self
        projectile.isLaser = true
        
        projectile.setScale(0.5)
        projectile.zRotation = self.zRotation
        let direction = CGPoint(x:self.position.x - sin(self.zRotation) * 2000,y:self.position.y + cos(self.zRotation) * 2000)
        let xDirection = self.position.x - sin(self.zRotation) + (-100 * sin(self.zRotation))
        let yDirection = self.position.y + cos(self.zRotation) + (100 * cos(self.zRotation))

        projectile.position = CGPoint(x: xDirection,y:yDirection)

        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.laser
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        self.parent?.addChild(projectile)

        let shoot = SKAction.move(to: direction, duration: 1.0)
        let shootDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([shoot, shootDone]))
    }
    
    @objc func reload() {
        if (self.ammo < 4) {
            self.ammo += 1
            let spriteFile = self.colorString + String(ammo)
            self.texture = SKTexture(imageNamed: spriteFile)
        }
        
    }
    
}
