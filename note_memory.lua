--- note memory - based on digital analog shift register
-- stores last 8 notes in a buffer and emits them on outputs 1 and 3
-- input 1: cv 
-- input 2: trigger to capture input & shift (usually gate)
-- output 1: random note (1 octave below original)
-- output 3: random note (1 octave above original)

reg = {}
reg_LEN = 8
index = 0
long_val = 8
short_val = 4
q = {}
function init()
    for n=1,4 do
        output[n].slew = 0
    end
    input[1].mode('none')
    input[2]{ mode      = 'change'
            , direction = 'rising',
            threshold = 1
            }
    for i=1,reg_LEN do
        reg[i] = input[1].volts
    end
end

function update(r)
    ind = math.random(1,reg_LEN)
    out_volt = r[ind] 
    output[1].volts = out_volt -1
    --output[3].volts = out_volt + (7/12)    
end

function update2(r)
    ind2 = math.random(1, reg_LEN)
    out_volt = r[ind2] 
    output[3].volts = out_volt + 1  
end


input[2].change = function()
    index = index + 1
    capture = input[1].volts
    table.remove(reg)
    table.insert(reg, 1, input[1].volts)
    if index % long_val == 0 then 
        update(reg)
    end
    if index % short_val == 0 then
        update2(reg)
    end
end
