#!/bin/bash

echo "Date? DD/MM/YY"
read date
echo "Car?"
read car
echo "Litres?"
read litres
echo "Cost?"
read cost
echo "Odometer?"
read odometer
prevOdo=$(cat $car | tail -n 1 | awk '{print $NF}')
miles=$(echo "$odometer - $prevOdo" | bc)
pencePerMile=$(echo "scale=2; $cost / $miles" | bc)
mpg=$(echo "scale=2; $miles / ($litres * 0.22)" | bc)
echo "$date $miles $litres $cost $pencePerMile $mpg $odometer" >> ./$car
sleep 3
echo "Written to file"
echo "MPG = $mpg PPM = $pencePerMile"
