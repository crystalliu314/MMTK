EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 8
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 7050 3350 2    50   Input ~ 0
ENN_OUT
Text HLabel 1400 3100 0    50   Input ~ 0
~ENN_ARD_IN
Wire Wire Line
	2050 2600 2250 2600
$Comp
L MMTK-rescue:Q_PMOS_GSD-Device-MMTK-rescue Q?
U 1 1 5F79773F
P 2450 2600
AR Path="/5F79773F" Ref="Q?"  Part="1" 
AR Path="/5F791A23/5F79773F" Ref="Q2"  Part="1" 
F 0 "Q2" H 2655 2554 50  0000 L CNN
F 1 "Q_PMOS_GSD" H 2655 2645 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 2650 2700 50  0001 C CNN
F 3 "~" H 2450 2600 50  0001 C CNN
	1    2450 2600
	1    0    0    1   
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR?
U 1 1 5F797738
P 2550 1700
AR Path="/5F797738" Ref="#PWR?"  Part="1" 
AR Path="/5F791A23/5F797738" Ref="#PWR0150"  Part="1" 
F 0 "#PWR0150" H 2550 1550 50  0001 C CNN
F 1 "+5V" H 2565 1873 50  0000 C CNN
F 2 "" H 2550 1700 50  0001 C CNN
F 3 "" H 2550 1700 50  0001 C CNN
	1    2550 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 2800 2550 3350
Wire Wire Line
	2550 3350 3500 3350
$Comp
L MMTK-rescue:Screw_Terminal_01x02-Connector-MMTK-rescue J7
U 1 1 5F79D733
P 4050 2700
F 0 "J7" H 3968 2375 50  0000 C CNN
F 1 "ESTOP_SOFT" H 3968 2466 50  0000 C CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_PT-1,5-2-3.5-H_1x02_P3.50mm_Horizontal" H 4050 2700 50  0001 C CNN
F 3 "~" H 4050 2700 50  0001 C CNN
	1    4050 2700
	-1   0    0    1   
$EndComp
Wire Wire Line
	4250 2700 4800 2700
Wire Wire Line
	4800 2700 4800 3350
Connection ~ 4800 3350
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR?
U 1 1 5F79EA8F
P 4800 2250
AR Path="/5F79EA8F" Ref="#PWR?"  Part="1" 
AR Path="/5F791A23/5F79EA8F" Ref="#PWR0151"  Part="1" 
F 0 "#PWR0151" H 4800 2100 50  0001 C CNN
F 1 "+5V" H 4815 2423 50  0000 C CNN
F 2 "" H 4800 2250 50  0001 C CNN
F 3 "" H 4800 2250 50  0001 C CNN
	1    4800 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 2250 4800 2600
Wire Wire Line
	4800 2600 4250 2600
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR?
U 1 1 5F7BF223
P 4800 3850
AR Path="/5F7781FA/5F7BF223" Ref="#PWR?"  Part="1" 
AR Path="/5F7BF223" Ref="#PWR?"  Part="1" 
AR Path="/5F791A23/5F7BF223" Ref="#PWR0152"  Part="1" 
F 0 "#PWR0152" H 4800 3600 50  0001 C CNN
F 1 "GND" H 4805 3677 50  0000 C CNN
F 2 "" H 4800 3850 50  0001 C CNN
F 3 "" H 4800 3850 50  0001 C CNN
	1    4800 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 3850 4800 3750
Wire Wire Line
	4800 3450 4800 3350
$Comp
L MMTK-rescue:LED-Device-MMTK-rescue D?
U 1 1 5F91E4E1
P 3500 4150
AR Path="/5F700C8F/5F91E4E1" Ref="D?"  Part="1" 
AR Path="/5F791A23/5F91E4E1" Ref="D3"  Part="1" 
AR Path="/5F91E4E1" Ref="D3"  Part="1" 
F 0 "D3" H 3493 3895 50  0000 C CNN
F 1 "RED" H 3493 3986 50  0000 C CNN
F 2 "LED_SMD:LED_0603_1608Metric" H 3500 4150 50  0001 C CNN
F 3 "~" H 3500 4150 50  0001 C CNN
	1    3500 4150
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3500 3900 3500 4000
Wire Wire Line
	3500 4300 3500 4450
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R?
U 1 1 5F91E4E9
P 3500 3750
AR Path="/5F6F52D9/5F91E4E9" Ref="R?"  Part="1" 
AR Path="/5F91E4E9" Ref="R?"  Part="1" 
AR Path="/5F791A23/5F91E4E9" Ref="R25"  Part="1" 
AR Path="/5F700C8F/5F91E4E9" Ref="R?"  Part="1" 
F 0 "R25" V 3295 3750 50  0000 C CNN
F 1 "200R/1%" V 3386 3750 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3540 3740 50  0001 C CNN
F 3 "~" H 3500 3750 50  0001 C CNN
	1    3500 3750
	-1   0    0    1   
