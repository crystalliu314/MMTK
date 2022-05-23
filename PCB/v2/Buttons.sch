EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 8
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
L dk_Tactile-Switches:B3F-1000 S2
U 1 1 5F78B71E
P 1600 2450
F 0 "S2" H 1400 2800 60  0000 C CNN
F 1 "B3F-1000" H 1600 2700 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_SMD_6x6mm" H 1800 2650 60  0001 L CNN
F 3 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 1800 2750 60  0001 L CNN
F 4 "SW400-ND" H 1800 2850 60  0001 L CNN "Digi-Key_PN"
F 5 "B3F-1000" H 1800 2950 60  0001 L CNN "MPN"
F 6 "Switches" H 1800 3050 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 1800 3150 60  0001 L CNN "Family"
F 8 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 1800 3250 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/omron-electronics-inc-emc-div/B3F-1000/SW400-ND/33150" H 1800 3350 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 1800 3450 60  0001 L CNN "Description"
F 11 "Omron Electronics Inc-EMC Div" H 1800 3550 60  0001 L CNN "Manufacturer"
F 12 "Active" H 1800 3650 60  0001 L CNN "Status"
	1    1600 2450
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0132
U 1 1 5F78B72C
P 2100 1800
F 0 "#PWR0132" H 2100 1650 50  0001 C CNN
F 1 "+5V" H 2115 1973 50  0000 C CNN
F 2 "" H 2100 1800 50  0001 C CNN
F 3 "" H 2100 1800 50  0001 C CNN
	1    2100 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 1800 2100 1900
Text HLabel 2850 2350 2    50   Input ~ 0
BT0
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R17
U 1 1 5F83EB12
P 2100 2050
F 0 "R17" H 2168 2096 50  0000 L CNN
F 1 "10K" H 2168 2005 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2140 2040 50  0001 C CNN
F 3 "~" H 2100 2050 50  0001 C CNN
	1    2100 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 2350 2100 2350
Wire Wire Line
	2100 2200 2100 2350
Connection ~ 2100 2350
$Comp
L MMTK-rescue:C-Device-MMTK-rescue C25
U 1 1 5F843FD8
P 2100 2650
F 0 "C25" H 2215 2696 50  0000 L CNN
F 1 "100n" H 2215 2605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2138 2500 50  0001 C CNN
F 3 "~" H 2100 2650 50  0001 C CNN
	1    2100 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 2350 2100 2500
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0133
U 1 1 5F78B734
P 1400 2950
F 0 "#PWR0133" H 1400 2700 50  0001 C CNN
F 1 "GND" H 1405 2777 50  0000 C CNN
F 2 "" H 1400 2950 50  0001 C CNN
F 3 "" H 1400 2950 50  0001 C CNN
	1    1400 2950
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0134
U 1 1 5F846DF0
P 2100 2950
F 0 "#PWR0134" H 2100 2700 50  0001 C CNN
F 1 "GND" H 2105 2777 50  0000 C CNN
F 2 "" H 2100 2950 50  0001 C CNN
F 3 "" H 2100 2950 50  0001 C CNN
	1    2100 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 2950 2100 2800
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R19
U 1 1 5F847BD6
P 2500 2350
F 0 "R19" V 2295 2350 50  0000 C CNN
F 1 "100R" V 2386 2350 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2540 2340 50  0001 C CNN
F 3 "~" H 2500 2350 50  0001 C CNN
	1    2500 2350
	0    1    1    0   
$EndComp
Wire Wire Line
	2100 2350 2350 2350
Wire Wire Line
	2650 2350 2850 2350
Wire Wire Line
	1400 2550 1400 2950
$Comp
L dk_Tactile-Switches:B3F-1000 S4
U 1 1 5F84FD44
P 5150 2400
F 0 "S4" H 4950 2750 60  0000 C CNN
F 1 "B3F-1000" H 5150 2650 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_SMD_6x6mm" H 5350 2600 60  0001 L CNN
F 3 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 5350 2700 60  0001 L CNN
F 4 "SW400-ND" H 5350 2800 60  0001 L CNN "Digi-Key_PN"
F 5 "B3F-1000" H 5350 2900 60  0001 L CNN "MPN"
F 6 "Switches" H 5350 3000 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 5350 3100 60  0001 L CNN "Family"
F 8 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 5350 3200 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/omron-electronics-inc-emc-div/B3F-1000/SW400-ND/33150" H 5350 3300 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 5350 3400 60  0001 L CNN "Description"
F 11 "Omron Electronics Inc-EMC Div" H 5350 3500 60  0001 L CNN "Manufacturer"
F 12 "Active" H 5350 3600 60  0001 L CNN "Status"
	1    5150 2400
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0135
U 1 1 5F84FD4A
P 5650 1750
F 0 "#PWR0135" H 5650 1600 50  0001 C CNN
F 1 "+5V" H 5665 1923 50  0000 C CNN
F 2 "" H 5650 1750 50  0001 C CNN
F 3 "" H 5650 1750 50  0001 C CNN
	1    5650 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 1750 5650 1850
