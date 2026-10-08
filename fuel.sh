#!/bin/bash

================================================================
Mìcheal's Fuel Logger
Version 1.0
================================================================

VERSION="1.0"

Directory containing this script

SCRIPTDIR="(cd"(dirname "${BASHSOURCE[0]}")" && pwd)"

Store fuel data relative to the script

FUELDIR="$SCRIPTDIR/data"

Create data directory if it doesn't exist

mkdir -p "$FUEL_DIR"

echo "Welcome to Mìcheal's Fuel Logger v$VERSION" echo "==========================================" echo ""

----------------------------------------------------------------
Functions
----------------------------------------------------------------

choose_vehicle() { while true; do echo "Vehicle?" echo "1. Peter" echo "2. Monty" echo "3. Doris" echo "4. Quad" echo "5. Bike" echo ""

read -r -p "Choice: " car

case "$car" in 1) carname="Peter" break ;; 2) carname="Monty" break ;; 3) carname="Doris" break ;; 4) carname="Quad" break ;; 5) carname="Bike" break ;; *) echo "Invalid choice. Please enter 1-5." echo "" ;; esac done }

read_number() { local prompt="$1" local value

while true; do read -r -p "$prompt" value

if [[ "value"= [0−9]+([.][0−9]+)? ]]; then echo "$value" return else echo "Please enter a valid number." >&2 fi done }

----------------------------------------------------------------
Choose operation
----------------------------------------------------------------

while true; do echo "What type of fuel entry?" echo "" echo "1. Full refuel" echo "2. Partial top-up" echo "3. Exit" echo ""

read -r -p "Choice: " filltype

case "$filltype" in 1|2) break ;; 3) echo "Goodbye." exit 0 ;; *) echo "Invalid choice. Please enter 1, 2 or 3." echo "" ;; esac done

----------------------------------------------------------------
Choose vehicle
----------------------------------------------------------------

choose_vehicle

partLitresFile="FUELDIR/.partLitrescarname" partCostFile="FUELDIR/.partCostcarname" logFile="FUELDIR/carname"

----------------------------------------------------------------
Partial top-up
----------------------------------------------------------------

if [ "$filltype" -eq 2 ]; then

echo "" echo "Partial top-up for $carname" echo "---------------------------"

litres=$(read_number "Litres? ")

if [ "car"−eq4];thencost=0elsecost=(read_number "Cost? ") fi

Create files if they don't exist

if [ ! -f "partLitresFile"];thenecho"0">"partLitresFile" fi

if [ ! -f "partCostFile"];thenecho"0">"partCostFile" fi

Read existing totals

prevLitres=(cat"partLitresFile") prevCost=(cat"partCostFile")

Add this top-up

newLitres=(echo"prevLitres + litres"∣bc)newCost=(echo "$prevCost + $cost" | bc)

Save totals

echo "newLitres">"partLitresFile" echo "newCost">"partCostFile"

echo "" echo "Partial top-up recorded." echo "" echo "Running total - litres: $newLitres" echo "Running total - cost: $newCost" echo ""

exit 0 fi

----------------------------------------------------------------
Full refuel
----------------------------------------------------------------

echo "" echo "Full refuel for $carname" echo "------------------------"

read -r -p "Date? DD/MM/YY: " date

litres=$(read_number "Litres? ")

if [ "car"−eq4];thencost=0elsecost=(read_number "Cost? ") fi

odometer=$(read_number "Odometer? ")

----------------------------------------------------------------
Previous odometer reading
----------------------------------------------------------------

if [ -f "logFile" ] && [ -s "logFile" ]; then prevOdo=(tail−n1"logFile" | awk '{print NF}') else prevOdo="odometer" fi

----------------------------------------------------------------
Read accumulated partial totals
----------------------------------------------------------------

if [ -f "partLitresFile"];thenpartLitres=(cat "$partLitresFile") else partLitres=0 fi

if [ -f "partCostFile"];thenpartCost=(cat "$partCostFile") else partCost=0 fi

----------------------------------------------------------------
Add partial totals to this full fill
----------------------------------------------------------------

totalLitres=(echo"litres + partLitres"∣bc)totalCost=(echo "$cost + $partCost" | bc)

----------------------------------------------------------------
Distance calculation
----------------------------------------------------------------
Quad stores odometer in KM.
All other vehicles store odometer readings in miles.

if [ "car"−eq4];thenmiles=(echo "scale=2; ($odometer - prevOdo)∗0.621371"∣bc)elsemiles=(echo "scale=2; $odometer - $prevOdo" | bc) fi

----------------------------------------------------------------
Pence per mile
----------------------------------------------------------------

if [ "car"−eq4];thenpencePerMile="N/A"elseif["(echo "miles>0"∣bc)"−eq1];thenpencePerMile=(echo "scale=2; $totalCost / $miles" | bc) else pencePerMile="N/A" fi fi

----------------------------------------------------------------
MPG calculation

#

1 UK gallon = 4.546 litres
----------------------------------------------------------------

if [ "(echo"totalLitres > 0" | bc)" -eq 1 ] && [ "(echo"miles > 0" | bc)" -eq 1 ]; then

mpg=$(echo "scale=2; miles/(totalLitres / 4.546)" | bc) else mpg="N/A" fi

----------------------------------------------------------------
Write log entry
----------------------------------------------------------------

echo "$date $miles $totalLitres $totalCost $pencePerMile $mpgodometer">>"logFile"

----------------------------------------------------------------
Reset partial totals
----------------------------------------------------------------

echo "0" > "partLitresFile"echo"0">"partCostFile"

----------------------------------------------------------------
Display results
----------------------------------------------------------------

echo "" echo "================================" echo "Fuel entry written to $carname" echo "================================" echo "" echo "MPG = $mpg" echo "PPM = $pencePerMile" echo "" echo "Included partial totals:" echo "Partial litres = $partLitres" echo "Partial cost = $partCost" echo "" echo "Total litres = $totalLitres" echo "Total cost = $totalCost" echo "" echo "Done."
