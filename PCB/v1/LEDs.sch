EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 7 8
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MMTK-rescue:LED-Device-MMTK-rescue D9
U 1 1 5F7010C1
P 4000 1950
F 0 "D9" H 3993 1695 50  0000 C CNN
F 1 "GRN" H 3993 1786 50  0000 C CNN
F 2 "LED_SMD:LED_0603_1608Metric" H 4000 1950 50  0001 C CNN
F 3 "~" H 4000 1950 50  0001 C CNN
	1    4000 1950
	0    -1   -1   0   
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0153
U 1 1 5F709653
P 4000 1600
F 0 "#PWR0153" H 4000 1450 50  0001 C CNN
F 1 "+5V" H 4015 1773 50  0000 C CNN
F 2 "" H 4000 1600 50  0001 C CNN
F 3 "" H 4000 1600 50  0001 C CNN
	1    4000 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 1600 4000 1800
Text HLabel 3300 3200 0    50   Input ~ 0
LED0
Wire Wire Line
	4000 2100 4000 2350
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0154
U 1 1 5F70CB55
P 4000 3900
F 0 "#PWR0154" H 4000 3650 50  0001 C CNN
F 1 "GND" H 4005 3727 50  0000 C CNN
F 2 "" H 4000 3900 50  0001 C CNN
F 3 "" H 4000 3900 50  0001 C CNN
	1    4000 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 3300 4000 3700
$Comp
L MMTK-rescue:LED-Device-MMTK-rescue D10
U 1 1 5F712E9E
P 7000 2000
F 0 "D10" H 6993 1745 50  0000 C CNN
F 1 "WHT" H 6993 1836 50  0000 C CNN
F 2 "LED_SMD:LED_0603_1608Metric" H 7000 2000 50  0001 C CNN
F 3 "~" H 7000 2000 50  0001 C CNN
	1    7000 2000
	0    -1   -1   0   
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0155
U 1 1 5F712EB4
P 7000 1650
F 0 "#PWR0155" H 7000 1500 50  0001 C CNN
F 1 "+5V" H 7015 1823 50  0000 C CNN
F 2 "" H 7000 1650 50  0001 C CNN
F 3 "" H 7000 1650 50  0001 C CNN
	1    7000 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 1650 7000 1850
Wire Wire Line
	7000 2150 7000 2400
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0156
U 1 1 5F712ECE
P 7000 4050
F 0 "#PWR0156" H 7000 3800 50  0001 C CNN
F 1 "GND" H 7005 3877 50  0000 C CNN
F 2 "" H 7000 4050 50  0001 C CNN
F 3 "" H 7000 4050 50  0001 C CNN
	1    7000 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 2700 7000 2900
Wire Wire Line
	7000 3300 7000 3850
Text HLabel 6100 3200 0    50   Input ~ 0
LED1
Wire Wire Line
	3550 3200 3300 3200
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R29
U 1 1 5F747BAF
P 6600 3500
F 0 "R29" V 6395 3500 50  0000 C CNN
F 1 "10K" V 6486 3500 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6640 3490 50  0001 C CNN
F 3 "~" H 6600 3500 50  0001 C CNN
	1    6600 3500
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R?
U 1 1 5F70C7A2
P 4000 2500
AR Path="/5F6F52D9/5F70C7A2" Ref="R?"  Part="1" 
AR Path="/5F70C7A2" Ref="R?"  Part="1" 
AR Path="/5F791A23/5F70C7A2" Ref="R?"  Part="1" 
AR Path="/5F700C8F/5F70C7A2" Ref="R28"  Part="1" 
F 0 "R28" V 3795 2500 50  0000 C CNN
F 1 "200R/1%" V 3886 2500 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 4040 2490 50  0001 C CNN
F 3 "~" H 4000 2500 50  0001 C CNN
	1    4000 2500
	-1   0    0    1   
