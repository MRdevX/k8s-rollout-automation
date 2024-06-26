#!/bin/bash

# Author: Mahdi Rashidi / m8rashidi@gmail.com / 2024
# Medium: https://medium.com/@mrdevx/automating-kubernetes-deployment-restarts-a-practical-guide-8fe90fc53c36
# Github: https://github.com/MRdevX/k8s-rollout-automation

# Define namespaces and deployments
# Modify these arrays with your specific Kubernetes namespaces and deployment names

# Backend deployments
backend_development_deployments=(
    "namespace1 deployment1"
    "namespace2 deployment2"
)

backend_staging_deployments=(
    "namespace3 deployment3"
    "namespace4 deployment4"
)

backend_production_deployments=(
    "namespace5 deployment5"
    "namespace6 deployment6"
)

# Frontend deployments
frontend_development_deployments=(
    "namespace7 deployment7"
    "namespace8 deployment8"
)

frontend_staging_deployments=(
    "namespace9 deployment9"
    "namespace10 deployment10"
)

frontend_production_deployments=(
    "namespace11 deployment11"
    "namespace12 deployment12"
)

# Tools deployments
tools_deployments=(
    "namespace13 deployment13"
    "namespace14 deployment14"
)

# Function to restart a deployment
restart_deployment() {
    namespace=$1
    deployment=$2
    echo "Restarting deployment $deployment in namespace $namespace..."
    kubectl rollout restart deployment $deployment -n $namespace
}

# Function to select deployments from a given category
select_deployments_from_category() {
    local deployments=("$@")
    selected_deployments=()
    echo "Please select deployments to restart (enter 'all' to restart all deployments):"
    for i in "${!deployments[@]}"; do
        echo "$i) ${deployments[$i]}"
    done
    echo "Enter the numbers of the deployments you want to restart, separated by spaces, or type 'all':"
    read -a selections
    if [[ "${selections[0]}" == "all" ]]; then
        selected_deployments=("${deployments[@]}")
    else
        for i in "${selections[@]}"; do
            if [[ $i =~ ^[0-9]+$ ]] && [ $i -ge 0 ] && [ $i -lt ${#deployments[@]} ]; then
                selected_deployments+=("${deployments[$i]}")
            else
                echo "Invalid selection: $i"
            fi
        done
    fi
    echo "Selected deployments:"
    for dep in "${selected_deployments[@]}"; do
        echo "$dep"
    done
    echo "Do you want to proceed with restarting the selected deployments? (yes/no)"
    read proceed
    if [ "$proceed" != "yes" ]; then
        echo "Aborting."
        exit 1
    fi
}

# Function to select a category and then select deployments within that category
select_category() {
    echo "Please select a category:"
    echo "1) Backend"
    echo "2) Frontend"
    echo "3) Tools"
    read category

    case $category in
    1)
        echo "Selected category: Backend"
        select_environment "backend"
        ;;
    2)
        echo "Selected category: Frontend"
        select_environment "frontend"
        ;;
    3)
        echo "Selected category: Tools"
        select_deployments_from_category "${tools_deployments[@]}"
        ;;
    *)
        echo "Invalid category selection"
        exit 1
        ;;
    esac
}

# Function to select environment within a category
select_environment() {
    local category=$1
    echo "Please select an environment:"
    echo "1) Development"
    echo "2) Staging"
    echo "3) Production"
    read environment

    case $environment in
    1)
        echo "Selected environment: Development"
        if [ "$category" == "backend" ]; then
            select_deployments_from_category "${backend_development_deployments[@]}"
        elif [ "$category" == "frontend" ]; then
            select_deployments_from_category "${frontend_development_deployments[@]}"
        fi
        ;;
    2)
        echo "Selected environment: Staging"
        if [ "$category" == "backend" ]; then
            select_deployments_from_category "${backend_staging_deployments[@]}"
        elif [ "$category" == "frontend" ]; then
            select_deployments_from_category "${frontend_staging_deployments[@]}"
        fi
        ;;
    3)
        echo "Selected environment: Production"
        if [ "$category" == "backend" ]; then
            select_deployments_from_category "${backend_production_deployments[@]}"
        elif [ "$category" == "frontend" ]; then
            select_deployments_from_category "${frontend_production_deployments[@]}"
        fi
        ;;
    *)
        echo "Invalid environment selection"
        exit 1
        ;;
    esac
}

# Get user selections
select_category

# Restart the selected deployments
for item in "${selected_deployments[@]}"; do
    namespace=$(echo $item | awk '{print $1}')
    deployment=$(echo $item | awk '{print $2}')
    restart_deployment $namespace $deployment
done

echo "Selected deployments have been restarted."
