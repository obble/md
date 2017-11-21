
    
    local var = MODUI_VAR['elements']['questchat']

    UIErrorsFrame:SetTimeVisible(.3)
    UIErrorsFrame:SetFadeDuration(.3)

    local OnEvent = function(e, msg)
        if  e == 'UI_INFO_MESSAGE' then
            if  var then 
                ChatFrame1:AddMessage(msg, 1, 1, 0, 1)
            else
                this:AddMessage(
                    msg,
                    arg1,
                    arg2,
                    arg3,
                    1
                )
            end
        else
            this:AddMessage(
                msg,
                e == 'SYSMSG' and arg1 or  1,
                e == 'SYSMSG' and arg2 or .1,
                e == 'SYSMSG' and arg3 or .1,
                1
            )
        end
    end

    UIErrorsFrame_OnEvent = OnEvent


    --
