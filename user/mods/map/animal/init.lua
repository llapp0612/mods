local print = require("util.print")
local color = require("util.print.color")
local lib = require("util.lib")

local location = "map.animal"

local mouse_old_y = 0
local mouse_old_x = 0
local zoom = 8
local index_old = 0

local M = {};

function M.exist()
    return true
end

-------------------------------------------------------------------
function M.mouse_over_icon_over(pos, zoom, index)
    mouse_old_x, mouse_old_y = getMousePos()

    --M.tooltipText()
    local whm = getUI("ui:interface:webig_html_modal")
    runAH(nil, "enter_modal", "group=ui:interface:webig_html_modal")

    whm.child_resize_h=false
 
    local whm_html = getUI("ui:interface:webig_html_modal:html")
    local html_display_map_img = [[<table width="100%">
                <tr align="left">
                    <td><img src="https://api.bmsite.net/maps/static?center=]]..pos.x..[[,]]..pos.y..[[&zoom=]]..zoom..[[&markers=icon:mektoub|color:0x00ff00|label:]]..M.getAnimalName(index)..[[|]]..pos.x..[[,]]..pos.y..[[&maptype=satellite&mapmode=server&size=200x200&language=]]..M.getLang()..[[" /></td>
                </tr>
            </table>]]

    whm.w = 224
    whm.h = 224
    whm_html.x = -9 
    whm_html.y = 5 

    whm_html:renderHtml(html_display_map_img)
    setOnDraw(whm, "M.close_modal_by_leav_over()")
end
-------------------------------------------------------------------
function M.close_modal_by_leav_over()
    if(getUI("ui:interface:webig_html_modal").active)then
        local mouse_new_x, mouse_new_y = getMousePos()
        local diff_x = math.abs(mouse_new_x - mouse_old_x)
        local diff_y = math.abs(mouse_new_y - mouse_old_y)

        if(diff_x > 14 or diff_y > 14)then
            M.close_modal()
        end
    end
end
-------------------------------------------------------------------
function M.close_modal()
    runAH(nil, "leave_modal", "group=ui:interface:webig_html_modal")
end
-------------------------------------------------------------------
function M.getAnimalName(index)
    local name = tostring(i18n.get(getUI("ui:interface"):find("userpa" .. index).title))
    name = name:gsub(" ", "%%20")
    
    return name
end
-------------------------------------------------------------------
function M.showTooltipMap(index)
    if(index_old ~= index and getUI("ui:interface:webig_html_modal").active)then
        M.close_modal()
    end

    if(not getUI("ui:interface:webig_html_modal").active)then
        local i64Pos = getDbProp64("SERVER:PACK_ANIMAL:BEAST" .. tostring(index - 1) .. ":POS")
        local pos = lib.getPos(i64Pos)  

        M.mouse_over_icon_over(pos, zoom, index)
        index_old = index
    end
end
-------------------------------------------------------------------
function M.getLang()
    local clientLang = getDbProp("UI:TEMP:LANGUAGE")
    local lang = "en"

    if(clientLang == 1)then lang = "fr" end
    if(clientLang == 2)then lang = "de" end
    if(clientLang == 3)then lang = "ru" end
    if(clientLang == 4)then lang = "es" end

    return lang
end
-------------------------------------------------------------------
-- overwrite tooltip does not work, don't know why
-------------------------------------------------------------------
function M.tooltipText()
    local lang = M.getLang()
    local ttTxt = "Test"
    local uiToolTip = getUI("ui:interface"):find("animal_pos")

    if(lang == "en")then
        ttTxt = "You don't know where your animal is and are searching for it? Use the minimap to locate it. The position of the animal is displayed on the minimap."
    elseif(lang == "fr")then
        ttTxt = "Vous ne savez pas où se trouve votre animal et vous le cherchez ? Utilisez la mini-carte pour le localiser. La position de l'animal est affichée sur la mini-carte."
    elseif(lang == "de")then
        ttTxt = "Du weisst nicht, wo dein Tier ist und suchst es? Verwende die Minikarte, um es zu finden. Die Position des Tieres wird auf der Minikarte angezeigt."
    elseif(lang == "ru")then
        ttTxt = "Вы не знаете, где находится ваше животное, и ищете его? Используйте мини-карту, чтобы его найти. Позиция животного отображается на мини-карте."
    elseif(lang == "es")then
        ttTxt = "¿No sabes dónde está tu animal y lo estás buscando? Usa el minimapa para encontrarlo. La posición del animal se muestra en el minimapa."
    end
print(uiToolTip.tooltip)
    uiToolTip.tooltip = ttTxt
end
-------------------------------------------------------------------
return M