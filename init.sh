#!/bin/sh
set -eu

# 用于设置 server.properties 中的特定属性值
set_game_property() {
    key=$1
    value=$2
    if [ -n "$value" ]; then
        escaped=$(printf '%s' "$value" | sed 's/[\/&]/\\&/g')
        sed -i "s|^${key}=.*|${key}=${escaped}|" "/app/server.properties"
    fi
}

# 用于设定 user_jvm_args.txt 中的特定属性值
set_jvm_property() {
    key=$1
    value=$2
    if [ -n "$value" ]; then
        escaped=$(printf '%s' "$value" | sed 's/[|&\\]/\\&/g')
        sed -i "s|{{ ${key} }}|${escaped}|g" "/app/user_jvm_args.txt"
    else
        sed -i "/{{ ${key} }}/d" "/app/user_jvm_args.txt"
    fi
}

set_jvm_property JVM_MEMORY "${JVM_MEMORY:-16G}"
set_jvm_property JVM_AUTHLIB_INJECTOR_URL "${JVM_AUTHLIB_INJECTOR_URL:-}"

set_game_property max-players "${GAME_MAX_PLAYERS:-8}"
set_game_property online-mode "${GAME_ONLINE_MODE:-true}"
set_game_property enable-rcon "${GAME_ENABLE_RCON:-false}"
set_game_property rcon.password "${GAME_RCON_PASSWORD:-}"

exec "$@"