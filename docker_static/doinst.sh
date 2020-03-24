system_group docker

config etc/default/docker.default.new
config etc/rc.d/rc.docker.new
configdel etc/logrotate.d/docker.new

# Add Docker to rc.local, if it's not there.
if [[ -f etc/rc.d/rc.local ]] && ! grep -q /etc/rc.d/rc.docker etc/rc.d/rc.local; then
    echo "" >> etc/rc.d/rc.local
    echo "# Start Docker." >> etc/rc.d/rc.local
    echo "[[ -x /etc/rc.d/rc.docker ]] && (. /etc/rc.d/rc.docker start)" >> etc/rc.d/rc.local
    echo "" >> etc/rc.d/rc.local
fi

echo ""
echo "If you want Docker to run at startup:"
echo ""
echo "chmod +x /etc/rc.d/rc.docker"