Text HLabel 6400 2300 2    50   Input ~ 0
BT1
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R21
U 1 1 5F84FD52
P 5650 2000
F 0 "R21" H 5718 2046 50  0000 L CNN
F 1 "10K" H 5718 1955 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5690 1990 50  0001 C CNN
F 3 "~" H 5650 2000 50  0001 C CNN
	1    5650 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 2300 5650 2300
Wire Wire Line
	5650 2150 5650 2300
Connection ~ 5650 2300
$Comp
L MMTK-rescue:C-Device-MMTK-rescue C27
U 1 1 5F84FD5B
P 5650 2600
F 0 "C27" H 5765 2646 50  0000 L CNN
F 1 "100n" H 5765 2555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 5688 2450 50  0001 C CNN
F 3 "~" H 5650 2600 50  0001 C CNN
	1    5650 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2300 5650 2450
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0136
U 1 1 5F84FD62
P 4950 2900
F 0 "#PWR0136" H 4950 2650 50  0001 C CNN
F 1 "GND" H 4955 2727 50  0000 C CNN
F 2 "" H 4950 2900 50  0001 C CNN
F 3 "" H 4950 2900 50  0001 C CNN
	1    4950 2900
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0137
U 1 1 5F84FD68
P 5650 2900
F 0 "#PWR0137" H 5650 2650 50  0001 C CNN
F 1 "GND" H 5655 2727 50  0000 C CNN
F 2 "" H 5650 2900 50  0001 C CNN
F 3 "" H 5650 2900 50  0001 C CNN
	1    5650 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2900 5650 2750
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R23
U 1 1 5F84FD6F
P 6050 2300
F 0 "R23" V 5845 2300 50  0000 C CNN
F 1 "100R" V 5936 2300 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6090 2290 50  0001 C CNN
F 3 "~" H 6050 2300 50  0001 C CNN
	1    6050 2300
	0    1    1    0   
$EndComp
Wire Wire Line
	5650 2300 5900 2300
Wire Wire Line
	6200 2300 6400 2300
Wire Wire Line
	4950 2500 4950 2900
$Comp
L dk_Tactile-Switches:B3F-1000 S3
U 1 1 5F854A42
P 1600 5150
F 0 "S3" H 1400 5500 60  0000 C CNN
F 1 "B3F-1000" H 1600 5400 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_SMD_6x6mm" H 1800 5350 60  0001 L CNN
F 3 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 1800 5450 60  0001 L CNN
F 4 "SW400-ND" H 1800 5550 60  0001 L CNN "Digi-Key_PN"
F 5 "B3F-1000" H 1800 5650 60  0001 L CNN "MPN"
F 6 "Switches" H 1800 5750 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 1800 5850 60  0001 L CNN "Family"
F 8 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 1800 5950 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/omron-electronics-inc-emc-div/B3F-1000/SW400-ND/33150" H 1800 6050 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 1800 6150 60  0001 L CNN "Description"
F 11 "Omron Electronics Inc-EMC Div" H 1800 6250 60  0001 L CNN "Manufacturer"
F 12 "Active" H 1800 6350 60  0001 L CNN "Status"
	1    1600 5150
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0138
U 1 1 5F854A48
P 2100 4500
F 0 "#PWR0138" H 2100 4350 50  0001 C CNN
F 1 "+5V" H 2115 4673 50  0000 C CNN
F 2 "" H 2100 4500 50  0001 C CNN
F 3 "" H 2100 4500 50  0001 C CNN
	1    2100 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 4500 2100 4600
Text HLabel 2850 5050 2    50   Input ~ 0
BT2
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R18
U 1 1 5F854A50
P 2100 4750
F 0 "R18" H 2168 4796 50  0000 L CNN
F 1 "10K" H 2168 4705 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2140 4740 50  0001 C CNN
F 3 "~" H 2100 4750 50  0001 C CNN
	1    2100 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 5050 2100 5050
Wire Wire Line
	2100 4900 2100 5050
