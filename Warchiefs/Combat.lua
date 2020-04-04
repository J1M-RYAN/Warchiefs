    local composer = require("composer")
    local enemy = require("TestData2")
    local player = require("playerData")
    local widget = require("widget")
    local scene = composer.newScene()
        
    -- -----------------------------------------------------------------------------------
    -- Code outside of the scene event functions below will only be executed ONCE unless
    -- the scene is removed entirely (not recycled) via "composer.removeScene()"
    -- -----------------------------------------------------------------------------------

    -- -----------------------------------------------------------------------------------
    -- Scene event functions
    -- -----------------------------------------------------------------------------------

    -- create()
    function scene:create(event)
        local sceneGroup = self.view
        -- Code here runs when the scene is first created but has not yet appeared on screen
    end

    -- show()
    function scene:show(event)
        local sceneGroup = self.view
        local phase = event.phase


        if (phase == "will") then
            -- Code here runs when the scene is still off screen (but is about to come on screen)


    -- background castle view
        local background = display.newImageRect("images/combatBackground.png", 1280, 620)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        --player and enemy


        local enemy_pic = display.newImageRect("images/lvl3.png", 390, 290)
        enemy_pic.x = 700
        enemy_pic.y = 470
        enemy_pic.xScale = -.8


        --health bars

        local health_bar_outter = display.newImageRect("images/healthbar.png", 225, 35)
        health_bar_outter.x = 225      
        health_bar_outter.y = 663


        local health_bar_outter2 = display.newImageRect("images/healthbar.png", 425, 35)
        health_bar_outter2.x = 995      
        health_bar_outter2.y = 663

        local enemyHealthBar = require("enemyHealthBar")
        local playerHealthBar = require("healthBar")
    
        local health_bar_outter3 = display.newImageRect("images/heart.png", 55, 60)
        health_bar_outter3.x = 110   
        health_bar_outter3.y = 660


        local health_bar_outter4 = display.newImageRect("images/heart.png", 55, 60)
        health_bar_outter4.x = 1200   
        health_bar_outter4.y = 660

        local sheetOptions =
        {
            width = 300,
            height = 300,
            numFrames = 4,
            sheetContentWidth = 1200,
            sheetContentHeight = 300
        }

        local attack_sheet = graphics.newImageSheet( "images/attackanimation2.png", sheetOptions )
        
        local sequenceData = {
        {name="attack", frames={1,2,3,4,1}, time=800, loopCount =1,loopDirection = "forward"}
        }

 --       local attack_animation = display.newSprite(attack_sheet, sequenceData )
        local attack_animation = display.newSprite( attack_sheet, sequenceData )        
        attack_animation.x = 510
        attack_animation.y = 480
        attack_animation.xScale = .7
        attack_animation.yScale = .7
