#!/usr/bin/env bash

GITLAB_DOMAIN="gitlab.$(cd ansible && ansible-inventory --host gitlab01 | jq -r .vault_domains.dv)"

declare -A gitlab_map=(
    ["."]="git@${GITLAB_DOMAIN}:andrei/homelab.git"
    ["ansible"]="git@${GITLAB_DOMAIN}:andrei/ansible.git"
    ["ansible/ansible_collections/andrei/utils"]="git@${GITLAB_DOMAIN}:andrei/ansible-collection-utils.git"
    ["ansible/roles/firewall_config"]="git@${GITLAB_DOMAIN}:andrei/ansible-role-firewall-config.git"
    ["ansible/roles/thanos"]="git@${GITLAB_DOMAIN}:andrei/ansible-role-thanos.git"
    ["ansible/roles/wireguard"]="git@${GITLAB_DOMAIN}:andrei/ansible-role-wireguard.git"
    ["ansible/roles/grafana"]="git@${GITLAB_DOMAIN}:andrei/ansible-grafana.git"
    ["ansible/roles/nginx"]="git@${GITLAB_DOMAIN}:andrei/ansible-nginx.git"
    ["ansible/roles/prometheus"]="git@${GITLAB_DOMAIN}:andrei/ansible-prometheus.git"
    ["ansible/roles/lego"]="git@${GITLAB_DOMAIN}:andrei/ansible-role-lego.git"
    ["ansible/roles/btrfs"]="git@${GITLAB_DOMAIN}:andrei/ansible-role-btrfs.git"
    ["packer"]="git@${GITLAB_DOMAIN}:andrei/packer.git"
    ["terraform"]="git@${GITLAB_DOMAIN}:andrei/terraform.git"
    ["network"]="git@${GITLAB_DOMAIN}:andrei/network.git"
    ["ansible-role-skeleton"]="git@${GITLAB_DOMAIN}:andrei/ansible-role-skeleton.git"
)

for dir in "${!gitlab_map[@]}"; do
    if git -C "$dir" remote show | grep -q gitlab; then
        echo "$dir already has gitlab defined"
        continue
    fi
    git -C "$dir" remote add gitlab "${gitlab_map[$dir]}"
    git -C "$dir" remote set-url --push origin "$(git -C "$dir" remote -v | grep origin | head -n1 | awk '{print $2}')"
    git -C "$dir" remote set-url --add --push origin "${gitlab_map[$dir]}"
    echo "$dir added ${gitlab_map[$dir]} as gitlab"
done
