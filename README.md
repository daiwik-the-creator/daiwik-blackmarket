# daiwik-blackmarket

    Reputation based Black Market For QB-Core

# Dependencies

    qb-menu     - https://github.com/qbcore-framework/qb-menu
    qb-target   - https://github.com/qbcore-framework/qb-target
    PolyZone    - https://github.com/mkafrin/PolyZone
    oxmysql     - https://github.com/overextended/oxmysql

# Reputation System

    The reputation system can be added to other criminal activities to allow 
    players to unlock and trade/purchase additional items from the Black Market. 

    Giving Reputation to a Player:

    Client:
    TriggerEvent('daiwik-blackmarket:AddReputation', 0-100)    ~ The Maximum Reputation a Player can earn is 100.

# Adding Items to the Black Market

    Items can be added to the Black Market through the config.lua provided along
    with this resource.

    Make sure you add the items according to the following example:
    
    [1] = {                               ~ Index Number for the Item.
        item = "trojan_usb",              ~ The Item you want to add.
        rep = 0,                          ~ The required reputation to be able to purchase the item.
        type = "Cash",                    ~ The mode of payment can be either "Items" | "Cash" | "Crypto" 
        costs = {                         ~ The Cost/Requirement to purchase the item. 
            ["Cash"] = 25000,             ~ The Name and Cost of the Required item. Should be "Cash" for cash and "Crypto" for crypto.
        },
        icon = "fa-solid fa-laptop-code", ~ The icons for each item. You can find these at https://fontawesome.com/icons
    },

    Important: You can only use costs of the specified type i.e. 

    You can only use "Cash" as a cost only if you specify the type as "Cash".
    You can only use "Crypto" as a cost only if you specify the type as "Crypto".
    You can use any inventory items for the type "Items".

    Incase you don't adhere to the instructions provided above the resource will most likely not work as intended.

# License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>