for i,v in pairs(getgc()) do
    if type(v) == "function" and tostring(getfenv(v).script) == "JobManager" then
        if getinfo(v).name == "GetJob" then
            getgenv().Job = v
        end        
    end
end

getgenv().BloxyBurgersCashierFarm = true;

while wait() do
    if BloxyBurgersCashierFarm and Job() == "BloxyBurgersCashier" then
        for i,v in pairs(workspace.Environment.Locations.BloxyBurgers.CashierWorkstations:GetChildren()) do 
            if tostring(v.InUse.Value) == game.Players.LocalPlayer.Name then
                if v.Occupied.Value.Order then
                    local BurgerValue = v.Occupied.Value.Order.Burger.Value
                    local FriesValue = v.Occupied.Value.Order.Fries.Value
                    local ColaValue = v.Occupied.Value.Order.Cola.Value
            
                    warn(BurgerValue, FriesValue, ColaValue)
            
                    if BurgerValue ~= nil or BurgerValue ~= false then
                        wait(0.2)
                        getconnections(v.OrderDisplay.DisplayMain.CashierGUI.Frame[BurgerValue].Activated)[1]:Fire()
                    end
            
                    if ColaValue == true then
                        wait(0.2)
                        getconnections(v.OrderDisplay.DisplayMain.CashierGUI.Frame["Cola"].Activated)[1]:Fire()
                    end
            
                    if FriesValue == true then
                        wait(0.2)
                        getconnections(v.OrderDisplay.DisplayMain.CashierGUI.Frame["Fries"].Activated)[1]:Fire()
                    end
                    
                    wait(0.5)
                    
                    getconnections(v.OrderDisplay.DisplayMain.CashierGUI.Frame["Done"].Activated)[1]:Fire()
            
                end
            end
        end
    end

    wait(3)
end