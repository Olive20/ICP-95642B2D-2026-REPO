#!/bin/bash

# ================================================
# Server Setup Automation Script
# Author: Olive Oparaocha
# Internship: InternCareerPath — ICP-95642B2D-2026
# Date: June 2026
# ================================================

LOG_FILE="logs/setup.log"
mkdir -p logs

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

handle_error() {
  echo "[ERROR] $1"
  log "ERROR: $1"
  exit 1
}

create_directories() {
  log "Creating directories..."
  for dir in config backup logs scripts data
  do
    if [ -d "$dir" ]
    then
      log "Directory $dir already exists. Skipping."
    else
      mkdir -p "$dir" || handle_error "Failed to create $dir"
      log "Created: $dir"
    fi
  done
}

create_config_files() {
  log "Creating config files..."
  for file in app.yaml db.yaml server.yaml
  do
    touch "config/$file" || handle_error "Failed to create $file"
    log "Created config: $file"
  done
}

assign_permissions() {
  log "Assigning permissions..."
  read -p "Enter username: " username
  read -p "Enter user group (admin/developer/viewer): " user_group

  case $user_group in
    admin)
      log "User $username — Full access granted"
      echo "Full access granted for $username"
      ;;
    developer)
      log "User $username — Read/write access granted"
      echo "Read/write access granted for $username"
      ;;
    viewer)
      log "User $username — Read only access granted"
      echo "Read only access granted for $username"
      ;;
    *)
      handle_error "Unknown group: $user_group"
      ;;
  esac
}

backup_configs() {
  log "Starting backup..."
  BACKUP_DIR="backup/$(date '+%Y-%m-%d_%H-%M-%S')"
  mkdir -p "$BACKUP_DIR"
  cp -r config/* "$BACKUP_DIR/" || handle_error "Backup failed"
  log "Backup saved to: $BACKUP_DIR"
}

show_summary() {
  echo ""
  echo "============================="
  echo "       SETUP SUMMARY"
  echo "============================="
  echo "Config files:"
  ls -l config/
  echo ""
  echo "Backup:"
  ls -l backup/
  echo ""
  echo "Log: $LOG_FILE"
  echo "============================="
}

# ── Main ──────────────────────────
log "===== Server Setup Started ====="
create_directories
create_config_files
assign_permissions
backup_configs
show_summary
log "===== Server Setup Complete ====="
