onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /multicycle_tb/reset
add wave -noupdate /multicycle_tb/clock
add wave -noupdate -divider {Hex Display}
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in0
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in1
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in2
add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in3
add wave -noupdate -divider {multicycle.v inputs}
add wave -noupdate /multicycle_tb/KEY
add wave -noupdate /multicycle_tb/SW
add wave -noupdate -divider {multicycle.v outputs}
add wave -noupdate /multicycle_tb/LEDG
add wave -noupdate /multicycle_tb/LEDR
add wave -noupdate /multicycle_tb/DUT/IR1wire_out
add wave -noupdate /multicycle_tb/DUT/IR2wire_out
add wave -noupdate /multicycle_tb/DUT/IR3wire_out
add wave -noupdate /multicycle_tb/DUT/IR4wire_out

add wave -noupdate /multicycle_tb/DUT/PCwire
add wave -noupdate /multicycle_tb/DUT/ALUPCwire_out
add wave -noupdate /multicycle_tb/DUT/MEMwire_pc
add wave -noupdate /multicycle_tb/DUT/ALUwire
add wave -noupdate /multicycle_tb/DUT/ALU1wire
add wave -noupdate /multicycle_tb/DUT/PC3_out

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2500 ns} 0}
configure wave -namecolwidth 227
configure wave -valuecolwidth 57
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2500 ns}
