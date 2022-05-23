EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 8
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5250 5500 2    50   Input ~ 0
LCD_SDA
Text HLabel 5250 5600 2    50   Input ~ 0
LCD_SCL
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0147
U 1 1 5F8917D9
P 6000 5100
F 0 "#PWR0147" H 6000 4850 50  0001 C CNN
F 1 "GND" H 6005 4927 50  0000 C CNN
F 2 "" H 6000 5100 50  0001 C CNN
F 3 "" H 6000 5100 50  0001 C CNN
	1    6000 5100
	-1   0    0    1   
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0148
U 1 1 5F89225F
P 6350 5300
F 0 "#PWR0148" H 6350 5150 50  0001 C CNN
F 1 "+5V" H 6365 5473 50  0000 C CNN
F 2 "" H 6350 5300 50  0001 C CNN
F 3 "" H 6350 5300 50  0001 C CNN
	1    6350 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 5300 6000 5100
Wire Wire Line
	4800 5300 6000 5300
Wire Wire Line
	4800 5500 5250 5500
Wire Wire Line
	5250 5600 4800 5600
Wire Wire Line
	4800 5400 6350 5400
Wire Wire Line
	6350 5300 6350 5400
$Comp
L MMTK-rescue:Conn_01x04_Female-Connector-MMTK-rescue J5
U 1 1 5F8909DC
P 4600 5400
F 0 "J5" H 4492 4975 50  0000 C CNN
F 1 "LCD" H 4492 5066 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Horizontal" H 4600 5400 50  0001 C CNN
F 3 "~" H 4600 5400 50  0001 C CNN
	1    4600 5400
	-1   0    0    -1  
$EndComp
$EndSCHEMATC
