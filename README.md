# crow_scripts

Monome crow script experiments

I'm still learning Lua, so be nice. Unkind devs are the worst.

- [`forgetter.lua`](forgetter.lua) - based on `quantizer.lua`. Takes incoming control voltages, and quantizes them to scales
- [`note_memory.lua`](note_memory.lua) - based on `shift-register.lua`. Stores last 8 incoming notes in a buffer, and then emits randomly selected notes from the buffer at one octave lower and one octave higher at two different time intervals.
