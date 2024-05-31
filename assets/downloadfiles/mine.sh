# Minetest Server installieren
sudo apt update
sudo apt install -y minetest-server
 
# Minetest Konfigurationsdatei bearbeiten
config_file="/etc/minetest/minetest.conf"
sudo sed -i 's/^server_name .*/server_name = MeinMinetestServer/' "$config_file"
sudo sed -i 's/^server_address .*/server_address = 0.0.0.0/' "$config_file"
sudo sed -i 's/^server_port .*/server_port = 30000/' "$config_file"
sudo sed -i 's/^server_announce .*/server_announce = false/' "$config_file"
 
# Firewall-Regel hinzufügen
sudo ufw disable
 
# Minetest-Server neu starten, um Änderungen zu übernehmen
sudo systemctl restart minetest-server