Connection ~ 2100 5050
$Comp
L MMTK-rescue:C-Device-MMTK-rescue C26
U 1 1 5F854A59
P 2100 5350
F 0 "C26" H 2215 5396 50  0000 L CNN
F 1 "100n" H 2215 5305 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2138 5200 50  0001 C CNN
F 3 "~" H 2100 5350 50  0001 C CNN
	1    2100 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 5050 2100 5200
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0139
U 1 1 5F854A60
P 1400 5650
F 0 "#PWR0139" H 1400 5400 50  0001 C CNN
F 1 "GND" H 1405 5477 50  0000 C CNN
F 2 "" H 1400 5650 50  0001 C CNN
F 3 "" H 1400 5650 50  0001 C CNN
	1    1400 5650
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0140
U 1 1 5F854A66
P 2100 5650
F 0 "#PWR0140" H 2100 5400 50  0001 C CNN
F 1 "GND" H 2105 5477 50  0000 C CNN
F 2 "" H 2100 5650 50  0001 C CNN
F 3 "" H 2100 5650 50  0001 C CNN
	1    2100 5650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 5650 2100 5500
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R20
U 1 1 5F854A6D
P 2500 5050
F 0 "R20" V 2295 5050 50  0000 C CNN
F 1 "100R" V 2386 5050 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2540 5040 50  0001 C CNN
F 3 "~" H 2500 5050 50  0001 C CNN
	1    2500 5050
	0    1    1    0   
$EndComp
Wire Wire Line
	2100 5050 2350 5050
Wire Wire Line
	2650 5050 2850 5050
Wire Wire Line
	1400 5250 1400 5650
$Comp
L dk_Tactile-Switches:B3F-1000 S5
U 1 1 5F8584D2
P 5150 5100
F 0 "S5" H 4950 5450 60  0000 C CNN
F 1 "B3F-1000" H 5150 5350 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_SMD_6x6mm" H 5350 5300 60  0001 L CNN
F 3 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 5350 5400 60  0001 L CNN
F 4 "SW400-ND" H 5350 5500 60  0001 L CNN "Digi-Key_PN"
F 5 "B3F-1000" H 5350 5600 60  0001 L CNN "MPN"
F 6 "Switches" H 5350 5700 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 5350 5800 60  0001 L CNN "Family"
F 8 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 5350 5900 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/omron-electronics-inc-emc-div/B3F-1000/SW400-ND/33150" H 5350 6000 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 5350 6100 60  0001 L CNN "Description"
F 11 "Omron Electronics Inc-EMC Div" H 5350 6200 60  0001 L CNN "Manufacturer"
F 12 "Active" H 5350 6300 60  0001 L CNN "Status"
	1    5150 5100
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0141
U 1 1 5F8584D8
P 5650 4450
F 0 "#PWR0141" H 5650 4300 50  0001 C CNN
F 1 "+5V" H 5665 4623 50  0000 C CNN
F 2 "" H 5650 4450 50  0001 C CNN
F 3 "" H 5650 4450 50  0001 C CNN
	1    5650 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4450 5650 4550
Text HLabel 6400 5000 2    50   Input ~ 0
BT3
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R22
U 1 1 5F8584E0
P 5650 4700
F 0 "R22" H 5718 4746 50  0000 L CNN
F 1 "10K" H 5718 4655 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5690 4690 50  0001 C CNN
F 3 "~" H 5650 4700 50  0001 C CNN
	1    5650 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 5000 5650 5000
Wire Wire Line
	5650 4850 5650 5000
Connection ~ 5650 5000
$Comp
L MMTK-rescue:C-Device-MMTK-rescue C28
U 1 1 5F8584E9
P 5650 5300
F 0 "C28" H 5765 5346 50  0000 L CNN
F 1 "100n" H 5765 5255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 5688 5150 50  0001 C CNN
F 3 "~" H 5650 5300 50  0001 C CNN
	1    5650 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5000 5650 5150
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0142
U 1 1 5F8584F0
P 4950 5600
F 0 "#PWR0142" H 4950 5350 50  0001 C CNN
F 1 "GND" H 4955 5427 50  0000 C CNN
F 2 "" H 4950 5600 50  0001 C CNN
F 3 "" H 4950 5600 50  0001 C CNN
	1    4950 5600
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0143
U 1 1 5F8584F6
P 5650 5600
F 0 "#PWR0143" H 5650 5350 50  0001 C CNN
F 1 "GND" H 5655 5427 50  0000 C CNN
F 2 "" H 5650 5600 50  0001 C CNN
F 3 "" H 5650 5600 50  0001 C CNN
	1    5650 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5600 5650 5450
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R24
U 1 1 5F8584FD
P 6050 5000
F 0 "R24" V 5845 5000 50  0000 C CNN
F 1 "100R" V 5936 5000 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6090 4990 50  0001 C CNN
F 3 "~" H 6050 5000 50  0001 C CNN
	1    6050 5000
	0    1    1    0   
