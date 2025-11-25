#!/bin/bash

# Author: Haitham Aouati
# GitHub: github.com/haithamaouati

# Colors
nc="\e[0m"
bold="\e[1m"
underline="\e[4m"
bold_green="\e[1;32m"
bold_red="\e[1;31m"
bold_yellow="\e[1;33m"

# Dependency check
for cmd in curl jq; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

# ASCII Banner
banner() {
    clear
    echo -e "${bold_green}"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠈⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣤⣄⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠾⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⣤⣶⣤⣉⣿⣿⡯⣀⣴⣿⡗⠀⠀⠀⠀⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⡈⠀⠀⠉⣿⣿⣶⡉⠀⠀⣀⡀⠀⠀⠀⢻⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⡇⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⢸⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠉⢉⣽⣿⠿⣿⡿⢻⣯⡍⢁⠄⠀⠀⠀⣸⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠐⡀⢉⠉⠀⠠⠀⢉⣉⠀⡜⠀⠀⠀⠀⣿⣿⣿⣿⣿"
    echo -e "⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠘⣤⣭⣟⠛⠛⣉⣁⡜⠀⠀⠀⠀⠀⠛⠿⣿⣿⣿"
    echo -e "⡿⠟⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⡀⠀⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    echo -e " Anon ${nc}— Random user generator.\n"
    echo -e " Author: Haitham Aouati"
    echo -e " GitHub: ${underline}github.com/haithamaouati${nc}\n"
}

banner

API_URL="https://randomuser.me/api/"

# Function to display help
show_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -n, --number <count>   Number of users to generate (default: 1)"
    echo "  -g, --gender <gender>  Filter by gender (male|female)"
    echo -e "  -h, --help             Show this help message\n"
}

# Default values
COUNT=1
GENDER=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n|--number)
            COUNT="$2"
            shift 2
            ;;
        -g|--gender)
            GENDER="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Build query parameters
PARAMS="?results=$COUNT"
if [[ -n "$GENDER" ]]; then
    PARAMS="$PARAMS&gender=$GENDER"
fi

# Fetch data
echo -e "${bold_green}[*]${nc} Generating random user...\n"
response=$(curl -s "${API_URL}${PARAMS}")

# Check for errors
if [[ $? -ne 0 || -z "$response" ]]; then
    echo "Error: Failed to fetch data from API."
    exit 1
fi

# Parse and display results using jq
echo -e "$response" | jq -r '
.results[] |
"Name: \(.name.title) \(.name.first) \(.name.last)
Gender: \(.gender)
Email: \(.email)
Phone: \(.phone)
Date of Birth: \(.dob.date | split("T")[0]) (\(.dob.age) years old)
Location: \(.location.city), \(.location.country)
Nationality: \(.nat)
Username: \(.login.username)
Password: \(.login.password)
Picture: \(.picture.large)
"
'