-- Condition for Attack function if false then do nothing
    local bothAlive = true
    
    
        -- getting max and min for probabilty of hit chance depending on player/enemy Level

    local function generateHitChance(level)
            local hitChance = 0
            if(level==1)then
                    hitChance = math.random(30,60)
            elseif(level == 2)then
                    hitChance = math.random(40,70)
            elseif(level == 3)then
                    hitChance = math.random(50,80)
            else
              print("invalid operation")
            end

            return hitChance
        end

    local function hitOrMiss(hitChance)
            local hitRange=0
            local hitRangeMax=0
            local hitRangeMin=0
            local hit =false
            hitRange=math.random(1,3) 
            if(hitRange == 1) then
                    hitRangeMin = 0
                    hitRangeMax = 30
            elseif (hitRange == 2) then
                    hitRangeMin = 31
                    hitRangeMax = 60
            elseif (hitRange==3) then
                    hitRangeMin = 61
                    hitRangeMax = 100
            else
              print("hit range else")
            end
        print(hitRange)
        print(hitRangeMin)
        print(hitRangeMax)

            if(hitChance >= hitRangeMin and hitChance <=hitRangeMax) then
                print("hit landed")
                hit = true
                return hit
            else
                hitText(id, 0 , true)
                print("missed")
                return hit
            end
    end

    local function applyDamage(id, health, damage)
            --below decides whose health should be deducted by damage
            print("appkydamage".. id)
            if(id == "enemy")then
                    player.health = health - damage
            elseif(id == "player")then
                    enemy.health =health - damage
                    print(enemy.health .. "enemy health")
            end
    end
                     
    local function applyDamageHealthBar(id,damage)
                    
                    local health_bar_Scale
                    local totalHealth 
                    if(id == "enemy")then
                        health_bar_scale = playerHealthBar.xScale
                        totalHealth = player.totalHealth
                    elseif( id =="player") then
                        health_bar_scale = enemyHealthBar.xScale
                        totalHealth = enemy.totalHealth
                    end  

                    if(health_bar_scale > 0.015) then -- do nothing, this code is here to stop crashing as if scaler cant be brought to zero
                        local barDamage = damage/totalHealth
                        print(barDamage .. "barDamage")

                        print("below is perdictedDamage before")
                        print(health_bar_scale)
                        local perdictedDamage = health_bar_scale - barDamage

                        print("below is perdictedDamage")
                        print(perdictedDamage)
                    
                        if(perdictedDamage >= 0.015)then-- its here to stop bar going - on scale
                                if(id=="player")then
                                     enemyHealthBar.xScale = perdictedDamage
                                else
                                     playerHealthBar.xScale = perdictedDamage
                                end
                        else
                            if(id=="player")then
                                     enemyHealthBar.xScale= 0.01
                                else
                                     playerHealthBar.xScale = 0.01
                                end
                        end
                    end
    end





    --hit text boxes method

     function hitText(id, damage, miss)
        

        if(id == "player" and miss ==false)then
            -- testing animation
            attack_animation:play()
            -- initializing hit text boxes
            local playerhit = display.newText( "", 200, 200, native.systemFont, 40 )
            playerhit:setFillColor( 1, 0, 0 )
            playerhit.text = "Player did " .. damage .. "damage"
            transition.moveTo( playerhit, { x=300, y=400, time=2000 }) 
             transition.fadeOut( playerhit, { time=2300 } )
        elseif(id == "player" and miss ==true) then
            -- initializing hit text boxes
            local playerhit = display.newText( "", 200, 200, native.systemFont, 40 )
            playerhit:setFillColor( 1, 0, 0 )
            playerhit.text = "Player missed !"
            transition.moveTo( playerhit, { x=300, y=400, time=2000 }) 
            transition.fadeOut( playerhit, { time=2300 } )
        end    

        if(id == "enemy" and miss ==false)then
            local enemyhit = display.newText( "", 1000, 200, native.systemFont, 40 )
            enemyhit:setFillColor( 1, 0, 0 )
            enemyhit.text = "enemy did " .. damage .. "damage"
            transition.moveTo( enemyhit, { x=1200, y=400, time=2000 }) 
             transition.fadeOut( enemyhit, { time=2300 } )
            
        elseif(id == "enemy" and miss ==true) then
            local enemyhit = display.newText( "", 1000, 200, native.systemFont, 40 )
            enemyhit:setFillColor( 1, 0, 0 )
            enemyhit.text = "enemy missed !"
            transition.moveTo( enemyhit, { x=1200, y=400, time=2000 }) 
             transition.fadeOut( enemyhit, { time=2300 } )
        end    

    end --hitText end


    --player levelup method
    function playerLevelUp()
        --Storing old stats if need to be printed to show progress
        local temp = {player.level,player.health,player.weapon,player.attributePoints,player.gold,player.totalHealth}

        --updating player stats
        player.level = player.level + 1
        player.health = player.health + 50
        player.weapon = player.weapon + 10
        player.attributePoints = player.attributePoints + 5
        player.gold = player.gold + 1000
        player.totalHealth = player.totalHealth + 50    
        
        --print player stats on screen 

        local header = display.newText( "         LEVEL UP     " , 500, 200, native.systemFont, 140 )
        header:setFillColor( 1, 0, 0 )


    end-- end of playerlevelup


    -- health potion method
    function healthPotion()
        if(player.health >0)then
            local smallHealthPotions = 40
            local heath_bar_add = smallHealthPotions/player.totalHealth
            local perdictedHealth = player.health + smallHealthPotions
            if( perdictedHealth <= player.totalHealth)then

                if (player.healthPotions > 0) then
                    
                    player.health = player.health + smallHealthPotions
                    playerHealthBar.xScale = playerHealthBar.xScale + heath_bar_add
                    player.healthPotions = player.healthPotions - 1
                else
                    --do nothing

                end
            end
        end
    end-- end of health potion