$EndComp
Wire Wire Line
	5650 5000 5900 5000
Wire Wire Line
	6200 5000 6400 5000
Wire Wire Line
	4950 5200 4950 5600
NoConn ~ 4950 5000
NoConn ~ 5350 5200
NoConn ~ 1400 5050
NoConn ~ 1800 5250
NoConn ~ 1400 2350
NoConn ~ 1800 2550
NoConn ~ 5350 2500
NoConn ~ 4950 2300
$Comp
L dk_Tactile-Switches:B3F-1000 S1
U 1 1 5F914AA0
P 8250 5100
F 0 "S1" H 8050 5450 60  0000 C CNN
F 1 "B3F-1000" H 8250 5350 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_SMD_6x6mm" H 8450 5300 60  0001 L CNN
F 3 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 8450 5400 60  0001 L CNN
F 4 "SW400-ND" H 8450 5500 60  0001 L CNN "Digi-Key_PN"
F 5 "B3F-1000" H 8450 5600 60  0001 L CNN "MPN"
F 6 "Switches" H 8450 5700 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 8450 5800 60  0001 L CNN "Family"
F 8 "https://omronfs.omron.com/en_US/ecb/products/pdf/en-b3f.pdf" H 8450 5900 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/omron-electronics-inc-emc-div/B3F-1000/SW400-ND/33150" H 8450 6000 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 8450 6100 60  0001 L CNN "Description"
F 11 "Omron Electronics Inc-EMC Div" H 8450 6200 60  0001 L CNN "Manufacturer"
F 12 "Active" H 8450 6300 60  0001 L CNN "Status"
	1    8250 5100
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:+5V-power-MMTK-rescue #PWR0108
U 1 1 5F914AA6
P 8750 4450
F 0 "#PWR0108" H 8750 4300 50  0001 C CNN
F 1 "+5V" H 8765 4623 50  0000 C CNN
F 2 "" H 8750 4450 50  0001 C CNN
F 3 "" H 8750 4450 50  0001 C CNN
	1    8750 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 4450 8750 4550
Text HLabel 9500 5000 2    50   Input ~ 0
BT4
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R31
U 1 1 5F914AAE
P 8750 4700
F 0 "R31" H 8818 4746 50  0000 L CNN
F 1 "10K" H 8818 4655 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 8790 4690 50  0001 C CNN
F 3 "~" H 8750 4700 50  0001 C CNN
	1    8750 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 5000 8750 5000
Wire Wire Line
	8750 4850 8750 5000
Connection ~ 8750 5000
$Comp
L MMTK-rescue:C-Device-MMTK-rescue C2
U 1 1 5F914AB7
P 8750 5300
F 0 "C2" H 8865 5346 50  0000 L CNN
F 1 "100n" H 8865 5255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8788 5150 50  0001 C CNN
F 3 "~" H 8750 5300 50  0001 C CNN
	1    8750 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 5000 8750 5150
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0111
U 1 1 5F914ABE
P 8050 5600
F 0 "#PWR0111" H 8050 5350 50  0001 C CNN
F 1 "GND" H 8055 5427 50  0000 C CNN
F 2 "" H 8050 5600 50  0001 C CNN
F 3 "" H 8050 5600 50  0001 C CNN
	1    8050 5600
	1    0    0    -1  
$EndComp
$Comp
L MMTK-rescue:GND-power-MMTK-rescue #PWR0112
U 1 1 5F914AC4
P 8750 5600
F 0 "#PWR0112" H 8750 5350 50  0001 C CNN
F 1 "GND" H 8755 5427 50  0000 C CNN
F 2 "" H 8750 5600 50  0001 C CNN
F 3 "" H 8750 5600 50  0001 C CNN
	1    8750 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 5600 8750 5450
$Comp
L MMTK-rescue:R_US-Device-MMTK-rescue R32
U 1 1 5F914ACB
P 9150 5000
F 0 "R32" V 8945 5000 50  0000 C CNN
F 1 "100R" V 9036 5000 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 9190 4990 50  0001 C CNN
F 3 "~" H 9150 5000 50  0001 C CNN
	1    9150 5000
	0    1    1    0   
$EndComp
Wire Wire Line
	8750 5000 9000 5000
Wire Wire Line
	9300 5000 9500 5000
Wire Wire Line
	8050 5200 8050 5600
NoConn ~ 8050 5000
NoConn ~ 8450 5200
$EndSCHEMATC
