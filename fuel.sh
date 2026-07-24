#!/bin/bash

echo "Welcome to Mìcheal's Fuel Logger"
echo "================================"

sleep 1

echo "Date? DD/MM/YY"
read date

echo "Vehicle? 1 for Peter, 2 for Monty, 3 for Doris, 4 for Quad"
read car

if [ "$car" -eq 1 ]; then
    carname="Peter"
elif [ "$car" -eq 3 ]; then
    carname="Doris"
elif [ "$car" -eq 4 ]; then
    carname="Quad"
else
    carname="Monty"
fi

echo "Litres?"
read litres

if [ "$car" -eq 4 ]; then
    cost=0
else
    echo "Cost?"
    read cost
fi

echo "Odometer?"
read odometer

# Previous odometer reading
prevOdo=$(tail -n 1 "/home/gm5aug/michael/Fuel/$carname" | awk '{print $NF}')

# ------------------------------------------------------------------
# Read partial-fill running totals if they exist
# ------------------------------------------------------------------

partLitresFile="/home/gm5aug/michael/Fuel/.partLitres$carname"
partCostFile="/home/gm5aug/michael/Fuel/.partCost$carname"

if [ -f "$partLitresFile" ]; then
    partLitres=$(cat "$partLitresFile")
else
    partLitres=0
fi

if [ -f "$partCostFile" ]; then
    partCost=$(cat "$partCostFile")
else
    partCost=0
fi

# Add partial totals to this fill-up
totalLitres=$(echo "$litres + $partLitres" | bc)
totalCost=$(echo "$cost + $partCost" | bc)

# ------------------------------------------------------------------
# Distance calculation
# ------------------------------------------------------------------

# Quad stores odometer in KM, others in miles
if [ "$car" -eq 4 ]; then
    miles=$(echo "scale=2; ($odometer - $prevOdo) * 0.621371" | bc)
else
    miles=$(echo "scale=2; $odometer - $prevOdo" | bc)
fi

# ------------------------------------------------------------------
# Pence per mile
# ------------------------------------------------------------------

if [ "$car" -eq 4 ]; then
    pencePerMile="N/A"
else
    pencePerMile=$(echo "scale=2; $totalCost / $miles" | bc)
fi

# ------------------------------------------------------------------
# MPG calculation
# 1 UK gallon = 4.546 litres
# ------------------------------------------------------------------

mpg=$(echo "scale=2; $miles / ($totalLitres / 4.546)" | bc)

# ------------------------------------------------------------------
# Write log entry
# ------------------------------------------------------------------

echo "$date $miles $totalLitres $totalCost $pencePerMile $mpg $odometer" >> "/home/gm5aug/michael/Fuel/$carname"

# ------------------------------------------------------------------
# Reset partial totals after full fill-up
# ------------------------------------------------------------------

echo "0" > "$partLitresFile"
echo "0" > "$partCostFile"

sleep 3

echo "Written to file"
echo "MPG = $mpg PPM = $pencePerMile"

echo "Included partial totals:"
echo "Partial litres = $partLitres"
echo "Partial cost = $partCost"
