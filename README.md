# Fuel Logger

A simple Bash-based fuel economy logger for Linux.

Fuel Logger records fuel usage for multiple vehicles and calculates:

- **UK MPG**
- **Cost per mile**
- **Total fuel used**
- **Total fuel cost**
- **Accumulated partial top-ups**

## Features

- **Full refuel logging**
- **Partial fuel top-ups**
- **Automatic accumulation of partial fills**
- **UK MPG calculation**
- **Cost per mile calculation**
- **Support for multiple vehicles**
- **Support for vehicles with kilometre-based odometers**
- **Simple terminal interface**
- **No external database required**
- **Fuel records stored locally**

## Vehicles

The current version supports:

| Number | Vehicle | Odometer |
|---:|---|---|
| 1 | Peter | Miles |
| 2 | Monty | Miles |
| 3 | Doris | Miles |
| 4 | Quad | Kilometres |
| 5 | Bike | Miles |

The vehicle names can easily be changed in `fuel.sh`.

## Requirements

Fuel Logger requires:

- Linux
- Bash
- `bc`
- `awk`
- `tail`

Most Linux distributions already include Bash, `awk` and `tail`.

If `bc` is not installed, install it with your distribution's package manager.

### Debian / Ubuntu

`sudo apt install bc`


### Fedora

`sudo dnf install bc`


### Arch Linux

`sudo pacman -S bc`


## Installation

Clone the repository:

`git clone https://github.com/Michael-AUG/FuelTracker.git`

Enter the directory:

`cd Fuel`


Make the script executable:

`chmod +x fuel.sh`


Run it:

`./fuel.sh`


## Usage

When the program starts, you can choose between:

**What type of fuel entry?**

1. Full refuel
2. Partial top-up
3. Exit

### Full refuel

A full refuel records:

- **Date**
- **Litres**
- **Cost**
- **Odometer reading**

Any previously recorded partial top-ups for that vehicle are automatically added to the full refuel.

The program then calculates the fuel economy and resets the partial-fill totals.

### Partial top-up

A partial top-up records:

- **Litres**
- **Cost**

The information is held as a running total for that vehicle.

For example:

Top-up 1: 10 litres / £15.00 Top-up 2: 8 litres / £12.00 Top-up 3: 5 litres / £7.50


The next full refuel will use:

23 litres / £34.50


as part of the fuel economy calculation.

## Data Storage

Fuel records are stored in the local `data/` directory.

For example:

data/ ├── Peter ├── Monty ├── Doris ├── Quad └── Bike


Partial-fill totals are stored in hidden files such as:

.partLitresPeter .partCostPeter


The `data/` directory is excluded from Git by default so that personal fuel records are not accidentally uploaded to GitHub.

## Log Format

Each full refuel is stored as one line:

DATE MILES LITRES COST PENCEPERMILE MPG ODOMETER


For example:

08/10/26 312.45 42.31 61.25 19.60 33.58 45231


The Quad uses kilometres for its odometer. The distance is converted to miles before calculating fuel economy.

## UK MPG

Fuel economy is calculated using the UK gallon:

**1 UK gallon = 4.546 litres**

The calculation is:

MPG = miles / (litres / 4.546)


## GitHub

The project is designed to keep personal fuel records separate from the application.

Before committing the project:

`git status`


Make sure your personal `data/` files are not listed as files to be committed.

## Version

**Current version: 1.0**

## License

This project is provided for personal use. If you intend to distribute or modify it publicly, add an appropriate open-source licence.
