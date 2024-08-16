local printChat = require('util.print.chat');

return function(msg, color, msgType)
    if(msgType == nil)then
        msgType = 'SYS';
    end
    printChat(msg, msgType, color);
end