$EndComp
Wire Wire Line
	3500 3600 3500 3350
Connection ~ 3500 3350
Wire Wire Line
	3500 3350 4800 3350
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR?
U 1 1 5F91F147
P 3500 4450
AR Path="/5F7781FA/5F91F147" Ref="#PWR?"  Part="1" 
AR Path="/5F91F147" Ref="#PWR?"  Part="1" 
AR Path="/5F791A23/5F91F147" Ref="#PWR0157"  Part="1" 
F 0 "#PWR0157" H 3500 4200 50  0001 C CNN
F 1 "GND" H 3505 4277 50  0000 C CNN
F 2 "" H 3500 4450 50  0001 C CNN
F 3 "" H 3500 4450 50  0001 C CNN
	1    3500 4450
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R?
U 1 1 5F9260F5
P 4800 3600
AR Path="/5F6A985A/5F9260F5" Ref="R?"  Part="1" 
AR Path="/5F791A23/5F9260F5" Ref="R33"  Part="1" 
F 0 "R33" H 5000 3550 50  0000 R CNN
F 1 "20K" H 5000 3650 50  0000 R CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 4840 3590 50  0001 C CNN
F 3 "~" H 4800 3600 50  0001 C CNN
	1    4800 3600
	-1   0    0    1   
$EndComp
$Comp
L dk_Transistors-FETs-MOSFETs-Single:2N7002 Q?
U 1 1 5F9B1343
P 2050 3000
AR Path="/5F700C8F/5F9B1343" Ref="Q?"  Part="1" 
AR Path="/5F791A23/5F9B1343" Ref="Q5"  Part="1" 
F 0 "Q5" H 2158 3053 60  0000 L CNN
F 1 "2N7002" H 2158 2947 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 2250 3200 60  0001 L CNN
F 3 "https://www.onsemi.com/pub/Collateral/NDS7002A-D.PDF" H 2250 3300 60  0001 L CNN
F 4 "2N7002NCT-ND" H 2250 3400 60  0001 L CNN "Digi-Key_PN"
F 5 "2N7002" H 2250 3500 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 2250 3600 60  0001 L CNN "Category"
F 7 "Transistors - FETs, MOSFETs - Single" H 2250 3700 60  0001 L CNN "Family"
F 8 "https://www.onsemi.com/pub/Collateral/NDS7002A-D.PDF" H 2250 3800 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/on-semiconductor/2N7002/2N7002NCT-ND/244664" H 2250 3900 60  0001 L CNN "DK_Detail_Page"
F 10 "MOSFET N-CH 60V 115MA SOT-23" H 2250 4000 60  0001 L CNN "Description"
F 11 "ON Semiconductor" H 2250 4100 60  0001 L CNN "Manufacturer"
F 12 "Active" H 2250 4200 60  0001 L CNN "Status"
	1    2050 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 2800 2050 2600
Wire Wire Line
	2550 1700 2550 1950
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R?
U 1 1 5F9B389C
P 2050 2350
AR Path="/5F6A985A/5F9B389C" Ref="R?"  Part="1" 
AR Path="/5F791A23/5F9B389C" Ref="R34"  Part="1" 
F 0 "R34" H 2250 2300 50  0000 R CNN
F 1 "20K" H 2250 2400 50  0000 R CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2090 2340 50  0001 C CNN
F 3 "~" H 2050 2350 50  0001 C CNN
	1    2050 2350
	-1   0    0    1   
$EndComp
Wire Wire Line
	2050 2600 2050 2500
Connection ~ 2050 2600
Wire Wire Line
	2050 2200 2050 1950
Wire Wire Line
	2050 1950 2550 1950
Connection ~ 2550 1950
Wire Wire Line
	2550 1950 2550 2400
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR?
U 1 1 5F9B4C0B
P 2050 3550
AR Path="/5F7781FA/5F9B4C0B" Ref="#PWR?"  Part="1" 
AR Path="/5F9B4C0B" Ref="#PWR?"  Part="1" 
AR Path="/5F791A23/5F9B4C0B" Ref="#PWR0158"  Part="1" 
F 0 "#PWR0158" H 2050 3300 50  0001 C CNN
F 1 "GND" H 2055 3377 50  0000 C CNN
F 2 "" H 2050 3550 50  0001 C CNN
F 3 "" H 2050 3550 50  0001 C CNN
	1    2050 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 3200 2050 3550
Wire Wire Line
	1400 3100 1750 3100
Wire Wire Line
	4800 3350 7050 3350
$EndSCHEMATC
