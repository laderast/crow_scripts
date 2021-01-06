--- forgetter
-- based on quantizer.lua by s wolk 2019.10.15
-- in1: clock
-- in2: voltage to quantize
-- out1: in2 quantized to scale1 on clock pulses
-- out3: in2 quantized to scale2 on clock pulses
-- There is a probability that out1 or out3 won't output a note
-- on clock pulse - this makes things spare and more interesting

-- nb: scales should be written as semitones (cents optional) in ascending order
octaves = {0,12}
harmonicMinor = {0,2,3,5,7,8,10,12}
dorian = {0,2,3,5,7,9,10,12}
majorTriad = {0,4,7,12}
safe_notes = {0,2,5,7,9,12}
dominant7th = {0,4,7,10,12}

-- try re-assigning scale1/2 to change your quantizer!
scale1 = safe_notes
scale2 = dominant7th


function quantize(volts,scale) 
	local octave = math.floor(volts)
	local interval = volts - octave
	local semitones = interval / 12
	local degree = 1
	while degree < #scale and semitones > scale[degree+1]  do
		degree = degree + 1
	end
	local above = scale[degree+1] - semitones
	local below = semitones - scale[degree]
	if below > above then 
		degree = degree +1
	end
	local note = scale[degree]
	note = note + 12*octave
	return note
end

-- sample & hold handler; sets out1 & out2
input[1].change = function(state)
	-- sample input[2]
	local semi = 1 / 12
	local v = input[2].volts 
	local v2 = v + (6 * semi)

	local inter = semi * 4 
	
	-- quantize voltage to scale
	local note1 = quantize(v,scale1)
	local note2 = quantize(v2, scale2)

	local random_val = math.random(0,1)

	if random_val > 0.5 then
		output[1].volts = n2v(note1) 
	end
	
    local random_val2 = math.random(0,1)

	if random_val2 > 0.7 then
		output[3].volts = n2v(note2) 
    end
end


function init()
	input[1].mode('change',1,0.1,'rising')
	input[2].mode('stream',0.005)
	print('forgetter loaded')
end