$EndComp
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R?
U 1 1 5F70CAC1
P 7000 2550
AR Path="/5F6F52D9/5F70CAC1" Ref="R?"  Part="1" 
AR Path="/5F70CAC1" Ref="R?"  Part="1" 
AR Path="/5F791A23/5F70CAC1" Ref="R?"  Part="1" 
AR Path="/5F700C8F/5F70CAC1" Ref="R30"  Part="1" 
F 0 "R30" V 6795 2550 50  0000 C CNN
F 1 "200R/1%" V 6886 2550 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7040 2540 50  0001 C CNN
F 3 "~" H 7000 2550 50  0001 C CNN
	1    7000 2550
	-1   0    0    1   
$EndComp
$Comp
L dk_Transistors-FETs-MOSFETs-Single:2N7002 Q3
U 1 1 5F9BC788
P 4000 3100
F 0 "Q3" H 4108 3153 60  0000 L CNN
F 1 "2N7002" H 4108 3047 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 4200 3300 60  0001 L CNN
F 3 "https://www.onsemi.com/pub/Collateral/NDS7002A-D.PDF" H 4200 3400 60  0001 L CNN
F 4 "2N7002NCT-ND" H 4200 3500 60  0001 L CNN "Digi-Key_PN"
F 5 "2N7002" H 4200 3600 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 4200 3700 60  0001 L CNN "Category"
F 7 "Transistors - FETs, MOSFETs - Single" H 4200 3800 60  0001 L CNN "Family"
F 8 "https://www.onsemi.com/pub/Collateral/NDS7002A-D.PDF" H 4200 3900 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/on-semiconductor/2N7002/2N7002NCT-ND/244664" H 4200 4000 60  0001 L CNN "DK_Detail_Page"
F 10 "MOSFET N-CH 60V 115MA SOT-23" H 4200 4100 60  0001 L CNN "Description"
F 11 "ON Semiconductor" H 4200 4200 60  0001 L CNN "Manufacturer"
F 12 "Active" H 4200 4300 60  0001 L CNN "Status"
	1    4000 3100
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R27
U 1 1 5F746AB1
P 3550 3450
F 0 "R27" V 3345 3450 50  0000 C CNN
F 1 "10K" V 3436 3450 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3590 3440 50  0001 C CNN
F 3 "~" H 3550 3450 50  0001 C CNN
	1    3550 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2900 4000 2650
Wire Wire Line
	3550 3600 3550 3700
Wire Wire Line
	3550 3700 4000 3700
Connection ~ 4000 3700
Wire Wire Line
	4000 3700 4000 3900
Wire Wire Line
	3550 3300 3550 3200
Wire Wire Line
	3550 3200 3700 3200
Connection ~ 3550 3200
$Comp
L dk_Transistors-FETs-MOSFETs-Single:2N7002 Q4
U 1 1 5F9CFC81
P 7000 3100
F 0 "Q4" H 7108 3153 60  0000 L CNN
F 1 "2N7002" H 7108 3047 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 7200 3300 60  0001 L CNN
F 3 "https://www.onsemi.com/pub/Collateral/NDS7002A-D.PDF" H 7200 3400 60  0001 L CNN
F 4 "2N7002NCT-ND" H 7200 3500 60  0001 L CNN "Digi-Key_PN"
F 5 "2N7002" H 7200 3600 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 7200 3700 60  0001 L CNN "Category"
F 7 "Transistors - FETs, MOSFETs - Single" H 7200 3800 60  0001 L CNN "Family"
F 8 "https://www.onsemi.com/pub/Collateral/NDS7002A-D.PDF" H 7200 3900 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/on-semiconductor/2N7002/2N7002NCT-ND/244664" H 7200 4000 60  0001 L CNN "DK_Detail_Page"
F 10 "MOSFET N-CH 60V 115MA SOT-23" H 7200 4100 60  0001 L CNN "Description"
F 11 "ON Semiconductor" H 7200 4200 60  0001 L CNN "Manufacturer"
F 12 "Active" H 7200 4300 60  0001 L CNN "Status"
	1    7000 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 3350 6600 3200
Wire Wire Line
	6600 3200 6700 3200
Wire Wire Line
	6600 3650 6600 3850
Wire Wire Line
	6600 3850 7000 3850
Connection ~ 7000 3850
Wire Wire Line
	7000 3850 7000 4050
Wire Wire Line
	6100 3200 6600 3200
Connection ~ 6600 3200
$EndSCHEMATC