--Atack function
    local function AttackTurn(id, health, level, damage) --here enter whose health needs to be reduced
       if(player.health <= 0 or enemy.health <= 0)then
            bothAlive =false
       end

       if(bothAlive ==true)then
            local hitChance = 0
            hitChance = generateHitChance(level)
            print(hitChance)
            local hit = false
            hit = hitOrMiss(hitChance)
            print(hit)
            if(hit == true)then
                applyDamage(id, health,damage)
                applyDamageHealthBar(id, damage)
                hitText(id,damage,false)
            elseif(hit== false) then
                hitText(id, 0 , true)
                print("missed")
            end
        else
            --do nothing
        end
    end -- end of attack function


--Set button enable after enemy turn
    local function activateAttactButton( )
        print("i was called activateAttactButton")
        button1:setEnabled(true)
    end
--enemyAttack Event
    local function enemyTurn()
        AttackTurn(enemy.id, player.health, enemy.level, enemy.damage)
        timer.performWithDelay( 2000, activateAttactButton )
    end

--playerAttack Event
    local function PlayerTurn()
        
        AttackTurn(player.id, enemy.health, player.level, player.damage)
        button1:setEnabled(false)
         timer.performWithDelay( 2000, enemyTurn )

    end


    
-- Create attack button
     button1 = widget.newButton(
        { labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },

            left = 450,
            top = 600,
            fontSize = 40,
            id = "button1",
            label = "Attack",
            onRelease =  PlayerTurn,
            isEnabled = true
        }
    )


    -- Create Health potion button
    local button2 = widget.newButton(
        { labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },

            left = 450,
            top = 650,
            fontSize = 40,
            id = "button2",
            label = "Health potions",
            isEnabled = true,
            onRelease = healthPotion
        }
    )

--exit to world map func
    local function goToWorldMap(event)
            if ("ended" == event.phase) then
                composer.gotoScene("worldmap")
            end
        end
-- exit combat screen button
    local button2 = widget.newButton(
        { labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },

            left = 850,
            top = 250,
            fontSize = 40,
            id = "exit",
            label = "Exit to World",
            onRelease = goToWorldMap
        }
    )
    -- ANIMATION TESTS 



        local attack_sheet1 = graphics.newImageSheet( "images/attackAnimation1.png", sheetOptions )
        
 --       local animation = display.newSprite(attack_sheet, sequenceData )
        local animation1 = display.newSprite( attack_sheet1, sequenceData )        
        animation1.x = 110
        animation1.y = 180
        animation1.xScale = 1
        animation1.yScale = 1

        local attack_sheet2 = graphics.newImageSheet( "images/attackAnimation2.png", sheetOptions )
        
 --       local animation = display.newSprite(attack_sheet, sequenceData )
        local animation2 = display.newSprite( attack_sheet2, sequenceData )        
        animation2.x = 350
        animation2.y = 180
        animation2.xScale = 1
        animation2.yScale = 1

        local attack_sheet3 = graphics.newImageSheet( "images/attackAnimation3Test.png", sheetOptions )
        
 --       local animation = display.newSprite(attack_sheet, sequenceData )
        local animation3 = display.newSprite( attack_sheet3, sequenceData )        
        animation3.x = 660
        animation3.y = 180
        animation3.xScale = 1
        animation3.yScale = 1

    local function playAnimations()
        animation1:play()
        animation2:play()
        animation3:play()
    end

    local button3 = widget.newButton(
        { labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },

            left = 150,
            top = 350,
            fontSize = 40,
            id = "exit",
            label = "ANIMATIONS",
            onRelease = playAnimations
        }
    )

        elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        end
    end

        






    -- hide()
    function scene:hide(event)
        local sceneGroup = self.view
        local phase = event.phase

        if (phase == "will") then
            -- Code here runs when the scene is on screen (but is about to go off screen)
        elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
        end
    end

    -- destroy()
    function scene:destroy(event)
        local sceneGroup = self.view
        -- Code here runs prior to the removal of scene's view
    end

    -- -----------------------------------------------------------------------------------
    -- Scene event function listeners
    -- -----------------------------------------------------------------------------------
    scene:addEventListener("create", scene)
    scene:addEventListener("show", scene)
    scene:addEventListener("hide", scene)
    scene:addEventListener("destroy", scene)
    -- -----------------------------------------------------------------------------------

    return scene